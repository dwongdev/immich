// dart format width=80
// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:immich_mobile/infrastructure/entities/remote_album_user.entity.drift.dart'
    as i1;
import 'package:immich_mobile/domain/models/album/album.model.dart' as i2;
import 'package:immich_mobile/infrastructure/entities/remote_album_user.entity.dart'
    as i3;
import 'package:immich_mobile/infrastructure/entities/remote_album.entity.drift.dart'
    as i4;
import 'package:drift/internal/modular.dart' as i5;
import 'package:immich_mobile/infrastructure/entities/user.entity.drift.dart'
    as i6;

typedef $$RemoteAlbumUserEntityTableCreateCompanionBuilder =
    i1.RemoteAlbumUserEntityCompanion Function({
      required String albumId,
      required String userId,
      required i2.AlbumUserRole role,
    });
typedef $$RemoteAlbumUserEntityTableUpdateCompanionBuilder =
    i1.RemoteAlbumUserEntityCompanion Function({
      i0.Value<String> albumId,
      i0.Value<String> userId,
      i0.Value<i2.AlbumUserRole> role,
    });

final class $$RemoteAlbumUserEntityTableReferences
    extends
        i0.BaseReferences<
          i0.GeneratedDatabase,
          i1.$RemoteAlbumUserEntityTable,
          i1.RemoteAlbumUserEntityData
        > {
  $$RemoteAlbumUserEntityTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static i4.$RemoteAlbumEntityTable _albumIdTable(i0.GeneratedDatabase db) =>
      i5.ReadDatabaseContainer(db)
          .resultSet<i4.$RemoteAlbumEntityTable>('remote_album_entity')
          .createAlias(
            i0.$_aliasNameGenerator(
              i5.ReadDatabaseContainer(db)
                  .resultSet<i1.$RemoteAlbumUserEntityTable>(
                    'remote_album_user_entity',
                  )
                  .albumId,
              i5.ReadDatabaseContainer(
                db,
              ).resultSet<i4.$RemoteAlbumEntityTable>('remote_album_entity').id,
            ),
          );

  i4.$$RemoteAlbumEntityTableProcessedTableManager get albumId {
    final $_column = $_itemColumn<String>('album_id')!;

    final manager = i4
        .$$RemoteAlbumEntityTableTableManager(
          $_db,
          i5.ReadDatabaseContainer(
            $_db,
          ).resultSet<i4.$RemoteAlbumEntityTable>('remote_album_entity'),
        )
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_albumIdTable($_db));
    if (item == null) return manager;
    return i0.ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static i6.$UserEntityTable _userIdTable(i0.GeneratedDatabase db) =>
      i5.ReadDatabaseContainer(db)
          .resultSet<i6.$UserEntityTable>('user_entity')
          .createAlias(
            i0.$_aliasNameGenerator(
              i5.ReadDatabaseContainer(db)
                  .resultSet<i1.$RemoteAlbumUserEntityTable>(
                    'remote_album_user_entity',
                  )
                  .userId,
              i5.ReadDatabaseContainer(
                db,
              ).resultSet<i6.$UserEntityTable>('user_entity').id,
            ),
          );

  i6.$$UserEntityTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = i6
        .$$UserEntityTableTableManager(
          $_db,
          i5.ReadDatabaseContainer(
            $_db,
          ).resultSet<i6.$UserEntityTable>('user_entity'),
        )
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return i0.ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RemoteAlbumUserEntityTableFilterComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$RemoteAlbumUserEntityTable> {
  $$RemoteAlbumUserEntityTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnWithTypeConverterFilters<i2.AlbumUserRole, i2.AlbumUserRole, int>
  get role => $composableBuilder(
    column: $table.role,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i4.$$RemoteAlbumEntityTableFilterComposer get albumId {
    final i4.$$RemoteAlbumEntityTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.albumId,
      referencedTable: i5.ReadDatabaseContainer(
        $db,
      ).resultSet<i4.$RemoteAlbumEntityTable>('remote_album_entity'),
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => i4.$$RemoteAlbumEntityTableFilterComposer(
            $db: $db,
            $table: i5.ReadDatabaseContainer(
              $db,
            ).resultSet<i4.$RemoteAlbumEntityTable>('remote_album_entity'),
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  i6.$$UserEntityTableFilterComposer get userId {
    final i6.$$UserEntityTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: i5.ReadDatabaseContainer(
        $db,
      ).resultSet<i6.$UserEntityTable>('user_entity'),
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => i6.$$UserEntityTableFilterComposer(
            $db: $db,
            $table: i5.ReadDatabaseContainer(
              $db,
            ).resultSet<i6.$UserEntityTable>('user_entity'),
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemoteAlbumUserEntityTableOrderingComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$RemoteAlbumUserEntityTable> {
  $$RemoteAlbumUserEntityTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnOrderings<int> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i4.$$RemoteAlbumEntityTableOrderingComposer get albumId {
    final i4.$$RemoteAlbumEntityTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.albumId,
          referencedTable: i5.ReadDatabaseContainer(
            $db,
          ).resultSet<i4.$RemoteAlbumEntityTable>('remote_album_entity'),
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => i4.$$RemoteAlbumEntityTableOrderingComposer(
                $db: $db,
                $table: i5.ReadDatabaseContainer(
                  $db,
                ).resultSet<i4.$RemoteAlbumEntityTable>('remote_album_entity'),
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  i6.$$UserEntityTableOrderingComposer get userId {
    final i6.$$UserEntityTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: i5.ReadDatabaseContainer(
        $db,
      ).resultSet<i6.$UserEntityTable>('user_entity'),
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => i6.$$UserEntityTableOrderingComposer(
            $db: $db,
            $table: i5.ReadDatabaseContainer(
              $db,
            ).resultSet<i6.$UserEntityTable>('user_entity'),
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemoteAlbumUserEntityTableAnnotationComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$RemoteAlbumUserEntityTable> {
  $$RemoteAlbumUserEntityTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.GeneratedColumnWithTypeConverter<i2.AlbumUserRole, int> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  i4.$$RemoteAlbumEntityTableAnnotationComposer get albumId {
    final i4.$$RemoteAlbumEntityTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.albumId,
          referencedTable: i5.ReadDatabaseContainer(
            $db,
          ).resultSet<i4.$RemoteAlbumEntityTable>('remote_album_entity'),
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => i4.$$RemoteAlbumEntityTableAnnotationComposer(
                $db: $db,
                $table: i5.ReadDatabaseContainer(
                  $db,
                ).resultSet<i4.$RemoteAlbumEntityTable>('remote_album_entity'),
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  i6.$$UserEntityTableAnnotationComposer get userId {
    final i6.$$UserEntityTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: i5.ReadDatabaseContainer(
        $db,
      ).resultSet<i6.$UserEntityTable>('user_entity'),
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => i6.$$UserEntityTableAnnotationComposer(
            $db: $db,
            $table: i5.ReadDatabaseContainer(
              $db,
            ).resultSet<i6.$UserEntityTable>('user_entity'),
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemoteAlbumUserEntityTableTableManager
    extends
        i0.RootTableManager<
          i0.GeneratedDatabase,
          i1.$RemoteAlbumUserEntityTable,
          i1.RemoteAlbumUserEntityData,
          i1.$$RemoteAlbumUserEntityTableFilterComposer,
          i1.$$RemoteAlbumUserEntityTableOrderingComposer,
          i1.$$RemoteAlbumUserEntityTableAnnotationComposer,
          $$RemoteAlbumUserEntityTableCreateCompanionBuilder,
          $$RemoteAlbumUserEntityTableUpdateCompanionBuilder,
          (
            i1.RemoteAlbumUserEntityData,
            i1.$$RemoteAlbumUserEntityTableReferences,
          ),
          i1.RemoteAlbumUserEntityData,
          i0.PrefetchHooks Function({bool albumId, bool userId})
        > {
  $$RemoteAlbumUserEntityTableTableManager(
    i0.GeneratedDatabase db,
    i1.$RemoteAlbumUserEntityTable table,
  ) : super(
        i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              i1.$$RemoteAlbumUserEntityTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              i1.$$RemoteAlbumUserEntityTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              i1.$$RemoteAlbumUserEntityTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                i0.Value<String> albumId = const i0.Value.absent(),
                i0.Value<String> userId = const i0.Value.absent(),
                i0.Value<i2.AlbumUserRole> role = const i0.Value.absent(),
              }) => i1.RemoteAlbumUserEntityCompanion(
                albumId: albumId,
                userId: userId,
                role: role,
              ),
          createCompanionCallback:
              ({
                required String albumId,
                required String userId,
                required i2.AlbumUserRole role,
              }) => i1.RemoteAlbumUserEntityCompanion.insert(
                albumId: albumId,
                userId: userId,
                role: role,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  i1.$$RemoteAlbumUserEntityTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({albumId = false, userId = false}) {
            return i0.PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends i0.TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (albumId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.albumId,
                                referencedTable: i1
                                    .$$RemoteAlbumUserEntityTableReferences
                                    ._albumIdTable(db),
                                referencedColumn: i1
                                    .$$RemoteAlbumUserEntityTableReferences
                                    ._albumIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: i1
                                    .$$RemoteAlbumUserEntityTableReferences
                                    ._userIdTable(db),
                                referencedColumn: i1
                                    .$$RemoteAlbumUserEntityTableReferences
                                    ._userIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RemoteAlbumUserEntityTableProcessedTableManager =
    i0.ProcessedTableManager<
      i0.GeneratedDatabase,
      i1.$RemoteAlbumUserEntityTable,
      i1.RemoteAlbumUserEntityData,
      i1.$$RemoteAlbumUserEntityTableFilterComposer,
      i1.$$RemoteAlbumUserEntityTableOrderingComposer,
      i1.$$RemoteAlbumUserEntityTableAnnotationComposer,
      $$RemoteAlbumUserEntityTableCreateCompanionBuilder,
      $$RemoteAlbumUserEntityTableUpdateCompanionBuilder,
      (i1.RemoteAlbumUserEntityData, i1.$$RemoteAlbumUserEntityTableReferences),
      i1.RemoteAlbumUserEntityData,
      i0.PrefetchHooks Function({bool albumId, bool userId})
    >;

class $RemoteAlbumUserEntityTable extends i3.RemoteAlbumUserEntity
    with
        i0.TableInfo<
          $RemoteAlbumUserEntityTable,
          i1.RemoteAlbumUserEntityData
        > {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemoteAlbumUserEntityTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _albumIdMeta = const i0.VerificationMeta(
    'albumId',
  );
  @override
  late final i0.GeneratedColumn<String> albumId = i0.GeneratedColumn<String>(
    'album_id',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
      'REFERENCES remote_album_entity (id) ON DELETE CASCADE',
    ),
  );
  static const i0.VerificationMeta _userIdMeta = const i0.VerificationMeta(
    'userId',
  );
  @override
  late final i0.GeneratedColumn<String> userId = i0.GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
      'REFERENCES user_entity (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final i0.GeneratedColumnWithTypeConverter<i2.AlbumUserRole, int> role =
      i0.GeneratedColumn<int>(
        'role',
        aliasedName,
        false,
        type: i0.DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<i2.AlbumUserRole>(
        i1.$RemoteAlbumUserEntityTable.$converterrole,
      );
  @override
  List<i0.GeneratedColumn> get $columns => [albumId, userId, role];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'remote_album_user_entity';
  @override
  i0.VerificationContext validateIntegrity(
    i0.Insertable<i1.RemoteAlbumUserEntityData> instance, {
    bool isInserting = false,
  }) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('album_id')) {
      context.handle(
        _albumIdMeta,
        albumId.isAcceptableOrUnknown(data['album_id']!, _albumIdMeta),
      );
    } else if (isInserting) {
      context.missing(_albumIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {albumId, userId};
  @override
  i1.RemoteAlbumUserEntityData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.RemoteAlbumUserEntityData(
      albumId: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}album_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      role: i1.$RemoteAlbumUserEntityTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.int,
          data['${effectivePrefix}role'],
        )!,
      ),
    );
  }

  @override
  $RemoteAlbumUserEntityTable createAlias(String alias) {
    return $RemoteAlbumUserEntityTable(attachedDatabase, alias);
  }

  static i0.JsonTypeConverter2<i2.AlbumUserRole, int, int> $converterrole =
      const i0.EnumIndexConverter<i2.AlbumUserRole>(i2.AlbumUserRole.values);
  @override
  bool get withoutRowId => true;
  @override
  bool get isStrict => true;
}

class RemoteAlbumUserEntityData extends i0.DataClass
    implements i0.Insertable<i1.RemoteAlbumUserEntityData> {
  final String albumId;
  final String userId;
  final i2.AlbumUserRole role;
  const RemoteAlbumUserEntityData({
    required this.albumId,
    required this.userId,
    required this.role,
  });
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['album_id'] = i0.Variable<String>(albumId);
    map['user_id'] = i0.Variable<String>(userId);
    {
      map['role'] = i0.Variable<int>(
        i1.$RemoteAlbumUserEntityTable.$converterrole.toSql(role),
      );
    }
    return map;
  }

  factory RemoteAlbumUserEntityData.fromJson(
    Map<String, dynamic> json, {
    i0.ValueSerializer? serializer,
  }) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return RemoteAlbumUserEntityData(
      albumId: serializer.fromJson<String>(json['albumId']),
      userId: serializer.fromJson<String>(json['userId']),
      role: i1.$RemoteAlbumUserEntityTable.$converterrole.fromJson(
        serializer.fromJson<int>(json['role']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'albumId': serializer.toJson<String>(albumId),
      'userId': serializer.toJson<String>(userId),
      'role': serializer.toJson<int>(
        i1.$RemoteAlbumUserEntityTable.$converterrole.toJson(role),
      ),
    };
  }

  i1.RemoteAlbumUserEntityData copyWith({
    String? albumId,
    String? userId,
    i2.AlbumUserRole? role,
  }) => i1.RemoteAlbumUserEntityData(
    albumId: albumId ?? this.albumId,
    userId: userId ?? this.userId,
    role: role ?? this.role,
  );
  RemoteAlbumUserEntityData copyWithCompanion(
    i1.RemoteAlbumUserEntityCompanion data,
  ) {
    return RemoteAlbumUserEntityData(
      albumId: data.albumId.present ? data.albumId.value : this.albumId,
      userId: data.userId.present ? data.userId.value : this.userId,
      role: data.role.present ? data.role.value : this.role,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RemoteAlbumUserEntityData(')
          ..write('albumId: $albumId, ')
          ..write('userId: $userId, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(albumId, userId, role);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.RemoteAlbumUserEntityData &&
          other.albumId == this.albumId &&
          other.userId == this.userId &&
          other.role == this.role);
}

class RemoteAlbumUserEntityCompanion
    extends i0.UpdateCompanion<i1.RemoteAlbumUserEntityData> {
  final i0.Value<String> albumId;
  final i0.Value<String> userId;
  final i0.Value<i2.AlbumUserRole> role;
  const RemoteAlbumUserEntityCompanion({
    this.albumId = const i0.Value.absent(),
    this.userId = const i0.Value.absent(),
    this.role = const i0.Value.absent(),
  });
  RemoteAlbumUserEntityCompanion.insert({
    required String albumId,
    required String userId,
    required i2.AlbumUserRole role,
  }) : albumId = i0.Value(albumId),
       userId = i0.Value(userId),
       role = i0.Value(role);
  static i0.Insertable<i1.RemoteAlbumUserEntityData> custom({
    i0.Expression<String>? albumId,
    i0.Expression<String>? userId,
    i0.Expression<int>? role,
  }) {
    return i0.RawValuesInsertable({
      if (albumId != null) 'album_id': albumId,
      if (userId != null) 'user_id': userId,
      if (role != null) 'role': role,
    });
  }

  i1.RemoteAlbumUserEntityCompanion copyWith({
    i0.Value<String>? albumId,
    i0.Value<String>? userId,
    i0.Value<i2.AlbumUserRole>? role,
  }) {
    return i1.RemoteAlbumUserEntityCompanion(
      albumId: albumId ?? this.albumId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (albumId.present) {
      map['album_id'] = i0.Variable<String>(albumId.value);
    }
    if (userId.present) {
      map['user_id'] = i0.Variable<String>(userId.value);
    }
    if (role.present) {
      map['role'] = i0.Variable<int>(
        i1.$RemoteAlbumUserEntityTable.$converterrole.toSql(role.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemoteAlbumUserEntityCompanion(')
          ..write('albumId: $albumId, ')
          ..write('userId: $userId, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }
}
