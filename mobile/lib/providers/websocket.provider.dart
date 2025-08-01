import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/domain/models/store.model.dart';
import 'package:immich_mobile/entities/asset.entity.dart';
import 'package:immich_mobile/entities/store.entity.dart';
import 'package:immich_mobile/models/server_info/server_version.model.dart';
import 'package:immich_mobile/providers/asset.provider.dart';
import 'package:immich_mobile/providers/auth.provider.dart';
import 'package:immich_mobile/providers/background_sync.provider.dart';
// import 'package:immich_mobile/providers/background_sync.provider.dart';
import 'package:immich_mobile/providers/db.provider.dart';
import 'package:immich_mobile/providers/server_info.provider.dart';
import 'package:immich_mobile/services/api.service.dart';
import 'package:immich_mobile/services/sync.service.dart';
import 'package:immich_mobile/utils/debounce.dart';
import 'package:logging/logging.dart';
import 'package:openapi/api.dart';
import 'package:socket_io_client/socket_io_client.dart';

enum PendingAction { assetDelete, assetUploaded, assetHidden, assetTrash }

class PendingChange {
  final String id;
  final PendingAction action;
  final dynamic value;

  const PendingChange(this.id, this.action, this.value);

  @override
  String toString() => 'PendingChange(id: $id, action: $action, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PendingChange && other.id == id && other.action == action;
  }

  @override
  int get hashCode => id.hashCode ^ action.hashCode;
}

class WebsocketState {
  final Socket? socket;
  final bool isConnected;
  final List<PendingChange> pendingChanges;

  const WebsocketState({this.socket, required this.isConnected, required this.pendingChanges});

  WebsocketState copyWith({Socket? socket, bool? isConnected, List<PendingChange>? pendingChanges}) {
    return WebsocketState(
      socket: socket ?? this.socket,
      isConnected: isConnected ?? this.isConnected,
      pendingChanges: pendingChanges ?? this.pendingChanges,
    );
  }

  @override
  String toString() => 'WebsocketState(socket: $socket, isConnected: $isConnected)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WebsocketState && other.socket == socket && other.isConnected == isConnected;
  }

  @override
  int get hashCode => socket.hashCode ^ isConnected.hashCode;
}

class WebsocketNotifier extends StateNotifier<WebsocketState> {
  WebsocketNotifier(this._ref) : super(const WebsocketState(socket: null, isConnected: false, pendingChanges: []));

  final _log = Logger('WebsocketNotifier');
  final Ref _ref;
  final Debouncer _debounce = Debouncer(interval: const Duration(milliseconds: 500));

  final Debouncer _batchDebouncer = Debouncer(
    interval: const Duration(seconds: 5),
    maxWaitTime: const Duration(seconds: 10),
  );
  final List<dynamic> _batchedAssetUploadReady = [];

  @override
  void dispose() {
    _batchDebouncer.dispose();
    super.dispose();
  }

  /// Connects websocket to server unless already connected
  void connect() {
    if (state.isConnected) return;
    final authenticationState = _ref.read(authProvider);

    if (authenticationState.isAuthenticated) {
      try {
        final endpoint = Uri.parse(Store.get(StoreKey.serverEndpoint));
        final headers = ApiService.getRequestHeaders();
        if (endpoint.userInfo.isNotEmpty) {
          headers["Authorization"] = "Basic ${base64.encode(utf8.encode(endpoint.userInfo))}";
        }

        debugPrint("Attempting to connect to websocket");
        // Configure socket transports must be specified
        Socket socket = io(
          endpoint.origin,
          OptionBuilder()
              .setPath("${endpoint.path}/socket.io")
              .setTransports(['websocket'])
              .enableReconnection()
              .enableForceNew()
              .enableForceNewConnection()
              .enableAutoConnect()
              .setExtraHeaders(headers)
              .build(),
        );

        socket.onConnect((_) {
          debugPrint("Established Websocket Connection");
          state = WebsocketState(isConnected: true, socket: socket, pendingChanges: state.pendingChanges);
        });

        socket.onDisconnect((_) {
          debugPrint("Disconnect to Websocket Connection");
          state = WebsocketState(isConnected: false, socket: null, pendingChanges: state.pendingChanges);
        });

        socket.on('error', (errorMessage) {
          _log.severe("Websocket Error - $errorMessage");
          state = WebsocketState(isConnected: false, socket: null, pendingChanges: state.pendingChanges);
        });

        if (!Store.isBetaTimelineEnabled) {
          socket.on('on_upload_success', _handleOnUploadSuccess);
          socket.on('on_asset_delete', _handleOnAssetDelete);
          socket.on('on_asset_trash', _handleOnAssetTrash);
          socket.on('on_asset_restore', _handleServerUpdates);
          socket.on('on_asset_update', _handleServerUpdates);
          socket.on('on_asset_stack_update', _handleServerUpdates);
          socket.on('on_asset_hidden', _handleOnAssetHidden);
        } else {
          socket.on('AssetUploadReadyV1', _handleSyncAssetUploadReady);
        }

        socket.on('on_config_update', _handleOnConfigUpdate);
        socket.on('on_new_release', _handleReleaseUpdates);
      } catch (e) {
        debugPrint("[WEBSOCKET] Catch Websocket Error - ${e.toString()}");
      }
    }
  }

  void disconnect() {
    debugPrint("Attempting to disconnect from websocket");

    _batchedAssetUploadReady.clear();

    var socket = state.socket?.disconnect();

    if (socket?.disconnected == true) {
      state = WebsocketState(isConnected: false, socket: null, pendingChanges: state.pendingChanges);
    }
  }

  void stopListenToEvent(String eventName) {
    state.socket?.off(eventName);
  }

  void stopListenToOldEvents() {
    state.socket?.off('on_upload_success');
    state.socket?.off('on_asset_delete');
    state.socket?.off('on_asset_trash');
    state.socket?.off('on_asset_restore');
    state.socket?.off('on_asset_update');
    state.socket?.off('on_asset_stack_update');
    state.socket?.off('on_asset_hidden');
  }

  void startListeningToOldEvents() {
    state.socket?.on('on_upload_success', _handleOnUploadSuccess);
    state.socket?.on('on_asset_delete', _handleOnAssetDelete);
    state.socket?.on('on_asset_trash', _handleOnAssetTrash);
    state.socket?.on('on_asset_restore', _handleServerUpdates);
    state.socket?.on('on_asset_update', _handleServerUpdates);
    state.socket?.on('on_asset_stack_update', _handleServerUpdates);
    state.socket?.on('on_asset_hidden', _handleOnAssetHidden);
  }

  void stopListeningToBetaEvents() {
    state.socket?.off('AssetUploadReadyV1');
  }

  void startListeningToBetaEvents() {
    state.socket?.on('AssetUploadReadyV1', _handleSyncAssetUploadReady);
  }

  void listenUploadEvent() {
    debugPrint("Start listening to event on_upload_success");
    state.socket?.on('on_upload_success', _handleOnUploadSuccess);
  }

  void addPendingChange(PendingAction action, dynamic value) {
    final now = DateTime.now();
    state = state.copyWith(
      pendingChanges: [...state.pendingChanges, PendingChange(now.millisecondsSinceEpoch.toString(), action, value)],
    );
    _debounce.run(handlePendingChanges);
  }

  Future<void> _handlePendingTrashes() async {
    final trashChanges = state.pendingChanges.where((c) => c.action == PendingAction.assetTrash).toList();
    if (trashChanges.isNotEmpty) {
      List<String> remoteIds = trashChanges.expand((a) => (a.value as List).map((e) => e.toString())).toList();

      await _ref.read(syncServiceProvider).handleRemoteAssetRemoval(remoteIds);
      await _ref.read(assetProvider.notifier).getAllAsset();

      state = state.copyWith(pendingChanges: state.pendingChanges.whereNot((c) => trashChanges.contains(c)).toList());
    }
  }

  Future<void> _handlePendingDeletes() async {
    final deleteChanges = state.pendingChanges.where((c) => c.action == PendingAction.assetDelete).toList();
    if (deleteChanges.isNotEmpty) {
      List<String> remoteIds = deleteChanges.map((a) => a.value.toString()).toList();
      await _ref.read(syncServiceProvider).handleRemoteAssetRemoval(remoteIds);
      state = state.copyWith(pendingChanges: state.pendingChanges.whereNot((c) => deleteChanges.contains(c)).toList());
    }
  }

  Future<void> _handlePendingUploaded() async {
    final uploadedChanges = state.pendingChanges.where((c) => c.action == PendingAction.assetUploaded).toList();
    if (uploadedChanges.isNotEmpty) {
      List<AssetResponseDto?> remoteAssets = uploadedChanges.map((a) => AssetResponseDto.fromJson(a.value)).toList();
      for (final dto in remoteAssets) {
        if (dto != null) {
          final newAsset = Asset.remote(dto);
          await _ref.watch(assetProvider.notifier).onNewAssetUploaded(newAsset);
        }
      }
      state = state.copyWith(
        pendingChanges: state.pendingChanges.whereNot((c) => uploadedChanges.contains(c)).toList(),
      );
    }
  }

  Future<void> _handlingPendingHidden() async {
    final hiddenChanges = state.pendingChanges.where((c) => c.action == PendingAction.assetHidden).toList();
    if (hiddenChanges.isNotEmpty) {
      List<String> remoteIds = hiddenChanges.map((a) => a.value.toString()).toList();
      final db = _ref.watch(dbProvider);
      await db.writeTxn(() => db.assets.deleteAllByRemoteId(remoteIds));

      state = state.copyWith(pendingChanges: state.pendingChanges.whereNot((c) => hiddenChanges.contains(c)).toList());
    }
  }

  Future<void> handlePendingChanges() async {
    await _handlePendingUploaded();
    await _handlePendingDeletes();
    await _handlingPendingHidden();
    await _handlePendingTrashes();
  }

  void _handleOnConfigUpdate(dynamic _) {
    _ref.read(serverInfoProvider.notifier).getServerFeatures();
    _ref.read(serverInfoProvider.notifier).getServerConfig();
  }

  // Refresh updated assets
  void _handleServerUpdates(dynamic _) {
    _ref.read(assetProvider.notifier).getAllAsset();
  }

  void _handleOnUploadSuccess(dynamic data) => addPendingChange(PendingAction.assetUploaded, data);

  void _handleOnAssetDelete(dynamic data) => addPendingChange(PendingAction.assetDelete, data);

  void _handleOnAssetTrash(dynamic data) {
    addPendingChange(PendingAction.assetTrash, data);
  }

  void _handleOnAssetHidden(dynamic data) => addPendingChange(PendingAction.assetHidden, data);

  _handleReleaseUpdates(dynamic data) {
    // Json guard
    if (data is! Map) {
      return;
    }

    final json = data.cast<String, dynamic>();
    final serverVersionJson = json.containsKey('serverVersion') ? json['serverVersion'] : null;
    final releaseVersionJson = json.containsKey('releaseVersion') ? json['releaseVersion'] : null;
    if (serverVersionJson == null || releaseVersionJson == null) {
      return;
    }

    final serverVersionDto = ServerVersionResponseDto.fromJson(serverVersionJson);
    final releaseVersionDto = ServerVersionResponseDto.fromJson(releaseVersionJson);
    if (serverVersionDto == null || releaseVersionDto == null) {
      return;
    }

    final serverVersion = ServerVersion.fromDto(serverVersionDto);
    final releaseVersion = ServerVersion.fromDto(releaseVersionDto);
    _ref.read(serverInfoProvider.notifier).handleNewRelease(serverVersion, releaseVersion);
  }

  void _handleSyncAssetUploadReady(dynamic data) {
    _batchedAssetUploadReady.add(data);
    _batchDebouncer.run(_processBatchedAssetUploadReady);
  }

  void _processBatchedAssetUploadReady() {
    if (_batchedAssetUploadReady.isEmpty) {
      return;
    }

    try {
      unawaited(_ref.read(backgroundSyncProvider).syncWebsocketBatch(_batchedAssetUploadReady.toList()));
    } catch (error) {
      _log.severe("Error processing batched AssetUploadReadyV1 events: $error");
    }

    _batchedAssetUploadReady.clear();
  }
}

final websocketProvider = StateNotifierProvider<WebsocketNotifier, WebsocketState>((ref) {
  return WebsocketNotifier(ref);
});
