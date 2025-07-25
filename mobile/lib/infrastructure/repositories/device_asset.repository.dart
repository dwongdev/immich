import 'package:immich_mobile/domain/models/device_asset.model.dart';
import 'package:immich_mobile/infrastructure/entities/device_asset.entity.dart';
import 'package:immich_mobile/infrastructure/repositories/db.repository.dart';
import 'package:isar/isar.dart';

class IsarDeviceAssetRepository extends IsarDatabaseRepository {
  final Isar _db;

  const IsarDeviceAssetRepository(this._db) : super(_db);

  Future<void> deleteIds(List<String> ids) {
    return transaction(() async {
      await _db.deviceAssetEntitys.deleteAllByAssetId(ids.toList());
    });
  }

  Future<List<DeviceAsset>> getByIds(List<String> localIds) {
    return _db.deviceAssetEntitys
        .where()
        .anyOf(localIds, (query, id) => query.assetIdEqualTo(id))
        .findAll()
        .then((value) => value.map((e) => e.toModel()).toList());
  }

  Future<bool> updateAll(List<DeviceAsset> assetHash) {
    return transaction(() async {
      await _db.deviceAssetEntitys.putAll(assetHash.map(DeviceAssetEntity.fromDto).toList());
      return true;
    });
  }
}
