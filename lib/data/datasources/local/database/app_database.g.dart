// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TiendasTable extends Tiendas with TableInfo<$TiendasTable, TiendaTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TiendasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _direccionMeta = const VerificationMeta(
    'direccion',
  );
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
    'direccion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ciudadMeta = const VerificationMeta('ciudad');
  @override
  late final GeneratedColumn<String> ciudad = GeneratedColumn<String>(
    'ciudad',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departamentoMeta = const VerificationMeta(
    'departamento',
  );
  @override
  late final GeneratedColumn<String> departamento = GeneratedColumn<String>(
    'departamento',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _horarioAtencionMeta = const VerificationMeta(
    'horarioAtencion',
  );
  @override
  late final GeneratedColumn<String> horarioAtencion = GeneratedColumn<String>(
    'horario_atencion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
    'sync_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncMeta = const VerificationMeta(
    'lastSync',
  );
  @override
  late final GeneratedColumn<DateTime> lastSync = GeneratedColumn<DateTime>(
    'last_sync',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    codigo,
    direccion,
    ciudad,
    departamento,
    telefono,
    horarioAtencion,
    activo,
    createdAt,
    updatedAt,
    deletedAt,
    syncId,
    lastSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tiendas';
  @override
  VerificationContext validateIntegrity(
    Insertable<TiendaTable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('direccion')) {
      context.handle(
        _direccionMeta,
        direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta),
      );
    } else if (isInserting) {
      context.missing(_direccionMeta);
    }
    if (data.containsKey('ciudad')) {
      context.handle(
        _ciudadMeta,
        ciudad.isAcceptableOrUnknown(data['ciudad']!, _ciudadMeta),
      );
    } else if (isInserting) {
      context.missing(_ciudadMeta);
    }
    if (data.containsKey('departamento')) {
      context.handle(
        _departamentoMeta,
        departamento.isAcceptableOrUnknown(
          data['departamento']!,
          _departamentoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_departamentoMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    }
    if (data.containsKey('horario_atencion')) {
      context.handle(
        _horarioAtencionMeta,
        horarioAtencion.isAcceptableOrUnknown(
          data['horario_atencion']!,
          _horarioAtencionMeta,
        ),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_id')) {
      context.handle(
        _syncIdMeta,
        syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta),
      );
    }
    if (data.containsKey('last_sync')) {
      context.handle(
        _lastSyncMeta,
        lastSync.isAcceptableOrUnknown(data['last_sync']!, _lastSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TiendaTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TiendaTable(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      direccion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direccion'],
      )!,
      ciudad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ciudad'],
      )!,
      departamento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}departamento'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      ),
      horarioAtencion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}horario_atencion'],
      ),
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_id'],
      ),
      lastSync: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync'],
      ),
    );
  }

  @override
  $TiendasTable createAlias(String alias) {
    return $TiendasTable(attachedDatabase, alias);
  }
}

class TiendaTable extends DataClass implements Insertable<TiendaTable> {
  final String id;
  final String nombre;
  final String codigo;
  final String direccion;
  final String ciudad;
  final String departamento;
  final String? telefono;
  final String? horarioAtencion;
  final bool activo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? syncId;
  final DateTime? lastSync;
  const TiendaTable({
    required this.id,
    required this.nombre,
    required this.codigo,
    required this.direccion,
    required this.ciudad,
    required this.departamento,
    this.telefono,
    this.horarioAtencion,
    required this.activo,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.syncId,
    this.lastSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['codigo'] = Variable<String>(codigo);
    map['direccion'] = Variable<String>(direccion);
    map['ciudad'] = Variable<String>(ciudad);
    map['departamento'] = Variable<String>(departamento);
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    if (!nullToAbsent || horarioAtencion != null) {
      map['horario_atencion'] = Variable<String>(horarioAtencion);
    }
    map['activo'] = Variable<bool>(activo);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || syncId != null) {
      map['sync_id'] = Variable<String>(syncId);
    }
    if (!nullToAbsent || lastSync != null) {
      map['last_sync'] = Variable<DateTime>(lastSync);
    }
    return map;
  }

  TiendasCompanion toCompanion(bool nullToAbsent) {
    return TiendasCompanion(
      id: Value(id),
      nombre: Value(nombre),
      codigo: Value(codigo),
      direccion: Value(direccion),
      ciudad: Value(ciudad),
      departamento: Value(departamento),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
      horarioAtencion: horarioAtencion == null && nullToAbsent
          ? const Value.absent()
          : Value(horarioAtencion),
      activo: Value(activo),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncId: syncId == null && nullToAbsent
          ? const Value.absent()
          : Value(syncId),
      lastSync: lastSync == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSync),
    );
  }

  factory TiendaTable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TiendaTable(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      codigo: serializer.fromJson<String>(json['codigo']),
      direccion: serializer.fromJson<String>(json['direccion']),
      ciudad: serializer.fromJson<String>(json['ciudad']),
      departamento: serializer.fromJson<String>(json['departamento']),
      telefono: serializer.fromJson<String?>(json['telefono']),
      horarioAtencion: serializer.fromJson<String?>(json['horarioAtencion']),
      activo: serializer.fromJson<bool>(json['activo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncId: serializer.fromJson<String?>(json['syncId']),
      lastSync: serializer.fromJson<DateTime?>(json['lastSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'codigo': serializer.toJson<String>(codigo),
      'direccion': serializer.toJson<String>(direccion),
      'ciudad': serializer.toJson<String>(ciudad),
      'departamento': serializer.toJson<String>(departamento),
      'telefono': serializer.toJson<String?>(telefono),
      'horarioAtencion': serializer.toJson<String?>(horarioAtencion),
      'activo': serializer.toJson<bool>(activo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncId': serializer.toJson<String?>(syncId),
      'lastSync': serializer.toJson<DateTime?>(lastSync),
    };
  }

  TiendaTable copyWith({
    String? id,
    String? nombre,
    String? codigo,
    String? direccion,
    String? ciudad,
    String? departamento,
    Value<String?> telefono = const Value.absent(),
    Value<String?> horarioAtencion = const Value.absent(),
    bool? activo,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> syncId = const Value.absent(),
    Value<DateTime?> lastSync = const Value.absent(),
  }) => TiendaTable(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    codigo: codigo ?? this.codigo,
    direccion: direccion ?? this.direccion,
    ciudad: ciudad ?? this.ciudad,
    departamento: departamento ?? this.departamento,
    telefono: telefono.present ? telefono.value : this.telefono,
    horarioAtencion: horarioAtencion.present
        ? horarioAtencion.value
        : this.horarioAtencion,
    activo: activo ?? this.activo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncId: syncId.present ? syncId.value : this.syncId,
    lastSync: lastSync.present ? lastSync.value : this.lastSync,
  );
  TiendaTable copyWithCompanion(TiendasCompanion data) {
    return TiendaTable(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      ciudad: data.ciudad.present ? data.ciudad.value : this.ciudad,
      departamento: data.departamento.present
          ? data.departamento.value
          : this.departamento,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      horarioAtencion: data.horarioAtencion.present
          ? data.horarioAtencion.value
          : this.horarioAtencion,
      activo: data.activo.present ? data.activo.value : this.activo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      lastSync: data.lastSync.present ? data.lastSync.value : this.lastSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TiendaTable(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('direccion: $direccion, ')
          ..write('ciudad: $ciudad, ')
          ..write('departamento: $departamento, ')
          ..write('telefono: $telefono, ')
          ..write('horarioAtencion: $horarioAtencion, ')
          ..write('activo: $activo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncId: $syncId, ')
          ..write('lastSync: $lastSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    codigo,
    direccion,
    ciudad,
    departamento,
    telefono,
    horarioAtencion,
    activo,
    createdAt,
    updatedAt,
    deletedAt,
    syncId,
    lastSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TiendaTable &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.codigo == this.codigo &&
          other.direccion == this.direccion &&
          other.ciudad == this.ciudad &&
          other.departamento == this.departamento &&
          other.telefono == this.telefono &&
          other.horarioAtencion == this.horarioAtencion &&
          other.activo == this.activo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncId == this.syncId &&
          other.lastSync == this.lastSync);
}

class TiendasCompanion extends UpdateCompanion<TiendaTable> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> codigo;
  final Value<String> direccion;
  final Value<String> ciudad;
  final Value<String> departamento;
  final Value<String?> telefono;
  final Value<String?> horarioAtencion;
  final Value<bool> activo;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> syncId;
  final Value<DateTime?> lastSync;
  final Value<int> rowid;
  const TiendasCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.codigo = const Value.absent(),
    this.direccion = const Value.absent(),
    this.ciudad = const Value.absent(),
    this.departamento = const Value.absent(),
    this.telefono = const Value.absent(),
    this.horarioAtencion = const Value.absent(),
    this.activo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TiendasCompanion.insert({
    required String id,
    required String nombre,
    required String codigo,
    required String direccion,
    required String ciudad,
    required String departamento,
    this.telefono = const Value.absent(),
    this.horarioAtencion = const Value.absent(),
    this.activo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       codigo = Value(codigo),
       direccion = Value(direccion),
       ciudad = Value(ciudad),
       departamento = Value(departamento);
  static Insertable<TiendaTable> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? codigo,
    Expression<String>? direccion,
    Expression<String>? ciudad,
    Expression<String>? departamento,
    Expression<String>? telefono,
    Expression<String>? horarioAtencion,
    Expression<bool>? activo,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncId,
    Expression<DateTime>? lastSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (codigo != null) 'codigo': codigo,
      if (direccion != null) 'direccion': direccion,
      if (ciudad != null) 'ciudad': ciudad,
      if (departamento != null) 'departamento': departamento,
      if (telefono != null) 'telefono': telefono,
      if (horarioAtencion != null) 'horario_atencion': horarioAtencion,
      if (activo != null) 'activo': activo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncId != null) 'sync_id': syncId,
      if (lastSync != null) 'last_sync': lastSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TiendasCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? codigo,
    Value<String>? direccion,
    Value<String>? ciudad,
    Value<String>? departamento,
    Value<String?>? telefono,
    Value<String?>? horarioAtencion,
    Value<bool>? activo,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? syncId,
    Value<DateTime?>? lastSync,
    Value<int>? rowid,
  }) {
    return TiendasCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      codigo: codigo ?? this.codigo,
      direccion: direccion ?? this.direccion,
      ciudad: ciudad ?? this.ciudad,
      departamento: departamento ?? this.departamento,
      telefono: telefono ?? this.telefono,
      horarioAtencion: horarioAtencion ?? this.horarioAtencion,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncId: syncId ?? this.syncId,
      lastSync: lastSync ?? this.lastSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (ciudad.present) {
      map['ciudad'] = Variable<String>(ciudad.value);
    }
    if (departamento.present) {
      map['departamento'] = Variable<String>(departamento.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (horarioAtencion.present) {
      map['horario_atencion'] = Variable<String>(horarioAtencion.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (lastSync.present) {
      map['last_sync'] = Variable<DateTime>(lastSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TiendasCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('direccion: $direccion, ')
          ..write('ciudad: $ciudad, ')
          ..write('departamento: $departamento, ')
          ..write('telefono: $telefono, ')
          ..write('horarioAtencion: $horarioAtencion, ')
          ..write('activo: $activo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncId: $syncId, ')
          ..write('lastSync: $lastSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RolesTable extends Roles with TableInfo<$RolesTable, RolTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RolesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _permisosMeta = const VerificationMeta(
    'permisos',
  );
  @override
  late final GeneratedColumn<String> permisos = GeneratedColumn<String>(
    'permisos',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    descripcion,
    permisos,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'roles';
  @override
  VerificationContext validateIntegrity(
    Insertable<RolTable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('permisos')) {
      context.handle(
        _permisosMeta,
        permisos.isAcceptableOrUnknown(data['permisos']!, _permisosMeta),
      );
    } else if (isInserting) {
      context.missing(_permisosMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RolTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RolTable(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      ),
      permisos: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}permisos'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RolesTable createAlias(String alias) {
    return $RolesTable(attachedDatabase, alias);
  }
}

class RolTable extends DataClass implements Insertable<RolTable> {
  final String id;
  final String nombre;
  final String? descripcion;
  final String permisos;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RolTable({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.permisos,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    map['permisos'] = Variable<String>(permisos);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RolesCompanion toCompanion(bool nullToAbsent) {
    return RolesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      permisos: Value(permisos),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RolTable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RolTable(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      permisos: serializer.fromJson<String>(json['permisos']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'descripcion': serializer.toJson<String?>(descripcion),
      'permisos': serializer.toJson<String>(permisos),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RolTable copyWith({
    String? id,
    String? nombre,
    Value<String?> descripcion = const Value.absent(),
    String? permisos,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RolTable(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    descripcion: descripcion.present ? descripcion.value : this.descripcion,
    permisos: permisos ?? this.permisos,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RolTable copyWithCompanion(RolesCompanion data) {
    return RolTable(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      permisos: data.permisos.present ? data.permisos.value : this.permisos,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RolTable(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('permisos: $permisos, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nombre, descripcion, permisos, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RolTable &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.descripcion == this.descripcion &&
          other.permisos == this.permisos &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RolesCompanion extends UpdateCompanion<RolTable> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String?> descripcion;
  final Value<String> permisos;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RolesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.permisos = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RolesCompanion.insert({
    required String id,
    required String nombre,
    this.descripcion = const Value.absent(),
    required String permisos,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       permisos = Value(permisos);
  static Insertable<RolTable> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? descripcion,
    Expression<String>? permisos,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (permisos != null) 'permisos': permisos,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RolesCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String?>? descripcion,
    Value<String>? permisos,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RolesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      permisos: permisos ?? this.permisos,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (permisos.present) {
      map['permisos'] = Variable<String>(permisos.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RolesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('permisos: $permisos, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsuariosTable extends Usuarios
    with TableInfo<$UsuariosTable, UsuarioTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsuariosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nombreCompletoMeta = const VerificationMeta(
    'nombreCompleto',
  );
  @override
  late final GeneratedColumn<String> nombreCompleto = GeneratedColumn<String>(
    'nombre_completo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tiendaIdMeta = const VerificationMeta(
    'tiendaId',
  );
  @override
  late final GeneratedColumn<String> tiendaId = GeneratedColumn<String>(
    'tienda_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tiendas (id)',
    ),
  );
  static const VerificationMeta _rolIdMeta = const VerificationMeta('rolId');
  @override
  late final GeneratedColumn<String> rolId = GeneratedColumn<String>(
    'rol_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES roles (id)',
    ),
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
    'sync_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncMeta = const VerificationMeta(
    'lastSync',
  );
  @override
  late final GeneratedColumn<DateTime> lastSync = GeneratedColumn<DateTime>(
    'last_sync',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    email,
    nombreCompleto,
    telefono,
    tiendaId,
    rolId,
    activo,
    createdAt,
    updatedAt,
    deletedAt,
    syncId,
    lastSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usuarios';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsuarioTable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('nombre_completo')) {
      context.handle(
        _nombreCompletoMeta,
        nombreCompleto.isAcceptableOrUnknown(
          data['nombre_completo']!,
          _nombreCompletoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreCompletoMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    }
    if (data.containsKey('tienda_id')) {
      context.handle(
        _tiendaIdMeta,
        tiendaId.isAcceptableOrUnknown(data['tienda_id']!, _tiendaIdMeta),
      );
    }
    if (data.containsKey('rol_id')) {
      context.handle(
        _rolIdMeta,
        rolId.isAcceptableOrUnknown(data['rol_id']!, _rolIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rolIdMeta);
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_id')) {
      context.handle(
        _syncIdMeta,
        syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta),
      );
    }
    if (data.containsKey('last_sync')) {
      context.handle(
        _lastSyncMeta,
        lastSync.isAcceptableOrUnknown(data['last_sync']!, _lastSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsuarioTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsuarioTable(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      nombreCompleto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_completo'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      ),
      tiendaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tienda_id'],
      ),
      rolId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rol_id'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_id'],
      ),
      lastSync: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync'],
      ),
    );
  }

  @override
  $UsuariosTable createAlias(String alias) {
    return $UsuariosTable(attachedDatabase, alias);
  }
}

class UsuarioTable extends DataClass implements Insertable<UsuarioTable> {
  final String id;
  final String email;
  final String nombreCompleto;
  final String? telefono;
  final String? tiendaId;
  final String rolId;
  final bool activo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? syncId;
  final DateTime? lastSync;
  const UsuarioTable({
    required this.id,
    required this.email,
    required this.nombreCompleto,
    this.telefono,
    this.tiendaId,
    required this.rolId,
    required this.activo,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.syncId,
    this.lastSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    map['nombre_completo'] = Variable<String>(nombreCompleto);
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    if (!nullToAbsent || tiendaId != null) {
      map['tienda_id'] = Variable<String>(tiendaId);
    }
    map['rol_id'] = Variable<String>(rolId);
    map['activo'] = Variable<bool>(activo);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || syncId != null) {
      map['sync_id'] = Variable<String>(syncId);
    }
    if (!nullToAbsent || lastSync != null) {
      map['last_sync'] = Variable<DateTime>(lastSync);
    }
    return map;
  }

  UsuariosCompanion toCompanion(bool nullToAbsent) {
    return UsuariosCompanion(
      id: Value(id),
      email: Value(email),
      nombreCompleto: Value(nombreCompleto),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
      tiendaId: tiendaId == null && nullToAbsent
          ? const Value.absent()
          : Value(tiendaId),
      rolId: Value(rolId),
      activo: Value(activo),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncId: syncId == null && nullToAbsent
          ? const Value.absent()
          : Value(syncId),
      lastSync: lastSync == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSync),
    );
  }

  factory UsuarioTable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsuarioTable(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      nombreCompleto: serializer.fromJson<String>(json['nombreCompleto']),
      telefono: serializer.fromJson<String?>(json['telefono']),
      tiendaId: serializer.fromJson<String?>(json['tiendaId']),
      rolId: serializer.fromJson<String>(json['rolId']),
      activo: serializer.fromJson<bool>(json['activo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncId: serializer.fromJson<String?>(json['syncId']),
      lastSync: serializer.fromJson<DateTime?>(json['lastSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'nombreCompleto': serializer.toJson<String>(nombreCompleto),
      'telefono': serializer.toJson<String?>(telefono),
      'tiendaId': serializer.toJson<String?>(tiendaId),
      'rolId': serializer.toJson<String>(rolId),
      'activo': serializer.toJson<bool>(activo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncId': serializer.toJson<String?>(syncId),
      'lastSync': serializer.toJson<DateTime?>(lastSync),
    };
  }

  UsuarioTable copyWith({
    String? id,
    String? email,
    String? nombreCompleto,
    Value<String?> telefono = const Value.absent(),
    Value<String?> tiendaId = const Value.absent(),
    String? rolId,
    bool? activo,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> syncId = const Value.absent(),
    Value<DateTime?> lastSync = const Value.absent(),
  }) => UsuarioTable(
    id: id ?? this.id,
    email: email ?? this.email,
    nombreCompleto: nombreCompleto ?? this.nombreCompleto,
    telefono: telefono.present ? telefono.value : this.telefono,
    tiendaId: tiendaId.present ? tiendaId.value : this.tiendaId,
    rolId: rolId ?? this.rolId,
    activo: activo ?? this.activo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncId: syncId.present ? syncId.value : this.syncId,
    lastSync: lastSync.present ? lastSync.value : this.lastSync,
  );
  UsuarioTable copyWithCompanion(UsuariosCompanion data) {
    return UsuarioTable(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      nombreCompleto: data.nombreCompleto.present
          ? data.nombreCompleto.value
          : this.nombreCompleto,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      tiendaId: data.tiendaId.present ? data.tiendaId.value : this.tiendaId,
      rolId: data.rolId.present ? data.rolId.value : this.rolId,
      activo: data.activo.present ? data.activo.value : this.activo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      lastSync: data.lastSync.present ? data.lastSync.value : this.lastSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsuarioTable(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('nombreCompleto: $nombreCompleto, ')
          ..write('telefono: $telefono, ')
          ..write('tiendaId: $tiendaId, ')
          ..write('rolId: $rolId, ')
          ..write('activo: $activo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncId: $syncId, ')
          ..write('lastSync: $lastSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    email,
    nombreCompleto,
    telefono,
    tiendaId,
    rolId,
    activo,
    createdAt,
    updatedAt,
    deletedAt,
    syncId,
    lastSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsuarioTable &&
          other.id == this.id &&
          other.email == this.email &&
          other.nombreCompleto == this.nombreCompleto &&
          other.telefono == this.telefono &&
          other.tiendaId == this.tiendaId &&
          other.rolId == this.rolId &&
          other.activo == this.activo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncId == this.syncId &&
          other.lastSync == this.lastSync);
}

class UsuariosCompanion extends UpdateCompanion<UsuarioTable> {
  final Value<String> id;
  final Value<String> email;
  final Value<String> nombreCompleto;
  final Value<String?> telefono;
  final Value<String?> tiendaId;
  final Value<String> rolId;
  final Value<bool> activo;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> syncId;
  final Value<DateTime?> lastSync;
  final Value<int> rowid;
  const UsuariosCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.nombreCompleto = const Value.absent(),
    this.telefono = const Value.absent(),
    this.tiendaId = const Value.absent(),
    this.rolId = const Value.absent(),
    this.activo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsuariosCompanion.insert({
    required String id,
    required String email,
    required String nombreCompleto,
    this.telefono = const Value.absent(),
    this.tiendaId = const Value.absent(),
    required String rolId,
    this.activo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       email = Value(email),
       nombreCompleto = Value(nombreCompleto),
       rolId = Value(rolId);
  static Insertable<UsuarioTable> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? nombreCompleto,
    Expression<String>? telefono,
    Expression<String>? tiendaId,
    Expression<String>? rolId,
    Expression<bool>? activo,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncId,
    Expression<DateTime>? lastSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (nombreCompleto != null) 'nombre_completo': nombreCompleto,
      if (telefono != null) 'telefono': telefono,
      if (tiendaId != null) 'tienda_id': tiendaId,
      if (rolId != null) 'rol_id': rolId,
      if (activo != null) 'activo': activo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncId != null) 'sync_id': syncId,
      if (lastSync != null) 'last_sync': lastSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsuariosCompanion copyWith({
    Value<String>? id,
    Value<String>? email,
    Value<String>? nombreCompleto,
    Value<String?>? telefono,
    Value<String?>? tiendaId,
    Value<String>? rolId,
    Value<bool>? activo,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? syncId,
    Value<DateTime?>? lastSync,
    Value<int>? rowid,
  }) {
    return UsuariosCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      telefono: telefono ?? this.telefono,
      tiendaId: tiendaId ?? this.tiendaId,
      rolId: rolId ?? this.rolId,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncId: syncId ?? this.syncId,
      lastSync: lastSync ?? this.lastSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (nombreCompleto.present) {
      map['nombre_completo'] = Variable<String>(nombreCompleto.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (tiendaId.present) {
      map['tienda_id'] = Variable<String>(tiendaId.value);
    }
    if (rolId.present) {
      map['rol_id'] = Variable<String>(rolId.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (lastSync.present) {
      map['last_sync'] = Variable<DateTime>(lastSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsuariosCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('nombreCompleto: $nombreCompleto, ')
          ..write('telefono: $telefono, ')
          ..write('tiendaId: $tiendaId, ')
          ..write('rolId: $rolId, ')
          ..write('activo: $activo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncId: $syncId, ')
          ..write('lastSync: $lastSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlmacenesTable extends Almacenes
    with TableInfo<$AlmacenesTable, AlmacenTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlmacenesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _tiendaIdMeta = const VerificationMeta(
    'tiendaId',
  );
  @override
  late final GeneratedColumn<String> tiendaId = GeneratedColumn<String>(
    'tienda_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tiendas (id)',
    ),
  );
  static const VerificationMeta _ubicacionMeta = const VerificationMeta(
    'ubicacion',
  );
  @override
  late final GeneratedColumn<String> ubicacion = GeneratedColumn<String>(
    'ubicacion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capacidadM3Meta = const VerificationMeta(
    'capacidadM3',
  );
  @override
  late final GeneratedColumn<double> capacidadM3 = GeneratedColumn<double>(
    'capacidad_m3',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _areaM2Meta = const VerificationMeta('areaM2');
  @override
  late final GeneratedColumn<double> areaM2 = GeneratedColumn<double>(
    'area_m2',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
    'sync_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncMeta = const VerificationMeta(
    'lastSync',
  );
  @override
  late final GeneratedColumn<DateTime> lastSync = GeneratedColumn<DateTime>(
    'last_sync',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    codigo,
    tiendaId,
    ubicacion,
    tipo,
    capacidadM3,
    areaM2,
    activo,
    createdAt,
    updatedAt,
    deletedAt,
    syncId,
    lastSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'almacenes';
  @override
  VerificationContext validateIntegrity(
    Insertable<AlmacenTable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('tienda_id')) {
      context.handle(
        _tiendaIdMeta,
        tiendaId.isAcceptableOrUnknown(data['tienda_id']!, _tiendaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tiendaIdMeta);
    }
    if (data.containsKey('ubicacion')) {
      context.handle(
        _ubicacionMeta,
        ubicacion.isAcceptableOrUnknown(data['ubicacion']!, _ubicacionMeta),
      );
    } else if (isInserting) {
      context.missing(_ubicacionMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('capacidad_m3')) {
      context.handle(
        _capacidadM3Meta,
        capacidadM3.isAcceptableOrUnknown(
          data['capacidad_m3']!,
          _capacidadM3Meta,
        ),
      );
    }
    if (data.containsKey('area_m2')) {
      context.handle(
        _areaM2Meta,
        areaM2.isAcceptableOrUnknown(data['area_m2']!, _areaM2Meta),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_id')) {
      context.handle(
        _syncIdMeta,
        syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta),
      );
    }
    if (data.containsKey('last_sync')) {
      context.handle(
        _lastSyncMeta,
        lastSync.isAcceptableOrUnknown(data['last_sync']!, _lastSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlmacenTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlmacenTable(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      tiendaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tienda_id'],
      )!,
      ubicacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ubicacion'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      capacidadM3: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}capacidad_m3'],
      ),
      areaM2: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}area_m2'],
      ),
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_id'],
      ),
      lastSync: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync'],
      ),
    );
  }

  @override
  $AlmacenesTable createAlias(String alias) {
    return $AlmacenesTable(attachedDatabase, alias);
  }
}

class AlmacenTable extends DataClass implements Insertable<AlmacenTable> {
  final String id;
  final String nombre;
  final String codigo;
  final String tiendaId;
  final String ubicacion;
  final String tipo;
  final double? capacidadM3;
  final double? areaM2;
  final bool activo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? syncId;
  final DateTime? lastSync;
  const AlmacenTable({
    required this.id,
    required this.nombre,
    required this.codigo,
    required this.tiendaId,
    required this.ubicacion,
    required this.tipo,
    this.capacidadM3,
    this.areaM2,
    required this.activo,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.syncId,
    this.lastSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['codigo'] = Variable<String>(codigo);
    map['tienda_id'] = Variable<String>(tiendaId);
    map['ubicacion'] = Variable<String>(ubicacion);
    map['tipo'] = Variable<String>(tipo);
    if (!nullToAbsent || capacidadM3 != null) {
      map['capacidad_m3'] = Variable<double>(capacidadM3);
    }
    if (!nullToAbsent || areaM2 != null) {
      map['area_m2'] = Variable<double>(areaM2);
    }
    map['activo'] = Variable<bool>(activo);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || syncId != null) {
      map['sync_id'] = Variable<String>(syncId);
    }
    if (!nullToAbsent || lastSync != null) {
      map['last_sync'] = Variable<DateTime>(lastSync);
    }
    return map;
  }

  AlmacenesCompanion toCompanion(bool nullToAbsent) {
    return AlmacenesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      codigo: Value(codigo),
      tiendaId: Value(tiendaId),
      ubicacion: Value(ubicacion),
      tipo: Value(tipo),
      capacidadM3: capacidadM3 == null && nullToAbsent
          ? const Value.absent()
          : Value(capacidadM3),
      areaM2: areaM2 == null && nullToAbsent
          ? const Value.absent()
          : Value(areaM2),
      activo: Value(activo),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncId: syncId == null && nullToAbsent
          ? const Value.absent()
          : Value(syncId),
      lastSync: lastSync == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSync),
    );
  }

  factory AlmacenTable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlmacenTable(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      codigo: serializer.fromJson<String>(json['codigo']),
      tiendaId: serializer.fromJson<String>(json['tiendaId']),
      ubicacion: serializer.fromJson<String>(json['ubicacion']),
      tipo: serializer.fromJson<String>(json['tipo']),
      capacidadM3: serializer.fromJson<double?>(json['capacidadM3']),
      areaM2: serializer.fromJson<double?>(json['areaM2']),
      activo: serializer.fromJson<bool>(json['activo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncId: serializer.fromJson<String?>(json['syncId']),
      lastSync: serializer.fromJson<DateTime?>(json['lastSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'codigo': serializer.toJson<String>(codigo),
      'tiendaId': serializer.toJson<String>(tiendaId),
      'ubicacion': serializer.toJson<String>(ubicacion),
      'tipo': serializer.toJson<String>(tipo),
      'capacidadM3': serializer.toJson<double?>(capacidadM3),
      'areaM2': serializer.toJson<double?>(areaM2),
      'activo': serializer.toJson<bool>(activo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncId': serializer.toJson<String?>(syncId),
      'lastSync': serializer.toJson<DateTime?>(lastSync),
    };
  }

  AlmacenTable copyWith({
    String? id,
    String? nombre,
    String? codigo,
    String? tiendaId,
    String? ubicacion,
    String? tipo,
    Value<double?> capacidadM3 = const Value.absent(),
    Value<double?> areaM2 = const Value.absent(),
    bool? activo,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> syncId = const Value.absent(),
    Value<DateTime?> lastSync = const Value.absent(),
  }) => AlmacenTable(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    codigo: codigo ?? this.codigo,
    tiendaId: tiendaId ?? this.tiendaId,
    ubicacion: ubicacion ?? this.ubicacion,
    tipo: tipo ?? this.tipo,
    capacidadM3: capacidadM3.present ? capacidadM3.value : this.capacidadM3,
    areaM2: areaM2.present ? areaM2.value : this.areaM2,
    activo: activo ?? this.activo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncId: syncId.present ? syncId.value : this.syncId,
    lastSync: lastSync.present ? lastSync.value : this.lastSync,
  );
  AlmacenTable copyWithCompanion(AlmacenesCompanion data) {
    return AlmacenTable(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      tiendaId: data.tiendaId.present ? data.tiendaId.value : this.tiendaId,
      ubicacion: data.ubicacion.present ? data.ubicacion.value : this.ubicacion,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      capacidadM3: data.capacidadM3.present
          ? data.capacidadM3.value
          : this.capacidadM3,
      areaM2: data.areaM2.present ? data.areaM2.value : this.areaM2,
      activo: data.activo.present ? data.activo.value : this.activo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      lastSync: data.lastSync.present ? data.lastSync.value : this.lastSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlmacenTable(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('tiendaId: $tiendaId, ')
          ..write('ubicacion: $ubicacion, ')
          ..write('tipo: $tipo, ')
          ..write('capacidadM3: $capacidadM3, ')
          ..write('areaM2: $areaM2, ')
          ..write('activo: $activo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncId: $syncId, ')
          ..write('lastSync: $lastSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    codigo,
    tiendaId,
    ubicacion,
    tipo,
    capacidadM3,
    areaM2,
    activo,
    createdAt,
    updatedAt,
    deletedAt,
    syncId,
    lastSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlmacenTable &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.codigo == this.codigo &&
          other.tiendaId == this.tiendaId &&
          other.ubicacion == this.ubicacion &&
          other.tipo == this.tipo &&
          other.capacidadM3 == this.capacidadM3 &&
          other.areaM2 == this.areaM2 &&
          other.activo == this.activo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncId == this.syncId &&
          other.lastSync == this.lastSync);
}

class AlmacenesCompanion extends UpdateCompanion<AlmacenTable> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> codigo;
  final Value<String> tiendaId;
  final Value<String> ubicacion;
  final Value<String> tipo;
  final Value<double?> capacidadM3;
  final Value<double?> areaM2;
  final Value<bool> activo;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> syncId;
  final Value<DateTime?> lastSync;
  final Value<int> rowid;
  const AlmacenesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.codigo = const Value.absent(),
    this.tiendaId = const Value.absent(),
    this.ubicacion = const Value.absent(),
    this.tipo = const Value.absent(),
    this.capacidadM3 = const Value.absent(),
    this.areaM2 = const Value.absent(),
    this.activo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlmacenesCompanion.insert({
    required String id,
    required String nombre,
    required String codigo,
    required String tiendaId,
    required String ubicacion,
    required String tipo,
    this.capacidadM3 = const Value.absent(),
    this.areaM2 = const Value.absent(),
    this.activo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       codigo = Value(codigo),
       tiendaId = Value(tiendaId),
       ubicacion = Value(ubicacion),
       tipo = Value(tipo);
  static Insertable<AlmacenTable> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? codigo,
    Expression<String>? tiendaId,
    Expression<String>? ubicacion,
    Expression<String>? tipo,
    Expression<double>? capacidadM3,
    Expression<double>? areaM2,
    Expression<bool>? activo,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncId,
    Expression<DateTime>? lastSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (codigo != null) 'codigo': codigo,
      if (tiendaId != null) 'tienda_id': tiendaId,
      if (ubicacion != null) 'ubicacion': ubicacion,
      if (tipo != null) 'tipo': tipo,
      if (capacidadM3 != null) 'capacidad_m3': capacidadM3,
      if (areaM2 != null) 'area_m2': areaM2,
      if (activo != null) 'activo': activo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncId != null) 'sync_id': syncId,
      if (lastSync != null) 'last_sync': lastSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlmacenesCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? codigo,
    Value<String>? tiendaId,
    Value<String>? ubicacion,
    Value<String>? tipo,
    Value<double?>? capacidadM3,
    Value<double?>? areaM2,
    Value<bool>? activo,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? syncId,
    Value<DateTime?>? lastSync,
    Value<int>? rowid,
  }) {
    return AlmacenesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      codigo: codigo ?? this.codigo,
      tiendaId: tiendaId ?? this.tiendaId,
      ubicacion: ubicacion ?? this.ubicacion,
      tipo: tipo ?? this.tipo,
      capacidadM3: capacidadM3 ?? this.capacidadM3,
      areaM2: areaM2 ?? this.areaM2,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncId: syncId ?? this.syncId,
      lastSync: lastSync ?? this.lastSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (tiendaId.present) {
      map['tienda_id'] = Variable<String>(tiendaId.value);
    }
    if (ubicacion.present) {
      map['ubicacion'] = Variable<String>(ubicacion.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (capacidadM3.present) {
      map['capacidad_m3'] = Variable<double>(capacidadM3.value);
    }
    if (areaM2.present) {
      map['area_m2'] = Variable<double>(areaM2.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (lastSync.present) {
      map['last_sync'] = Variable<DateTime>(lastSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlmacenesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('tiendaId: $tiendaId, ')
          ..write('ubicacion: $ubicacion, ')
          ..write('tipo: $tipo, ')
          ..write('capacidadM3: $capacidadM3, ')
          ..write('areaM2: $areaM2, ')
          ..write('activo: $activo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncId: $syncId, ')
          ..write('lastSync: $lastSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriasTable extends Categorias
    with TableInfo<$CategoriasTable, CategoriaTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoriaPadreIdMeta = const VerificationMeta(
    'categoriaPadreId',
  );
  @override
  late final GeneratedColumn<String> categoriaPadreId = GeneratedColumn<String>(
    'categoria_padre_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categorias (id)',
    ),
  );
  static const VerificationMeta _requiereLoteMeta = const VerificationMeta(
    'requiereLote',
  );
  @override
  late final GeneratedColumn<bool> requiereLote = GeneratedColumn<bool>(
    'requiere_lote',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("requiere_lote" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _requiereCertificacionMeta =
      const VerificationMeta('requiereCertificacion');
  @override
  late final GeneratedColumn<bool> requiereCertificacion =
      GeneratedColumn<bool>(
        'requiere_certificacion',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("requiere_certificacion" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
    'sync_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncMeta = const VerificationMeta(
    'lastSync',
  );
  @override
  late final GeneratedColumn<DateTime> lastSync = GeneratedColumn<DateTime>(
    'last_sync',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    codigo,
    descripcion,
    categoriaPadreId,
    requiereLote,
    requiereCertificacion,
    activo,
    createdAt,
    updatedAt,
    syncId,
    lastSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categorias';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoriaTable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('categoria_padre_id')) {
      context.handle(
        _categoriaPadreIdMeta,
        categoriaPadreId.isAcceptableOrUnknown(
          data['categoria_padre_id']!,
          _categoriaPadreIdMeta,
        ),
      );
    }
    if (data.containsKey('requiere_lote')) {
      context.handle(
        _requiereLoteMeta,
        requiereLote.isAcceptableOrUnknown(
          data['requiere_lote']!,
          _requiereLoteMeta,
        ),
      );
    }
    if (data.containsKey('requiere_certificacion')) {
      context.handle(
        _requiereCertificacionMeta,
        requiereCertificacion.isAcceptableOrUnknown(
          data['requiere_certificacion']!,
          _requiereCertificacionMeta,
        ),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sync_id')) {
      context.handle(
        _syncIdMeta,
        syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta),
      );
    }
    if (data.containsKey('last_sync')) {
      context.handle(
        _lastSyncMeta,
        lastSync.isAcceptableOrUnknown(data['last_sync']!, _lastSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoriaTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriaTable(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      ),
      categoriaPadreId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria_padre_id'],
      ),
      requiereLote: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requiere_lote'],
      )!,
      requiereCertificacion: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requiere_certificacion'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_id'],
      ),
      lastSync: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync'],
      ),
    );
  }

  @override
  $CategoriasTable createAlias(String alias) {
    return $CategoriasTable(attachedDatabase, alias);
  }
}

class CategoriaTable extends DataClass implements Insertable<CategoriaTable> {
  final String id;
  final String nombre;
  final String codigo;
  final String? descripcion;
  final String? categoriaPadreId;
  final bool requiereLote;
  final bool requiereCertificacion;
  final bool activo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? syncId;
  final DateTime? lastSync;
  const CategoriaTable({
    required this.id,
    required this.nombre,
    required this.codigo,
    this.descripcion,
    this.categoriaPadreId,
    required this.requiereLote,
    required this.requiereCertificacion,
    required this.activo,
    required this.createdAt,
    required this.updatedAt,
    this.syncId,
    this.lastSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['codigo'] = Variable<String>(codigo);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    if (!nullToAbsent || categoriaPadreId != null) {
      map['categoria_padre_id'] = Variable<String>(categoriaPadreId);
    }
    map['requiere_lote'] = Variable<bool>(requiereLote);
    map['requiere_certificacion'] = Variable<bool>(requiereCertificacion);
    map['activo'] = Variable<bool>(activo);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncId != null) {
      map['sync_id'] = Variable<String>(syncId);
    }
    if (!nullToAbsent || lastSync != null) {
      map['last_sync'] = Variable<DateTime>(lastSync);
    }
    return map;
  }

  CategoriasCompanion toCompanion(bool nullToAbsent) {
    return CategoriasCompanion(
      id: Value(id),
      nombre: Value(nombre),
      codigo: Value(codigo),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      categoriaPadreId: categoriaPadreId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoriaPadreId),
      requiereLote: Value(requiereLote),
      requiereCertificacion: Value(requiereCertificacion),
      activo: Value(activo),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncId: syncId == null && nullToAbsent
          ? const Value.absent()
          : Value(syncId),
      lastSync: lastSync == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSync),
    );
  }

  factory CategoriaTable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriaTable(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      codigo: serializer.fromJson<String>(json['codigo']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      categoriaPadreId: serializer.fromJson<String?>(json['categoriaPadreId']),
      requiereLote: serializer.fromJson<bool>(json['requiereLote']),
      requiereCertificacion: serializer.fromJson<bool>(
        json['requiereCertificacion'],
      ),
      activo: serializer.fromJson<bool>(json['activo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncId: serializer.fromJson<String?>(json['syncId']),
      lastSync: serializer.fromJson<DateTime?>(json['lastSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'codigo': serializer.toJson<String>(codigo),
      'descripcion': serializer.toJson<String?>(descripcion),
      'categoriaPadreId': serializer.toJson<String?>(categoriaPadreId),
      'requiereLote': serializer.toJson<bool>(requiereLote),
      'requiereCertificacion': serializer.toJson<bool>(requiereCertificacion),
      'activo': serializer.toJson<bool>(activo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncId': serializer.toJson<String?>(syncId),
      'lastSync': serializer.toJson<DateTime?>(lastSync),
    };
  }

  CategoriaTable copyWith({
    String? id,
    String? nombre,
    String? codigo,
    Value<String?> descripcion = const Value.absent(),
    Value<String?> categoriaPadreId = const Value.absent(),
    bool? requiereLote,
    bool? requiereCertificacion,
    bool? activo,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<String?> syncId = const Value.absent(),
    Value<DateTime?> lastSync = const Value.absent(),
  }) => CategoriaTable(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    codigo: codigo ?? this.codigo,
    descripcion: descripcion.present ? descripcion.value : this.descripcion,
    categoriaPadreId: categoriaPadreId.present
        ? categoriaPadreId.value
        : this.categoriaPadreId,
    requiereLote: requiereLote ?? this.requiereLote,
    requiereCertificacion: requiereCertificacion ?? this.requiereCertificacion,
    activo: activo ?? this.activo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncId: syncId.present ? syncId.value : this.syncId,
    lastSync: lastSync.present ? lastSync.value : this.lastSync,
  );
  CategoriaTable copyWithCompanion(CategoriasCompanion data) {
    return CategoriaTable(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      categoriaPadreId: data.categoriaPadreId.present
          ? data.categoriaPadreId.value
          : this.categoriaPadreId,
      requiereLote: data.requiereLote.present
          ? data.requiereLote.value
          : this.requiereLote,
      requiereCertificacion: data.requiereCertificacion.present
          ? data.requiereCertificacion.value
          : this.requiereCertificacion,
      activo: data.activo.present ? data.activo.value : this.activo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      lastSync: data.lastSync.present ? data.lastSync.value : this.lastSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriaTable(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('descripcion: $descripcion, ')
          ..write('categoriaPadreId: $categoriaPadreId, ')
          ..write('requiereLote: $requiereLote, ')
          ..write('requiereCertificacion: $requiereCertificacion, ')
          ..write('activo: $activo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('lastSync: $lastSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    codigo,
    descripcion,
    categoriaPadreId,
    requiereLote,
    requiereCertificacion,
    activo,
    createdAt,
    updatedAt,
    syncId,
    lastSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriaTable &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.codigo == this.codigo &&
          other.descripcion == this.descripcion &&
          other.categoriaPadreId == this.categoriaPadreId &&
          other.requiereLote == this.requiereLote &&
          other.requiereCertificacion == this.requiereCertificacion &&
          other.activo == this.activo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncId == this.syncId &&
          other.lastSync == this.lastSync);
}

class CategoriasCompanion extends UpdateCompanion<CategoriaTable> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> codigo;
  final Value<String?> descripcion;
  final Value<String?> categoriaPadreId;
  final Value<bool> requiereLote;
  final Value<bool> requiereCertificacion;
  final Value<bool> activo;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> syncId;
  final Value<DateTime?> lastSync;
  final Value<int> rowid;
  const CategoriasCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.codigo = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.categoriaPadreId = const Value.absent(),
    this.requiereLote = const Value.absent(),
    this.requiereCertificacion = const Value.absent(),
    this.activo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriasCompanion.insert({
    required String id,
    required String nombre,
    required String codigo,
    this.descripcion = const Value.absent(),
    this.categoriaPadreId = const Value.absent(),
    this.requiereLote = const Value.absent(),
    this.requiereCertificacion = const Value.absent(),
    this.activo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       codigo = Value(codigo);
  static Insertable<CategoriaTable> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? codigo,
    Expression<String>? descripcion,
    Expression<String>? categoriaPadreId,
    Expression<bool>? requiereLote,
    Expression<bool>? requiereCertificacion,
    Expression<bool>? activo,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncId,
    Expression<DateTime>? lastSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (codigo != null) 'codigo': codigo,
      if (descripcion != null) 'descripcion': descripcion,
      if (categoriaPadreId != null) 'categoria_padre_id': categoriaPadreId,
      if (requiereLote != null) 'requiere_lote': requiereLote,
      if (requiereCertificacion != null)
        'requiere_certificacion': requiereCertificacion,
      if (activo != null) 'activo': activo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncId != null) 'sync_id': syncId,
      if (lastSync != null) 'last_sync': lastSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriasCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? codigo,
    Value<String?>? descripcion,
    Value<String?>? categoriaPadreId,
    Value<bool>? requiereLote,
    Value<bool>? requiereCertificacion,
    Value<bool>? activo,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? syncId,
    Value<DateTime?>? lastSync,
    Value<int>? rowid,
  }) {
    return CategoriasCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      codigo: codigo ?? this.codigo,
      descripcion: descripcion ?? this.descripcion,
      categoriaPadreId: categoriaPadreId ?? this.categoriaPadreId,
      requiereLote: requiereLote ?? this.requiereLote,
      requiereCertificacion:
          requiereCertificacion ?? this.requiereCertificacion,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncId: syncId ?? this.syncId,
      lastSync: lastSync ?? this.lastSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (categoriaPadreId.present) {
      map['categoria_padre_id'] = Variable<String>(categoriaPadreId.value);
    }
    if (requiereLote.present) {
      map['requiere_lote'] = Variable<bool>(requiereLote.value);
    }
    if (requiereCertificacion.present) {
      map['requiere_certificacion'] = Variable<bool>(
        requiereCertificacion.value,
      );
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (lastSync.present) {
      map['last_sync'] = Variable<DateTime>(lastSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriasCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('descripcion: $descripcion, ')
          ..write('categoriaPadreId: $categoriaPadreId, ')
          ..write('requiereLote: $requiereLote, ')
          ..write('requiereCertificacion: $requiereCertificacion, ')
          ..write('activo: $activo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('lastSync: $lastSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UnidadesMedidaTable extends UnidadesMedida
    with TableInfo<$UnidadesMedidaTable, UnidadMedidaTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnidadesMedidaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _abreviaturaMeta = const VerificationMeta(
    'abreviatura',
  );
  @override
  late final GeneratedColumn<String> abreviatura = GeneratedColumn<String>(
    'abreviatura',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _factorConversionMeta = const VerificationMeta(
    'factorConversion',
  );
  @override
  late final GeneratedColumn<double> factorConversion = GeneratedColumn<double>(
    'factor_conversion',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    abreviatura,
    tipo,
    factorConversion,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unidades_medida';
  @override
  VerificationContext validateIntegrity(
    Insertable<UnidadMedidaTable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('abreviatura')) {
      context.handle(
        _abreviaturaMeta,
        abreviatura.isAcceptableOrUnknown(
          data['abreviatura']!,
          _abreviaturaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_abreviaturaMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('factor_conversion')) {
      context.handle(
        _factorConversionMeta,
        factorConversion.isAcceptableOrUnknown(
          data['factor_conversion']!,
          _factorConversionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UnidadMedidaTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnidadMedidaTable(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      abreviatura: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}abreviatura'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      factorConversion: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}factor_conversion'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UnidadesMedidaTable createAlias(String alias) {
    return $UnidadesMedidaTable(attachedDatabase, alias);
  }
}

class UnidadMedidaTable extends DataClass
    implements Insertable<UnidadMedidaTable> {
  final String id;
  final String nombre;
  final String abreviatura;
  final String tipo;
  final double factorConversion;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UnidadMedidaTable({
    required this.id,
    required this.nombre,
    required this.abreviatura,
    required this.tipo,
    required this.factorConversion,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['abreviatura'] = Variable<String>(abreviatura);
    map['tipo'] = Variable<String>(tipo);
    map['factor_conversion'] = Variable<double>(factorConversion);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UnidadesMedidaCompanion toCompanion(bool nullToAbsent) {
    return UnidadesMedidaCompanion(
      id: Value(id),
      nombre: Value(nombre),
      abreviatura: Value(abreviatura),
      tipo: Value(tipo),
      factorConversion: Value(factorConversion),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UnidadMedidaTable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnidadMedidaTable(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      abreviatura: serializer.fromJson<String>(json['abreviatura']),
      tipo: serializer.fromJson<String>(json['tipo']),
      factorConversion: serializer.fromJson<double>(json['factorConversion']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'abreviatura': serializer.toJson<String>(abreviatura),
      'tipo': serializer.toJson<String>(tipo),
      'factorConversion': serializer.toJson<double>(factorConversion),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UnidadMedidaTable copyWith({
    String? id,
    String? nombre,
    String? abreviatura,
    String? tipo,
    double? factorConversion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UnidadMedidaTable(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    abreviatura: abreviatura ?? this.abreviatura,
    tipo: tipo ?? this.tipo,
    factorConversion: factorConversion ?? this.factorConversion,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UnidadMedidaTable copyWithCompanion(UnidadesMedidaCompanion data) {
    return UnidadMedidaTable(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      abreviatura: data.abreviatura.present
          ? data.abreviatura.value
          : this.abreviatura,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      factorConversion: data.factorConversion.present
          ? data.factorConversion.value
          : this.factorConversion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnidadMedidaTable(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('abreviatura: $abreviatura, ')
          ..write('tipo: $tipo, ')
          ..write('factorConversion: $factorConversion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    abreviatura,
    tipo,
    factorConversion,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnidadMedidaTable &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.abreviatura == this.abreviatura &&
          other.tipo == this.tipo &&
          other.factorConversion == this.factorConversion &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UnidadesMedidaCompanion extends UpdateCompanion<UnidadMedidaTable> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> abreviatura;
  final Value<String> tipo;
  final Value<double> factorConversion;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UnidadesMedidaCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.abreviatura = const Value.absent(),
    this.tipo = const Value.absent(),
    this.factorConversion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnidadesMedidaCompanion.insert({
    required String id,
    required String nombre,
    required String abreviatura,
    required String tipo,
    this.factorConversion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       abreviatura = Value(abreviatura),
       tipo = Value(tipo);
  static Insertable<UnidadMedidaTable> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? abreviatura,
    Expression<String>? tipo,
    Expression<double>? factorConversion,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (abreviatura != null) 'abreviatura': abreviatura,
      if (tipo != null) 'tipo': tipo,
      if (factorConversion != null) 'factor_conversion': factorConversion,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnidadesMedidaCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? abreviatura,
    Value<String>? tipo,
    Value<double>? factorConversion,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UnidadesMedidaCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      abreviatura: abreviatura ?? this.abreviatura,
      tipo: tipo ?? this.tipo,
      factorConversion: factorConversion ?? this.factorConversion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (abreviatura.present) {
      map['abreviatura'] = Variable<String>(abreviatura.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (factorConversion.present) {
      map['factor_conversion'] = Variable<double>(factorConversion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnidadesMedidaCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('abreviatura: $abreviatura, ')
          ..write('tipo: $tipo, ')
          ..write('factorConversion: $factorConversion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProveedoresTable extends Proveedores
    with TableInfo<$ProveedoresTable, ProveedorTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProveedoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _razonSocialMeta = const VerificationMeta(
    'razonSocial',
  );
  @override
  late final GeneratedColumn<String> razonSocial = GeneratedColumn<String>(
    'razon_social',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nitMeta = const VerificationMeta('nit');
  @override
  late final GeneratedColumn<String> nit = GeneratedColumn<String>(
    'nit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nombreContactoMeta = const VerificationMeta(
    'nombreContacto',
  );
  @override
  late final GeneratedColumn<String> nombreContacto = GeneratedColumn<String>(
    'nombre_contacto',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _direccionMeta = const VerificationMeta(
    'direccion',
  );
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
    'direccion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ciudadMeta = const VerificationMeta('ciudad');
  @override
  late final GeneratedColumn<String> ciudad = GeneratedColumn<String>(
    'ciudad',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tipoMaterialMeta = const VerificationMeta(
    'tipoMaterial',
  );
  @override
  late final GeneratedColumn<String> tipoMaterial = GeneratedColumn<String>(
    'tipo_material',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diasCreditoMeta = const VerificationMeta(
    'diasCredito',
  );
  @override
  late final GeneratedColumn<int> diasCredito = GeneratedColumn<int>(
    'dias_credito',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
    'sync_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncMeta = const VerificationMeta(
    'lastSync',
  );
  @override
  late final GeneratedColumn<DateTime> lastSync = GeneratedColumn<DateTime>(
    'last_sync',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    razonSocial,
    nit,
    nombreContacto,
    telefono,
    email,
    direccion,
    ciudad,
    tipoMaterial,
    diasCredito,
    activo,
    createdAt,
    updatedAt,
    deletedAt,
    syncId,
    lastSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'proveedores';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProveedorTable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('razon_social')) {
      context.handle(
        _razonSocialMeta,
        razonSocial.isAcceptableOrUnknown(
          data['razon_social']!,
          _razonSocialMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_razonSocialMeta);
    }
    if (data.containsKey('nit')) {
      context.handle(
        _nitMeta,
        nit.isAcceptableOrUnknown(data['nit']!, _nitMeta),
      );
    } else if (isInserting) {
      context.missing(_nitMeta);
    }
    if (data.containsKey('nombre_contacto')) {
      context.handle(
        _nombreContactoMeta,
        nombreContacto.isAcceptableOrUnknown(
          data['nombre_contacto']!,
          _nombreContactoMeta,
        ),
      );
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('direccion')) {
      context.handle(
        _direccionMeta,
        direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta),
      );
    }
    if (data.containsKey('ciudad')) {
      context.handle(
        _ciudadMeta,
        ciudad.isAcceptableOrUnknown(data['ciudad']!, _ciudadMeta),
      );
    }
    if (data.containsKey('tipo_material')) {
      context.handle(
        _tipoMaterialMeta,
        tipoMaterial.isAcceptableOrUnknown(
          data['tipo_material']!,
          _tipoMaterialMeta,
        ),
      );
    }
    if (data.containsKey('dias_credito')) {
      context.handle(
        _diasCreditoMeta,
        diasCredito.isAcceptableOrUnknown(
          data['dias_credito']!,
          _diasCreditoMeta,
        ),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_id')) {
      context.handle(
        _syncIdMeta,
        syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta),
      );
    }
    if (data.containsKey('last_sync')) {
      context.handle(
        _lastSyncMeta,
        lastSync.isAcceptableOrUnknown(data['last_sync']!, _lastSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProveedorTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProveedorTable(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      razonSocial: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}razon_social'],
      )!,
      nit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nit'],
      )!,
      nombreContacto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_contacto'],
      ),
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      direccion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direccion'],
      ),
      ciudad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ciudad'],
      ),
      tipoMaterial: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_material'],
      ),
      diasCredito: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dias_credito'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_id'],
      ),
      lastSync: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync'],
      ),
    );
  }

  @override
  $ProveedoresTable createAlias(String alias) {
    return $ProveedoresTable(attachedDatabase, alias);
  }
}

class ProveedorTable extends DataClass implements Insertable<ProveedorTable> {
  final String id;
  final String razonSocial;
  final String nit;
  final String? nombreContacto;
  final String? telefono;
  final String? email;
  final String? direccion;
  final String? ciudad;
  final String? tipoMaterial;
  final int diasCredito;
  final bool activo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? syncId;
  final DateTime? lastSync;
  const ProveedorTable({
    required this.id,
    required this.razonSocial,
    required this.nit,
    this.nombreContacto,
    this.telefono,
    this.email,
    this.direccion,
    this.ciudad,
    this.tipoMaterial,
    required this.diasCredito,
    required this.activo,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.syncId,
    this.lastSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['razon_social'] = Variable<String>(razonSocial);
    map['nit'] = Variable<String>(nit);
    if (!nullToAbsent || nombreContacto != null) {
      map['nombre_contacto'] = Variable<String>(nombreContacto);
    }
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || direccion != null) {
      map['direccion'] = Variable<String>(direccion);
    }
    if (!nullToAbsent || ciudad != null) {
      map['ciudad'] = Variable<String>(ciudad);
    }
    if (!nullToAbsent || tipoMaterial != null) {
      map['tipo_material'] = Variable<String>(tipoMaterial);
    }
    map['dias_credito'] = Variable<int>(diasCredito);
    map['activo'] = Variable<bool>(activo);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || syncId != null) {
      map['sync_id'] = Variable<String>(syncId);
    }
    if (!nullToAbsent || lastSync != null) {
      map['last_sync'] = Variable<DateTime>(lastSync);
    }
    return map;
  }

  ProveedoresCompanion toCompanion(bool nullToAbsent) {
    return ProveedoresCompanion(
      id: Value(id),
      razonSocial: Value(razonSocial),
      nit: Value(nit),
      nombreContacto: nombreContacto == null && nullToAbsent
          ? const Value.absent()
          : Value(nombreContacto),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      direccion: direccion == null && nullToAbsent
          ? const Value.absent()
          : Value(direccion),
      ciudad: ciudad == null && nullToAbsent
          ? const Value.absent()
          : Value(ciudad),
      tipoMaterial: tipoMaterial == null && nullToAbsent
          ? const Value.absent()
          : Value(tipoMaterial),
      diasCredito: Value(diasCredito),
      activo: Value(activo),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncId: syncId == null && nullToAbsent
          ? const Value.absent()
          : Value(syncId),
      lastSync: lastSync == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSync),
    );
  }

  factory ProveedorTable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProveedorTable(
      id: serializer.fromJson<String>(json['id']),
      razonSocial: serializer.fromJson<String>(json['razonSocial']),
      nit: serializer.fromJson<String>(json['nit']),
      nombreContacto: serializer.fromJson<String?>(json['nombreContacto']),
      telefono: serializer.fromJson<String?>(json['telefono']),
      email: serializer.fromJson<String?>(json['email']),
      direccion: serializer.fromJson<String?>(json['direccion']),
      ciudad: serializer.fromJson<String?>(json['ciudad']),
      tipoMaterial: serializer.fromJson<String?>(json['tipoMaterial']),
      diasCredito: serializer.fromJson<int>(json['diasCredito']),
      activo: serializer.fromJson<bool>(json['activo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncId: serializer.fromJson<String?>(json['syncId']),
      lastSync: serializer.fromJson<DateTime?>(json['lastSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'razonSocial': serializer.toJson<String>(razonSocial),
      'nit': serializer.toJson<String>(nit),
      'nombreContacto': serializer.toJson<String?>(nombreContacto),
      'telefono': serializer.toJson<String?>(telefono),
      'email': serializer.toJson<String?>(email),
      'direccion': serializer.toJson<String?>(direccion),
      'ciudad': serializer.toJson<String?>(ciudad),
      'tipoMaterial': serializer.toJson<String?>(tipoMaterial),
      'diasCredito': serializer.toJson<int>(diasCredito),
      'activo': serializer.toJson<bool>(activo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncId': serializer.toJson<String?>(syncId),
      'lastSync': serializer.toJson<DateTime?>(lastSync),
    };
  }

  ProveedorTable copyWith({
    String? id,
    String? razonSocial,
    String? nit,
    Value<String?> nombreContacto = const Value.absent(),
    Value<String?> telefono = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> direccion = const Value.absent(),
    Value<String?> ciudad = const Value.absent(),
    Value<String?> tipoMaterial = const Value.absent(),
    int? diasCredito,
    bool? activo,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> syncId = const Value.absent(),
    Value<DateTime?> lastSync = const Value.absent(),
  }) => ProveedorTable(
    id: id ?? this.id,
    razonSocial: razonSocial ?? this.razonSocial,
    nit: nit ?? this.nit,
    nombreContacto: nombreContacto.present
        ? nombreContacto.value
        : this.nombreContacto,
    telefono: telefono.present ? telefono.value : this.telefono,
    email: email.present ? email.value : this.email,
    direccion: direccion.present ? direccion.value : this.direccion,
    ciudad: ciudad.present ? ciudad.value : this.ciudad,
    tipoMaterial: tipoMaterial.present ? tipoMaterial.value : this.tipoMaterial,
    diasCredito: diasCredito ?? this.diasCredito,
    activo: activo ?? this.activo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncId: syncId.present ? syncId.value : this.syncId,
    lastSync: lastSync.present ? lastSync.value : this.lastSync,
  );
  ProveedorTable copyWithCompanion(ProveedoresCompanion data) {
    return ProveedorTable(
      id: data.id.present ? data.id.value : this.id,
      razonSocial: data.razonSocial.present
          ? data.razonSocial.value
          : this.razonSocial,
      nit: data.nit.present ? data.nit.value : this.nit,
      nombreContacto: data.nombreContacto.present
          ? data.nombreContacto.value
          : this.nombreContacto,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      email: data.email.present ? data.email.value : this.email,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      ciudad: data.ciudad.present ? data.ciudad.value : this.ciudad,
      tipoMaterial: data.tipoMaterial.present
          ? data.tipoMaterial.value
          : this.tipoMaterial,
      diasCredito: data.diasCredito.present
          ? data.diasCredito.value
          : this.diasCredito,
      activo: data.activo.present ? data.activo.value : this.activo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      lastSync: data.lastSync.present ? data.lastSync.value : this.lastSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProveedorTable(')
          ..write('id: $id, ')
          ..write('razonSocial: $razonSocial, ')
          ..write('nit: $nit, ')
          ..write('nombreContacto: $nombreContacto, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('direccion: $direccion, ')
          ..write('ciudad: $ciudad, ')
          ..write('tipoMaterial: $tipoMaterial, ')
          ..write('diasCredito: $diasCredito, ')
          ..write('activo: $activo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncId: $syncId, ')
          ..write('lastSync: $lastSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    razonSocial,
    nit,
    nombreContacto,
    telefono,
    email,
    direccion,
    ciudad,
    tipoMaterial,
    diasCredito,
    activo,
    createdAt,
    updatedAt,
    deletedAt,
    syncId,
    lastSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProveedorTable &&
          other.id == this.id &&
          other.razonSocial == this.razonSocial &&
          other.nit == this.nit &&
          other.nombreContacto == this.nombreContacto &&
          other.telefono == this.telefono &&
          other.email == this.email &&
          other.direccion == this.direccion &&
          other.ciudad == this.ciudad &&
          other.tipoMaterial == this.tipoMaterial &&
          other.diasCredito == this.diasCredito &&
          other.activo == this.activo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncId == this.syncId &&
          other.lastSync == this.lastSync);
}

class ProveedoresCompanion extends UpdateCompanion<ProveedorTable> {
  final Value<String> id;
  final Value<String> razonSocial;
  final Value<String> nit;
  final Value<String?> nombreContacto;
  final Value<String?> telefono;
  final Value<String?> email;
  final Value<String?> direccion;
  final Value<String?> ciudad;
  final Value<String?> tipoMaterial;
  final Value<int> diasCredito;
  final Value<bool> activo;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> syncId;
  final Value<DateTime?> lastSync;
  final Value<int> rowid;
  const ProveedoresCompanion({
    this.id = const Value.absent(),
    this.razonSocial = const Value.absent(),
    this.nit = const Value.absent(),
    this.nombreContacto = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.direccion = const Value.absent(),
    this.ciudad = const Value.absent(),
    this.tipoMaterial = const Value.absent(),
    this.diasCredito = const Value.absent(),
    this.activo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProveedoresCompanion.insert({
    required String id,
    required String razonSocial,
    required String nit,
    this.nombreContacto = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.direccion = const Value.absent(),
    this.ciudad = const Value.absent(),
    this.tipoMaterial = const Value.absent(),
    this.diasCredito = const Value.absent(),
    this.activo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       razonSocial = Value(razonSocial),
       nit = Value(nit);
  static Insertable<ProveedorTable> custom({
    Expression<String>? id,
    Expression<String>? razonSocial,
    Expression<String>? nit,
    Expression<String>? nombreContacto,
    Expression<String>? telefono,
    Expression<String>? email,
    Expression<String>? direccion,
    Expression<String>? ciudad,
    Expression<String>? tipoMaterial,
    Expression<int>? diasCredito,
    Expression<bool>? activo,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncId,
    Expression<DateTime>? lastSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (razonSocial != null) 'razon_social': razonSocial,
      if (nit != null) 'nit': nit,
      if (nombreContacto != null) 'nombre_contacto': nombreContacto,
      if (telefono != null) 'telefono': telefono,
      if (email != null) 'email': email,
      if (direccion != null) 'direccion': direccion,
      if (ciudad != null) 'ciudad': ciudad,
      if (tipoMaterial != null) 'tipo_material': tipoMaterial,
      if (diasCredito != null) 'dias_credito': diasCredito,
      if (activo != null) 'activo': activo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncId != null) 'sync_id': syncId,
      if (lastSync != null) 'last_sync': lastSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProveedoresCompanion copyWith({
    Value<String>? id,
    Value<String>? razonSocial,
    Value<String>? nit,
    Value<String?>? nombreContacto,
    Value<String?>? telefono,
    Value<String?>? email,
    Value<String?>? direccion,
    Value<String?>? ciudad,
    Value<String?>? tipoMaterial,
    Value<int>? diasCredito,
    Value<bool>? activo,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? syncId,
    Value<DateTime?>? lastSync,
    Value<int>? rowid,
  }) {
    return ProveedoresCompanion(
      id: id ?? this.id,
      razonSocial: razonSocial ?? this.razonSocial,
      nit: nit ?? this.nit,
      nombreContacto: nombreContacto ?? this.nombreContacto,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      direccion: direccion ?? this.direccion,
      ciudad: ciudad ?? this.ciudad,
      tipoMaterial: tipoMaterial ?? this.tipoMaterial,
      diasCredito: diasCredito ?? this.diasCredito,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncId: syncId ?? this.syncId,
      lastSync: lastSync ?? this.lastSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (razonSocial.present) {
      map['razon_social'] = Variable<String>(razonSocial.value);
    }
    if (nit.present) {
      map['nit'] = Variable<String>(nit.value);
    }
    if (nombreContacto.present) {
      map['nombre_contacto'] = Variable<String>(nombreContacto.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (ciudad.present) {
      map['ciudad'] = Variable<String>(ciudad.value);
    }
    if (tipoMaterial.present) {
      map['tipo_material'] = Variable<String>(tipoMaterial.value);
    }
    if (diasCredito.present) {
      map['dias_credito'] = Variable<int>(diasCredito.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (lastSync.present) {
      map['last_sync'] = Variable<DateTime>(lastSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProveedoresCompanion(')
          ..write('id: $id, ')
          ..write('razonSocial: $razonSocial, ')
          ..write('nit: $nit, ')
          ..write('nombreContacto: $nombreContacto, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('direccion: $direccion, ')
          ..write('ciudad: $ciudad, ')
          ..write('tipoMaterial: $tipoMaterial, ')
          ..write('diasCredito: $diasCredito, ')
          ..write('activo: $activo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncId: $syncId, ')
          ..write('lastSync: $lastSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductosTable extends Productos
    with TableInfo<$ProductosTable, ProductoTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoriaIdMeta = const VerificationMeta(
    'categoriaId',
  );
  @override
  late final GeneratedColumn<String> categoriaId = GeneratedColumn<String>(
    'categoria_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categorias (id)',
    ),
  );
  static const VerificationMeta _unidadMedidaIdMeta = const VerificationMeta(
    'unidadMedidaId',
  );
  @override
  late final GeneratedColumn<String> unidadMedidaId = GeneratedColumn<String>(
    'unidad_medida_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES unidades_medida (id)',
    ),
  );
  static const VerificationMeta _proveedorPrincipalIdMeta =
      const VerificationMeta('proveedorPrincipalId');
  @override
  late final GeneratedColumn<String> proveedorPrincipalId =
      GeneratedColumn<String>(
        'proveedor_principal_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES proveedores (id)',
        ),
      );
  static const VerificationMeta _precioCompraMeta = const VerificationMeta(
    'precioCompra',
  );
  @override
  late final GeneratedColumn<double> precioCompra = GeneratedColumn<double>(
    'precio_compra',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _precioVentaMeta = const VerificationMeta(
    'precioVenta',
  );
  @override
  late final GeneratedColumn<double> precioVenta = GeneratedColumn<double>(
    'precio_venta',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _pesoUnitarioKgMeta = const VerificationMeta(
    'pesoUnitarioKg',
  );
  @override
  late final GeneratedColumn<double> pesoUnitarioKg = GeneratedColumn<double>(
    'peso_unitario_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _volumenUnitarioM3Meta = const VerificationMeta(
    'volumenUnitarioM3',
  );
  @override
  late final GeneratedColumn<double> volumenUnitarioM3 =
      GeneratedColumn<double>(
        'volumen_unitario_m3',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _stockMinimoMeta = const VerificationMeta(
    'stockMinimo',
  );
  @override
  late final GeneratedColumn<int> stockMinimo = GeneratedColumn<int>(
    'stock_minimo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _stockMaximoMeta = const VerificationMeta(
    'stockMaximo',
  );
  @override
  late final GeneratedColumn<int> stockMaximo = GeneratedColumn<int>(
    'stock_maximo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _marcaMeta = const VerificationMeta('marca');
  @override
  late final GeneratedColumn<String> marca = GeneratedColumn<String>(
    'marca',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gradoCalidadMeta = const VerificationMeta(
    'gradoCalidad',
  );
  @override
  late final GeneratedColumn<String> gradoCalidad = GeneratedColumn<String>(
    'grado_calidad',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _normaTecnicaMeta = const VerificationMeta(
    'normaTecnica',
  );
  @override
  late final GeneratedColumn<String> normaTecnica = GeneratedColumn<String>(
    'norma_tecnica',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _requiereAlmacenCubiertoMeta =
      const VerificationMeta('requiereAlmacenCubierto');
  @override
  late final GeneratedColumn<bool> requiereAlmacenCubierto =
      GeneratedColumn<bool>(
        'requiere_almacen_cubierto',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("requiere_almacen_cubierto" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _materialPeligrosoMeta = const VerificationMeta(
    'materialPeligroso',
  );
  @override
  late final GeneratedColumn<bool> materialPeligroso = GeneratedColumn<bool>(
    'material_peligroso',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("material_peligroso" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _imagenUrlMeta = const VerificationMeta(
    'imagenUrl',
  );
  @override
  late final GeneratedColumn<String> imagenUrl = GeneratedColumn<String>(
    'imagen_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fichaTecnicaUrlMeta = const VerificationMeta(
    'fichaTecnicaUrl',
  );
  @override
  late final GeneratedColumn<String> fichaTecnicaUrl = GeneratedColumn<String>(
    'ficha_tecnica_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
    'sync_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncMeta = const VerificationMeta(
    'lastSync',
  );
  @override
  late final GeneratedColumn<DateTime> lastSync = GeneratedColumn<DateTime>(
    'last_sync',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    codigo,
    descripcion,
    categoriaId,
    unidadMedidaId,
    proveedorPrincipalId,
    precioCompra,
    precioVenta,
    pesoUnitarioKg,
    volumenUnitarioM3,
    stockMinimo,
    stockMaximo,
    marca,
    gradoCalidad,
    normaTecnica,
    requiereAlmacenCubierto,
    materialPeligroso,
    imagenUrl,
    fichaTecnicaUrl,
    activo,
    createdAt,
    updatedAt,
    deletedAt,
    syncId,
    lastSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'productos';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductoTable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
        _categoriaIdMeta,
        categoriaId.isAcceptableOrUnknown(
          data['categoria_id']!,
          _categoriaIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoriaIdMeta);
    }
    if (data.containsKey('unidad_medida_id')) {
      context.handle(
        _unidadMedidaIdMeta,
        unidadMedidaId.isAcceptableOrUnknown(
          data['unidad_medida_id']!,
          _unidadMedidaIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unidadMedidaIdMeta);
    }
    if (data.containsKey('proveedor_principal_id')) {
      context.handle(
        _proveedorPrincipalIdMeta,
        proveedorPrincipalId.isAcceptableOrUnknown(
          data['proveedor_principal_id']!,
          _proveedorPrincipalIdMeta,
        ),
      );
    }
    if (data.containsKey('precio_compra')) {
      context.handle(
        _precioCompraMeta,
        precioCompra.isAcceptableOrUnknown(
          data['precio_compra']!,
          _precioCompraMeta,
        ),
      );
    }
    if (data.containsKey('precio_venta')) {
      context.handle(
        _precioVentaMeta,
        precioVenta.isAcceptableOrUnknown(
          data['precio_venta']!,
          _precioVentaMeta,
        ),
      );
    }
    if (data.containsKey('peso_unitario_kg')) {
      context.handle(
        _pesoUnitarioKgMeta,
        pesoUnitarioKg.isAcceptableOrUnknown(
          data['peso_unitario_kg']!,
          _pesoUnitarioKgMeta,
        ),
      );
    }
    if (data.containsKey('volumen_unitario_m3')) {
      context.handle(
        _volumenUnitarioM3Meta,
        volumenUnitarioM3.isAcceptableOrUnknown(
          data['volumen_unitario_m3']!,
          _volumenUnitarioM3Meta,
        ),
      );
    }
    if (data.containsKey('stock_minimo')) {
      context.handle(
        _stockMinimoMeta,
        stockMinimo.isAcceptableOrUnknown(
          data['stock_minimo']!,
          _stockMinimoMeta,
        ),
      );
    }
    if (data.containsKey('stock_maximo')) {
      context.handle(
        _stockMaximoMeta,
        stockMaximo.isAcceptableOrUnknown(
          data['stock_maximo']!,
          _stockMaximoMeta,
        ),
      );
    }
    if (data.containsKey('marca')) {
      context.handle(
        _marcaMeta,
        marca.isAcceptableOrUnknown(data['marca']!, _marcaMeta),
      );
    }
    if (data.containsKey('grado_calidad')) {
      context.handle(
        _gradoCalidadMeta,
        gradoCalidad.isAcceptableOrUnknown(
          data['grado_calidad']!,
          _gradoCalidadMeta,
        ),
      );
    }
    if (data.containsKey('norma_tecnica')) {
      context.handle(
        _normaTecnicaMeta,
        normaTecnica.isAcceptableOrUnknown(
          data['norma_tecnica']!,
          _normaTecnicaMeta,
        ),
      );
    }
    if (data.containsKey('requiere_almacen_cubierto')) {
      context.handle(
        _requiereAlmacenCubiertoMeta,
        requiereAlmacenCubierto.isAcceptableOrUnknown(
          data['requiere_almacen_cubierto']!,
          _requiereAlmacenCubiertoMeta,
        ),
      );
    }
    if (data.containsKey('material_peligroso')) {
      context.handle(
        _materialPeligrosoMeta,
        materialPeligroso.isAcceptableOrUnknown(
          data['material_peligroso']!,
          _materialPeligrosoMeta,
        ),
      );
    }
    if (data.containsKey('imagen_url')) {
      context.handle(
        _imagenUrlMeta,
        imagenUrl.isAcceptableOrUnknown(data['imagen_url']!, _imagenUrlMeta),
      );
    }
    if (data.containsKey('ficha_tecnica_url')) {
      context.handle(
        _fichaTecnicaUrlMeta,
        fichaTecnicaUrl.isAcceptableOrUnknown(
          data['ficha_tecnica_url']!,
          _fichaTecnicaUrlMeta,
        ),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_id')) {
      context.handle(
        _syncIdMeta,
        syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta),
      );
    }
    if (data.containsKey('last_sync')) {
      context.handle(
        _lastSyncMeta,
        lastSync.isAcceptableOrUnknown(data['last_sync']!, _lastSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductoTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductoTable(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      ),
      categoriaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria_id'],
      )!,
      unidadMedidaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unidad_medida_id'],
      )!,
      proveedorPrincipalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proveedor_principal_id'],
      ),
      precioCompra: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_compra'],
      )!,
      precioVenta: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_venta'],
      )!,
      pesoUnitarioKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}peso_unitario_kg'],
      ),
      volumenUnitarioM3: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}volumen_unitario_m3'],
      ),
      stockMinimo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock_minimo'],
      )!,
      stockMaximo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock_maximo'],
      )!,
      marca: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}marca'],
      ),
      gradoCalidad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grado_calidad'],
      ),
      normaTecnica: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}norma_tecnica'],
      ),
      requiereAlmacenCubierto: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requiere_almacen_cubierto'],
      )!,
      materialPeligroso: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}material_peligroso'],
      )!,
      imagenUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}imagen_url'],
      ),
      fichaTecnicaUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ficha_tecnica_url'],
      ),
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_id'],
      ),
      lastSync: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync'],
      ),
    );
  }

  @override
  $ProductosTable createAlias(String alias) {
    return $ProductosTable(attachedDatabase, alias);
  }
}

class ProductoTable extends DataClass implements Insertable<ProductoTable> {
  final String id;
  final String nombre;
  final String codigo;
  final String? descripcion;
  final String categoriaId;
  final String unidadMedidaId;
  final String? proveedorPrincipalId;
  final double precioCompra;
  final double precioVenta;
  final double? pesoUnitarioKg;
  final double? volumenUnitarioM3;
  final int stockMinimo;
  final int stockMaximo;
  final String? marca;
  final String? gradoCalidad;
  final String? normaTecnica;
  final bool requiereAlmacenCubierto;
  final bool materialPeligroso;
  final String? imagenUrl;
  final String? fichaTecnicaUrl;
  final bool activo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? syncId;
  final DateTime? lastSync;
  const ProductoTable({
    required this.id,
    required this.nombre,
    required this.codigo,
    this.descripcion,
    required this.categoriaId,
    required this.unidadMedidaId,
    this.proveedorPrincipalId,
    required this.precioCompra,
    required this.precioVenta,
    this.pesoUnitarioKg,
    this.volumenUnitarioM3,
    required this.stockMinimo,
    required this.stockMaximo,
    this.marca,
    this.gradoCalidad,
    this.normaTecnica,
    required this.requiereAlmacenCubierto,
    required this.materialPeligroso,
    this.imagenUrl,
    this.fichaTecnicaUrl,
    required this.activo,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.syncId,
    this.lastSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['codigo'] = Variable<String>(codigo);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    map['categoria_id'] = Variable<String>(categoriaId);
    map['unidad_medida_id'] = Variable<String>(unidadMedidaId);
    if (!nullToAbsent || proveedorPrincipalId != null) {
      map['proveedor_principal_id'] = Variable<String>(proveedorPrincipalId);
    }
    map['precio_compra'] = Variable<double>(precioCompra);
    map['precio_venta'] = Variable<double>(precioVenta);
    if (!nullToAbsent || pesoUnitarioKg != null) {
      map['peso_unitario_kg'] = Variable<double>(pesoUnitarioKg);
    }
    if (!nullToAbsent || volumenUnitarioM3 != null) {
      map['volumen_unitario_m3'] = Variable<double>(volumenUnitarioM3);
    }
    map['stock_minimo'] = Variable<int>(stockMinimo);
    map['stock_maximo'] = Variable<int>(stockMaximo);
    if (!nullToAbsent || marca != null) {
      map['marca'] = Variable<String>(marca);
    }
    if (!nullToAbsent || gradoCalidad != null) {
      map['grado_calidad'] = Variable<String>(gradoCalidad);
    }
    if (!nullToAbsent || normaTecnica != null) {
      map['norma_tecnica'] = Variable<String>(normaTecnica);
    }
    map['requiere_almacen_cubierto'] = Variable<bool>(requiereAlmacenCubierto);
    map['material_peligroso'] = Variable<bool>(materialPeligroso);
    if (!nullToAbsent || imagenUrl != null) {
      map['imagen_url'] = Variable<String>(imagenUrl);
    }
    if (!nullToAbsent || fichaTecnicaUrl != null) {
      map['ficha_tecnica_url'] = Variable<String>(fichaTecnicaUrl);
    }
    map['activo'] = Variable<bool>(activo);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || syncId != null) {
      map['sync_id'] = Variable<String>(syncId);
    }
    if (!nullToAbsent || lastSync != null) {
      map['last_sync'] = Variable<DateTime>(lastSync);
    }
    return map;
  }

  ProductosCompanion toCompanion(bool nullToAbsent) {
    return ProductosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      codigo: Value(codigo),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      categoriaId: Value(categoriaId),
      unidadMedidaId: Value(unidadMedidaId),
      proveedorPrincipalId: proveedorPrincipalId == null && nullToAbsent
          ? const Value.absent()
          : Value(proveedorPrincipalId),
      precioCompra: Value(precioCompra),
      precioVenta: Value(precioVenta),
      pesoUnitarioKg: pesoUnitarioKg == null && nullToAbsent
          ? const Value.absent()
          : Value(pesoUnitarioKg),
      volumenUnitarioM3: volumenUnitarioM3 == null && nullToAbsent
          ? const Value.absent()
          : Value(volumenUnitarioM3),
      stockMinimo: Value(stockMinimo),
      stockMaximo: Value(stockMaximo),
      marca: marca == null && nullToAbsent
          ? const Value.absent()
          : Value(marca),
      gradoCalidad: gradoCalidad == null && nullToAbsent
          ? const Value.absent()
          : Value(gradoCalidad),
      normaTecnica: normaTecnica == null && nullToAbsent
          ? const Value.absent()
          : Value(normaTecnica),
      requiereAlmacenCubierto: Value(requiereAlmacenCubierto),
      materialPeligroso: Value(materialPeligroso),
      imagenUrl: imagenUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imagenUrl),
      fichaTecnicaUrl: fichaTecnicaUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(fichaTecnicaUrl),
      activo: Value(activo),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncId: syncId == null && nullToAbsent
          ? const Value.absent()
          : Value(syncId),
      lastSync: lastSync == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSync),
    );
  }

  factory ProductoTable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductoTable(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      codigo: serializer.fromJson<String>(json['codigo']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      categoriaId: serializer.fromJson<String>(json['categoriaId']),
      unidadMedidaId: serializer.fromJson<String>(json['unidadMedidaId']),
      proveedorPrincipalId: serializer.fromJson<String?>(
        json['proveedorPrincipalId'],
      ),
      precioCompra: serializer.fromJson<double>(json['precioCompra']),
      precioVenta: serializer.fromJson<double>(json['precioVenta']),
      pesoUnitarioKg: serializer.fromJson<double?>(json['pesoUnitarioKg']),
      volumenUnitarioM3: serializer.fromJson<double?>(
        json['volumenUnitarioM3'],
      ),
      stockMinimo: serializer.fromJson<int>(json['stockMinimo']),
      stockMaximo: serializer.fromJson<int>(json['stockMaximo']),
      marca: serializer.fromJson<String?>(json['marca']),
      gradoCalidad: serializer.fromJson<String?>(json['gradoCalidad']),
      normaTecnica: serializer.fromJson<String?>(json['normaTecnica']),
      requiereAlmacenCubierto: serializer.fromJson<bool>(
        json['requiereAlmacenCubierto'],
      ),
      materialPeligroso: serializer.fromJson<bool>(json['materialPeligroso']),
      imagenUrl: serializer.fromJson<String?>(json['imagenUrl']),
      fichaTecnicaUrl: serializer.fromJson<String?>(json['fichaTecnicaUrl']),
      activo: serializer.fromJson<bool>(json['activo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncId: serializer.fromJson<String?>(json['syncId']),
      lastSync: serializer.fromJson<DateTime?>(json['lastSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'codigo': serializer.toJson<String>(codigo),
      'descripcion': serializer.toJson<String?>(descripcion),
      'categoriaId': serializer.toJson<String>(categoriaId),
      'unidadMedidaId': serializer.toJson<String>(unidadMedidaId),
      'proveedorPrincipalId': serializer.toJson<String?>(proveedorPrincipalId),
      'precioCompra': serializer.toJson<double>(precioCompra),
      'precioVenta': serializer.toJson<double>(precioVenta),
      'pesoUnitarioKg': serializer.toJson<double?>(pesoUnitarioKg),
      'volumenUnitarioM3': serializer.toJson<double?>(volumenUnitarioM3),
      'stockMinimo': serializer.toJson<int>(stockMinimo),
      'stockMaximo': serializer.toJson<int>(stockMaximo),
      'marca': serializer.toJson<String?>(marca),
      'gradoCalidad': serializer.toJson<String?>(gradoCalidad),
      'normaTecnica': serializer.toJson<String?>(normaTecnica),
      'requiereAlmacenCubierto': serializer.toJson<bool>(
        requiereAlmacenCubierto,
      ),
      'materialPeligroso': serializer.toJson<bool>(materialPeligroso),
      'imagenUrl': serializer.toJson<String?>(imagenUrl),
      'fichaTecnicaUrl': serializer.toJson<String?>(fichaTecnicaUrl),
      'activo': serializer.toJson<bool>(activo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncId': serializer.toJson<String?>(syncId),
      'lastSync': serializer.toJson<DateTime?>(lastSync),
    };
  }

  ProductoTable copyWith({
    String? id,
    String? nombre,
    String? codigo,
    Value<String?> descripcion = const Value.absent(),
    String? categoriaId,
    String? unidadMedidaId,
    Value<String?> proveedorPrincipalId = const Value.absent(),
    double? precioCompra,
    double? precioVenta,
    Value<double?> pesoUnitarioKg = const Value.absent(),
    Value<double?> volumenUnitarioM3 = const Value.absent(),
    int? stockMinimo,
    int? stockMaximo,
    Value<String?> marca = const Value.absent(),
    Value<String?> gradoCalidad = const Value.absent(),
    Value<String?> normaTecnica = const Value.absent(),
    bool? requiereAlmacenCubierto,
    bool? materialPeligroso,
    Value<String?> imagenUrl = const Value.absent(),
    Value<String?> fichaTecnicaUrl = const Value.absent(),
    bool? activo,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> syncId = const Value.absent(),
    Value<DateTime?> lastSync = const Value.absent(),
  }) => ProductoTable(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    codigo: codigo ?? this.codigo,
    descripcion: descripcion.present ? descripcion.value : this.descripcion,
    categoriaId: categoriaId ?? this.categoriaId,
    unidadMedidaId: unidadMedidaId ?? this.unidadMedidaId,
    proveedorPrincipalId: proveedorPrincipalId.present
        ? proveedorPrincipalId.value
        : this.proveedorPrincipalId,
    precioCompra: precioCompra ?? this.precioCompra,
    precioVenta: precioVenta ?? this.precioVenta,
    pesoUnitarioKg: pesoUnitarioKg.present
        ? pesoUnitarioKg.value
        : this.pesoUnitarioKg,
    volumenUnitarioM3: volumenUnitarioM3.present
        ? volumenUnitarioM3.value
        : this.volumenUnitarioM3,
    stockMinimo: stockMinimo ?? this.stockMinimo,
    stockMaximo: stockMaximo ?? this.stockMaximo,
    marca: marca.present ? marca.value : this.marca,
    gradoCalidad: gradoCalidad.present ? gradoCalidad.value : this.gradoCalidad,
    normaTecnica: normaTecnica.present ? normaTecnica.value : this.normaTecnica,
    requiereAlmacenCubierto:
        requiereAlmacenCubierto ?? this.requiereAlmacenCubierto,
    materialPeligroso: materialPeligroso ?? this.materialPeligroso,
    imagenUrl: imagenUrl.present ? imagenUrl.value : this.imagenUrl,
    fichaTecnicaUrl: fichaTecnicaUrl.present
        ? fichaTecnicaUrl.value
        : this.fichaTecnicaUrl,
    activo: activo ?? this.activo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncId: syncId.present ? syncId.value : this.syncId,
    lastSync: lastSync.present ? lastSync.value : this.lastSync,
  );
  ProductoTable copyWithCompanion(ProductosCompanion data) {
    return ProductoTable(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      categoriaId: data.categoriaId.present
          ? data.categoriaId.value
          : this.categoriaId,
      unidadMedidaId: data.unidadMedidaId.present
          ? data.unidadMedidaId.value
          : this.unidadMedidaId,
      proveedorPrincipalId: data.proveedorPrincipalId.present
          ? data.proveedorPrincipalId.value
          : this.proveedorPrincipalId,
      precioCompra: data.precioCompra.present
          ? data.precioCompra.value
          : this.precioCompra,
      precioVenta: data.precioVenta.present
          ? data.precioVenta.value
          : this.precioVenta,
      pesoUnitarioKg: data.pesoUnitarioKg.present
          ? data.pesoUnitarioKg.value
          : this.pesoUnitarioKg,
      volumenUnitarioM3: data.volumenUnitarioM3.present
          ? data.volumenUnitarioM3.value
          : this.volumenUnitarioM3,
      stockMinimo: data.stockMinimo.present
          ? data.stockMinimo.value
          : this.stockMinimo,
      stockMaximo: data.stockMaximo.present
          ? data.stockMaximo.value
          : this.stockMaximo,
      marca: data.marca.present ? data.marca.value : this.marca,
      gradoCalidad: data.gradoCalidad.present
          ? data.gradoCalidad.value
          : this.gradoCalidad,
      normaTecnica: data.normaTecnica.present
          ? data.normaTecnica.value
          : this.normaTecnica,
      requiereAlmacenCubierto: data.requiereAlmacenCubierto.present
          ? data.requiereAlmacenCubierto.value
          : this.requiereAlmacenCubierto,
      materialPeligroso: data.materialPeligroso.present
          ? data.materialPeligroso.value
          : this.materialPeligroso,
      imagenUrl: data.imagenUrl.present ? data.imagenUrl.value : this.imagenUrl,
      fichaTecnicaUrl: data.fichaTecnicaUrl.present
          ? data.fichaTecnicaUrl.value
          : this.fichaTecnicaUrl,
      activo: data.activo.present ? data.activo.value : this.activo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      lastSync: data.lastSync.present ? data.lastSync.value : this.lastSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductoTable(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('descripcion: $descripcion, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('unidadMedidaId: $unidadMedidaId, ')
          ..write('proveedorPrincipalId: $proveedorPrincipalId, ')
          ..write('precioCompra: $precioCompra, ')
          ..write('precioVenta: $precioVenta, ')
          ..write('pesoUnitarioKg: $pesoUnitarioKg, ')
          ..write('volumenUnitarioM3: $volumenUnitarioM3, ')
          ..write('stockMinimo: $stockMinimo, ')
          ..write('stockMaximo: $stockMaximo, ')
          ..write('marca: $marca, ')
          ..write('gradoCalidad: $gradoCalidad, ')
          ..write('normaTecnica: $normaTecnica, ')
          ..write('requiereAlmacenCubierto: $requiereAlmacenCubierto, ')
          ..write('materialPeligroso: $materialPeligroso, ')
          ..write('imagenUrl: $imagenUrl, ')
          ..write('fichaTecnicaUrl: $fichaTecnicaUrl, ')
          ..write('activo: $activo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncId: $syncId, ')
          ..write('lastSync: $lastSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    nombre,
    codigo,
    descripcion,
    categoriaId,
    unidadMedidaId,
    proveedorPrincipalId,
    precioCompra,
    precioVenta,
    pesoUnitarioKg,
    volumenUnitarioM3,
    stockMinimo,
    stockMaximo,
    marca,
    gradoCalidad,
    normaTecnica,
    requiereAlmacenCubierto,
    materialPeligroso,
    imagenUrl,
    fichaTecnicaUrl,
    activo,
    createdAt,
    updatedAt,
    deletedAt,
    syncId,
    lastSync,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductoTable &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.codigo == this.codigo &&
          other.descripcion == this.descripcion &&
          other.categoriaId == this.categoriaId &&
          other.unidadMedidaId == this.unidadMedidaId &&
          other.proveedorPrincipalId == this.proveedorPrincipalId &&
          other.precioCompra == this.precioCompra &&
          other.precioVenta == this.precioVenta &&
          other.pesoUnitarioKg == this.pesoUnitarioKg &&
          other.volumenUnitarioM3 == this.volumenUnitarioM3 &&
          other.stockMinimo == this.stockMinimo &&
          other.stockMaximo == this.stockMaximo &&
          other.marca == this.marca &&
          other.gradoCalidad == this.gradoCalidad &&
          other.normaTecnica == this.normaTecnica &&
          other.requiereAlmacenCubierto == this.requiereAlmacenCubierto &&
          other.materialPeligroso == this.materialPeligroso &&
          other.imagenUrl == this.imagenUrl &&
          other.fichaTecnicaUrl == this.fichaTecnicaUrl &&
          other.activo == this.activo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncId == this.syncId &&
          other.lastSync == this.lastSync);
}

class ProductosCompanion extends UpdateCompanion<ProductoTable> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> codigo;
  final Value<String?> descripcion;
  final Value<String> categoriaId;
  final Value<String> unidadMedidaId;
  final Value<String?> proveedorPrincipalId;
  final Value<double> precioCompra;
  final Value<double> precioVenta;
  final Value<double?> pesoUnitarioKg;
  final Value<double?> volumenUnitarioM3;
  final Value<int> stockMinimo;
  final Value<int> stockMaximo;
  final Value<String?> marca;
  final Value<String?> gradoCalidad;
  final Value<String?> normaTecnica;
  final Value<bool> requiereAlmacenCubierto;
  final Value<bool> materialPeligroso;
  final Value<String?> imagenUrl;
  final Value<String?> fichaTecnicaUrl;
  final Value<bool> activo;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> syncId;
  final Value<DateTime?> lastSync;
  final Value<int> rowid;
  const ProductosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.codigo = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.unidadMedidaId = const Value.absent(),
    this.proveedorPrincipalId = const Value.absent(),
    this.precioCompra = const Value.absent(),
    this.precioVenta = const Value.absent(),
    this.pesoUnitarioKg = const Value.absent(),
    this.volumenUnitarioM3 = const Value.absent(),
    this.stockMinimo = const Value.absent(),
    this.stockMaximo = const Value.absent(),
    this.marca = const Value.absent(),
    this.gradoCalidad = const Value.absent(),
    this.normaTecnica = const Value.absent(),
    this.requiereAlmacenCubierto = const Value.absent(),
    this.materialPeligroso = const Value.absent(),
    this.imagenUrl = const Value.absent(),
    this.fichaTecnicaUrl = const Value.absent(),
    this.activo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductosCompanion.insert({
    required String id,
    required String nombre,
    required String codigo,
    this.descripcion = const Value.absent(),
    required String categoriaId,
    required String unidadMedidaId,
    this.proveedorPrincipalId = const Value.absent(),
    this.precioCompra = const Value.absent(),
    this.precioVenta = const Value.absent(),
    this.pesoUnitarioKg = const Value.absent(),
    this.volumenUnitarioM3 = const Value.absent(),
    this.stockMinimo = const Value.absent(),
    this.stockMaximo = const Value.absent(),
    this.marca = const Value.absent(),
    this.gradoCalidad = const Value.absent(),
    this.normaTecnica = const Value.absent(),
    this.requiereAlmacenCubierto = const Value.absent(),
    this.materialPeligroso = const Value.absent(),
    this.imagenUrl = const Value.absent(),
    this.fichaTecnicaUrl = const Value.absent(),
    this.activo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       codigo = Value(codigo),
       categoriaId = Value(categoriaId),
       unidadMedidaId = Value(unidadMedidaId);
  static Insertable<ProductoTable> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? codigo,
    Expression<String>? descripcion,
    Expression<String>? categoriaId,
    Expression<String>? unidadMedidaId,
    Expression<String>? proveedorPrincipalId,
    Expression<double>? precioCompra,
    Expression<double>? precioVenta,
    Expression<double>? pesoUnitarioKg,
    Expression<double>? volumenUnitarioM3,
    Expression<int>? stockMinimo,
    Expression<int>? stockMaximo,
    Expression<String>? marca,
    Expression<String>? gradoCalidad,
    Expression<String>? normaTecnica,
    Expression<bool>? requiereAlmacenCubierto,
    Expression<bool>? materialPeligroso,
    Expression<String>? imagenUrl,
    Expression<String>? fichaTecnicaUrl,
    Expression<bool>? activo,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncId,
    Expression<DateTime>? lastSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (codigo != null) 'codigo': codigo,
      if (descripcion != null) 'descripcion': descripcion,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (unidadMedidaId != null) 'unidad_medida_id': unidadMedidaId,
      if (proveedorPrincipalId != null)
        'proveedor_principal_id': proveedorPrincipalId,
      if (precioCompra != null) 'precio_compra': precioCompra,
      if (precioVenta != null) 'precio_venta': precioVenta,
      if (pesoUnitarioKg != null) 'peso_unitario_kg': pesoUnitarioKg,
      if (volumenUnitarioM3 != null) 'volumen_unitario_m3': volumenUnitarioM3,
      if (stockMinimo != null) 'stock_minimo': stockMinimo,
      if (stockMaximo != null) 'stock_maximo': stockMaximo,
      if (marca != null) 'marca': marca,
      if (gradoCalidad != null) 'grado_calidad': gradoCalidad,
      if (normaTecnica != null) 'norma_tecnica': normaTecnica,
      if (requiereAlmacenCubierto != null)
        'requiere_almacen_cubierto': requiereAlmacenCubierto,
      if (materialPeligroso != null) 'material_peligroso': materialPeligroso,
      if (imagenUrl != null) 'imagen_url': imagenUrl,
      if (fichaTecnicaUrl != null) 'ficha_tecnica_url': fichaTecnicaUrl,
      if (activo != null) 'activo': activo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncId != null) 'sync_id': syncId,
      if (lastSync != null) 'last_sync': lastSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductosCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? codigo,
    Value<String?>? descripcion,
    Value<String>? categoriaId,
    Value<String>? unidadMedidaId,
    Value<String?>? proveedorPrincipalId,
    Value<double>? precioCompra,
    Value<double>? precioVenta,
    Value<double?>? pesoUnitarioKg,
    Value<double?>? volumenUnitarioM3,
    Value<int>? stockMinimo,
    Value<int>? stockMaximo,
    Value<String?>? marca,
    Value<String?>? gradoCalidad,
    Value<String?>? normaTecnica,
    Value<bool>? requiereAlmacenCubierto,
    Value<bool>? materialPeligroso,
    Value<String?>? imagenUrl,
    Value<String?>? fichaTecnicaUrl,
    Value<bool>? activo,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? syncId,
    Value<DateTime?>? lastSync,
    Value<int>? rowid,
  }) {
    return ProductosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      codigo: codigo ?? this.codigo,
      descripcion: descripcion ?? this.descripcion,
      categoriaId: categoriaId ?? this.categoriaId,
      unidadMedidaId: unidadMedidaId ?? this.unidadMedidaId,
      proveedorPrincipalId: proveedorPrincipalId ?? this.proveedorPrincipalId,
      precioCompra: precioCompra ?? this.precioCompra,
      precioVenta: precioVenta ?? this.precioVenta,
      pesoUnitarioKg: pesoUnitarioKg ?? this.pesoUnitarioKg,
      volumenUnitarioM3: volumenUnitarioM3 ?? this.volumenUnitarioM3,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      stockMaximo: stockMaximo ?? this.stockMaximo,
      marca: marca ?? this.marca,
      gradoCalidad: gradoCalidad ?? this.gradoCalidad,
      normaTecnica: normaTecnica ?? this.normaTecnica,
      requiereAlmacenCubierto:
          requiereAlmacenCubierto ?? this.requiereAlmacenCubierto,
      materialPeligroso: materialPeligroso ?? this.materialPeligroso,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      fichaTecnicaUrl: fichaTecnicaUrl ?? this.fichaTecnicaUrl,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncId: syncId ?? this.syncId,
      lastSync: lastSync ?? this.lastSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<String>(categoriaId.value);
    }
    if (unidadMedidaId.present) {
      map['unidad_medida_id'] = Variable<String>(unidadMedidaId.value);
    }
    if (proveedorPrincipalId.present) {
      map['proveedor_principal_id'] = Variable<String>(
        proveedorPrincipalId.value,
      );
    }
    if (precioCompra.present) {
      map['precio_compra'] = Variable<double>(precioCompra.value);
    }
    if (precioVenta.present) {
      map['precio_venta'] = Variable<double>(precioVenta.value);
    }
    if (pesoUnitarioKg.present) {
      map['peso_unitario_kg'] = Variable<double>(pesoUnitarioKg.value);
    }
    if (volumenUnitarioM3.present) {
      map['volumen_unitario_m3'] = Variable<double>(volumenUnitarioM3.value);
    }
    if (stockMinimo.present) {
      map['stock_minimo'] = Variable<int>(stockMinimo.value);
    }
    if (stockMaximo.present) {
      map['stock_maximo'] = Variable<int>(stockMaximo.value);
    }
    if (marca.present) {
      map['marca'] = Variable<String>(marca.value);
    }
    if (gradoCalidad.present) {
      map['grado_calidad'] = Variable<String>(gradoCalidad.value);
    }
    if (normaTecnica.present) {
      map['norma_tecnica'] = Variable<String>(normaTecnica.value);
    }
    if (requiereAlmacenCubierto.present) {
      map['requiere_almacen_cubierto'] = Variable<bool>(
        requiereAlmacenCubierto.value,
      );
    }
    if (materialPeligroso.present) {
      map['material_peligroso'] = Variable<bool>(materialPeligroso.value);
    }
    if (imagenUrl.present) {
      map['imagen_url'] = Variable<String>(imagenUrl.value);
    }
    if (fichaTecnicaUrl.present) {
      map['ficha_tecnica_url'] = Variable<String>(fichaTecnicaUrl.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (lastSync.present) {
      map['last_sync'] = Variable<DateTime>(lastSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('descripcion: $descripcion, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('unidadMedidaId: $unidadMedidaId, ')
          ..write('proveedorPrincipalId: $proveedorPrincipalId, ')
          ..write('precioCompra: $precioCompra, ')
          ..write('precioVenta: $precioVenta, ')
          ..write('pesoUnitarioKg: $pesoUnitarioKg, ')
          ..write('volumenUnitarioM3: $volumenUnitarioM3, ')
          ..write('stockMinimo: $stockMinimo, ')
          ..write('stockMaximo: $stockMaximo, ')
          ..write('marca: $marca, ')
          ..write('gradoCalidad: $gradoCalidad, ')
          ..write('normaTecnica: $normaTecnica, ')
          ..write('requiereAlmacenCubierto: $requiereAlmacenCubierto, ')
          ..write('materialPeligroso: $materialPeligroso, ')
          ..write('imagenUrl: $imagenUrl, ')
          ..write('fichaTecnicaUrl: $fichaTecnicaUrl, ')
          ..write('activo: $activo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncId: $syncId, ')
          ..write('lastSync: $lastSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LotesTable extends Lotes with TableInfo<$LotesTable, LoteTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeroLoteMeta = const VerificationMeta(
    'numeroLote',
  );
  @override
  late final GeneratedColumn<String> numeroLote = GeneratedColumn<String>(
    'numero_lote',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _productoIdMeta = const VerificationMeta(
    'productoId',
  );
  @override
  late final GeneratedColumn<String> productoId = GeneratedColumn<String>(
    'producto_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES productos (id)',
    ),
  );
  static const VerificationMeta _fechaFabricacionMeta = const VerificationMeta(
    'fechaFabricacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaFabricacion =
      GeneratedColumn<DateTime>(
        'fecha_fabricacion',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _fechaVencimientoMeta = const VerificationMeta(
    'fechaVencimiento',
  );
  @override
  late final GeneratedColumn<DateTime> fechaVencimiento =
      GeneratedColumn<DateTime>(
        'fecha_vencimiento',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _proveedorIdMeta = const VerificationMeta(
    'proveedorId',
  );
  @override
  late final GeneratedColumn<String> proveedorId = GeneratedColumn<String>(
    'proveedor_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES proveedores (id)',
    ),
  );
  static const VerificationMeta _numeroFacturaMeta = const VerificationMeta(
    'numeroFactura',
  );
  @override
  late final GeneratedColumn<String> numeroFactura = GeneratedColumn<String>(
    'numero_factura',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cantidadInicialMeta = const VerificationMeta(
    'cantidadInicial',
  );
  @override
  late final GeneratedColumn<int> cantidadInicial = GeneratedColumn<int>(
    'cantidad_inicial',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cantidadActualMeta = const VerificationMeta(
    'cantidadActual',
  );
  @override
  late final GeneratedColumn<int> cantidadActual = GeneratedColumn<int>(
    'cantidad_actual',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _certificadoCalidadUrlMeta =
      const VerificationMeta('certificadoCalidadUrl');
  @override
  late final GeneratedColumn<String> certificadoCalidadUrl =
      GeneratedColumn<String>(
        'certificado_calidad_url',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _observacionesMeta = const VerificationMeta(
    'observaciones',
  );
  @override
  late final GeneratedColumn<String> observaciones = GeneratedColumn<String>(
    'observaciones',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
    'sync_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncMeta = const VerificationMeta(
    'lastSync',
  );
  @override
  late final GeneratedColumn<DateTime> lastSync = GeneratedColumn<DateTime>(
    'last_sync',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    numeroLote,
    productoId,
    fechaFabricacion,
    fechaVencimiento,
    proveedorId,
    numeroFactura,
    cantidadInicial,
    cantidadActual,
    certificadoCalidadUrl,
    observaciones,
    createdAt,
    updatedAt,
    syncId,
    lastSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lotes';
  @override
  VerificationContext validateIntegrity(
    Insertable<LoteTable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('numero_lote')) {
      context.handle(
        _numeroLoteMeta,
        numeroLote.isAcceptableOrUnknown(data['numero_lote']!, _numeroLoteMeta),
      );
    } else if (isInserting) {
      context.missing(_numeroLoteMeta);
    }
    if (data.containsKey('producto_id')) {
      context.handle(
        _productoIdMeta,
        productoId.isAcceptableOrUnknown(data['producto_id']!, _productoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('fecha_fabricacion')) {
      context.handle(
        _fechaFabricacionMeta,
        fechaFabricacion.isAcceptableOrUnknown(
          data['fecha_fabricacion']!,
          _fechaFabricacionMeta,
        ),
      );
    }
    if (data.containsKey('fecha_vencimiento')) {
      context.handle(
        _fechaVencimientoMeta,
        fechaVencimiento.isAcceptableOrUnknown(
          data['fecha_vencimiento']!,
          _fechaVencimientoMeta,
        ),
      );
    }
    if (data.containsKey('proveedor_id')) {
      context.handle(
        _proveedorIdMeta,
        proveedorId.isAcceptableOrUnknown(
          data['proveedor_id']!,
          _proveedorIdMeta,
        ),
      );
    }
    if (data.containsKey('numero_factura')) {
      context.handle(
        _numeroFacturaMeta,
        numeroFactura.isAcceptableOrUnknown(
          data['numero_factura']!,
          _numeroFacturaMeta,
        ),
      );
    }
    if (data.containsKey('cantidad_inicial')) {
      context.handle(
        _cantidadInicialMeta,
        cantidadInicial.isAcceptableOrUnknown(
          data['cantidad_inicial']!,
          _cantidadInicialMeta,
        ),
      );
    }
    if (data.containsKey('cantidad_actual')) {
      context.handle(
        _cantidadActualMeta,
        cantidadActual.isAcceptableOrUnknown(
          data['cantidad_actual']!,
          _cantidadActualMeta,
        ),
      );
    }
    if (data.containsKey('certificado_calidad_url')) {
      context.handle(
        _certificadoCalidadUrlMeta,
        certificadoCalidadUrl.isAcceptableOrUnknown(
          data['certificado_calidad_url']!,
          _certificadoCalidadUrlMeta,
        ),
      );
    }
    if (data.containsKey('observaciones')) {
      context.handle(
        _observacionesMeta,
        observaciones.isAcceptableOrUnknown(
          data['observaciones']!,
          _observacionesMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sync_id')) {
      context.handle(
        _syncIdMeta,
        syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta),
      );
    }
    if (data.containsKey('last_sync')) {
      context.handle(
        _lastSyncMeta,
        lastSync.isAcceptableOrUnknown(data['last_sync']!, _lastSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoteTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoteTable(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      numeroLote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numero_lote'],
      )!,
      productoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}producto_id'],
      )!,
      fechaFabricacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_fabricacion'],
      ),
      fechaVencimiento: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_vencimiento'],
      ),
      proveedorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proveedor_id'],
      ),
      numeroFactura: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numero_factura'],
      ),
      cantidadInicial: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad_inicial'],
      )!,
      cantidadActual: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad_actual'],
      )!,
      certificadoCalidadUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}certificado_calidad_url'],
      ),
      observaciones: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observaciones'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_id'],
      ),
      lastSync: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync'],
      ),
    );
  }

  @override
  $LotesTable createAlias(String alias) {
    return $LotesTable(attachedDatabase, alias);
  }
}

class LoteTable extends DataClass implements Insertable<LoteTable> {
  final String id;
  final String numeroLote;
  final String productoId;
  final DateTime? fechaFabricacion;
  final DateTime? fechaVencimiento;
  final String? proveedorId;
  final String? numeroFactura;
  final int cantidadInicial;
  final int cantidadActual;
  final String? certificadoCalidadUrl;
  final String? observaciones;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? syncId;
  final DateTime? lastSync;
  const LoteTable({
    required this.id,
    required this.numeroLote,
    required this.productoId,
    this.fechaFabricacion,
    this.fechaVencimiento,
    this.proveedorId,
    this.numeroFactura,
    required this.cantidadInicial,
    required this.cantidadActual,
    this.certificadoCalidadUrl,
    this.observaciones,
    required this.createdAt,
    required this.updatedAt,
    this.syncId,
    this.lastSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['numero_lote'] = Variable<String>(numeroLote);
    map['producto_id'] = Variable<String>(productoId);
    if (!nullToAbsent || fechaFabricacion != null) {
      map['fecha_fabricacion'] = Variable<DateTime>(fechaFabricacion);
    }
    if (!nullToAbsent || fechaVencimiento != null) {
      map['fecha_vencimiento'] = Variable<DateTime>(fechaVencimiento);
    }
    if (!nullToAbsent || proveedorId != null) {
      map['proveedor_id'] = Variable<String>(proveedorId);
    }
    if (!nullToAbsent || numeroFactura != null) {
      map['numero_factura'] = Variable<String>(numeroFactura);
    }
    map['cantidad_inicial'] = Variable<int>(cantidadInicial);
    map['cantidad_actual'] = Variable<int>(cantidadActual);
    if (!nullToAbsent || certificadoCalidadUrl != null) {
      map['certificado_calidad_url'] = Variable<String>(certificadoCalidadUrl);
    }
    if (!nullToAbsent || observaciones != null) {
      map['observaciones'] = Variable<String>(observaciones);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncId != null) {
      map['sync_id'] = Variable<String>(syncId);
    }
    if (!nullToAbsent || lastSync != null) {
      map['last_sync'] = Variable<DateTime>(lastSync);
    }
    return map;
  }

  LotesCompanion toCompanion(bool nullToAbsent) {
    return LotesCompanion(
      id: Value(id),
      numeroLote: Value(numeroLote),
      productoId: Value(productoId),
      fechaFabricacion: fechaFabricacion == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaFabricacion),
      fechaVencimiento: fechaVencimiento == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaVencimiento),
      proveedorId: proveedorId == null && nullToAbsent
          ? const Value.absent()
          : Value(proveedorId),
      numeroFactura: numeroFactura == null && nullToAbsent
          ? const Value.absent()
          : Value(numeroFactura),
      cantidadInicial: Value(cantidadInicial),
      cantidadActual: Value(cantidadActual),
      certificadoCalidadUrl: certificadoCalidadUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(certificadoCalidadUrl),
      observaciones: observaciones == null && nullToAbsent
          ? const Value.absent()
          : Value(observaciones),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncId: syncId == null && nullToAbsent
          ? const Value.absent()
          : Value(syncId),
      lastSync: lastSync == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSync),
    );
  }

  factory LoteTable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoteTable(
      id: serializer.fromJson<String>(json['id']),
      numeroLote: serializer.fromJson<String>(json['numeroLote']),
      productoId: serializer.fromJson<String>(json['productoId']),
      fechaFabricacion: serializer.fromJson<DateTime?>(
        json['fechaFabricacion'],
      ),
      fechaVencimiento: serializer.fromJson<DateTime?>(
        json['fechaVencimiento'],
      ),
      proveedorId: serializer.fromJson<String?>(json['proveedorId']),
      numeroFactura: serializer.fromJson<String?>(json['numeroFactura']),
      cantidadInicial: serializer.fromJson<int>(json['cantidadInicial']),
      cantidadActual: serializer.fromJson<int>(json['cantidadActual']),
      certificadoCalidadUrl: serializer.fromJson<String?>(
        json['certificadoCalidadUrl'],
      ),
      observaciones: serializer.fromJson<String?>(json['observaciones']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncId: serializer.fromJson<String?>(json['syncId']),
      lastSync: serializer.fromJson<DateTime?>(json['lastSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'numeroLote': serializer.toJson<String>(numeroLote),
      'productoId': serializer.toJson<String>(productoId),
      'fechaFabricacion': serializer.toJson<DateTime?>(fechaFabricacion),
      'fechaVencimiento': serializer.toJson<DateTime?>(fechaVencimiento),
      'proveedorId': serializer.toJson<String?>(proveedorId),
      'numeroFactura': serializer.toJson<String?>(numeroFactura),
      'cantidadInicial': serializer.toJson<int>(cantidadInicial),
      'cantidadActual': serializer.toJson<int>(cantidadActual),
      'certificadoCalidadUrl': serializer.toJson<String?>(
        certificadoCalidadUrl,
      ),
      'observaciones': serializer.toJson<String?>(observaciones),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncId': serializer.toJson<String?>(syncId),
      'lastSync': serializer.toJson<DateTime?>(lastSync),
    };
  }

  LoteTable copyWith({
    String? id,
    String? numeroLote,
    String? productoId,
    Value<DateTime?> fechaFabricacion = const Value.absent(),
    Value<DateTime?> fechaVencimiento = const Value.absent(),
    Value<String?> proveedorId = const Value.absent(),
    Value<String?> numeroFactura = const Value.absent(),
    int? cantidadInicial,
    int? cantidadActual,
    Value<String?> certificadoCalidadUrl = const Value.absent(),
    Value<String?> observaciones = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<String?> syncId = const Value.absent(),
    Value<DateTime?> lastSync = const Value.absent(),
  }) => LoteTable(
    id: id ?? this.id,
    numeroLote: numeroLote ?? this.numeroLote,
    productoId: productoId ?? this.productoId,
    fechaFabricacion: fechaFabricacion.present
        ? fechaFabricacion.value
        : this.fechaFabricacion,
    fechaVencimiento: fechaVencimiento.present
        ? fechaVencimiento.value
        : this.fechaVencimiento,
    proveedorId: proveedorId.present ? proveedorId.value : this.proveedorId,
    numeroFactura: numeroFactura.present
        ? numeroFactura.value
        : this.numeroFactura,
    cantidadInicial: cantidadInicial ?? this.cantidadInicial,
    cantidadActual: cantidadActual ?? this.cantidadActual,
    certificadoCalidadUrl: certificadoCalidadUrl.present
        ? certificadoCalidadUrl.value
        : this.certificadoCalidadUrl,
    observaciones: observaciones.present
        ? observaciones.value
        : this.observaciones,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncId: syncId.present ? syncId.value : this.syncId,
    lastSync: lastSync.present ? lastSync.value : this.lastSync,
  );
  LoteTable copyWithCompanion(LotesCompanion data) {
    return LoteTable(
      id: data.id.present ? data.id.value : this.id,
      numeroLote: data.numeroLote.present
          ? data.numeroLote.value
          : this.numeroLote,
      productoId: data.productoId.present
          ? data.productoId.value
          : this.productoId,
      fechaFabricacion: data.fechaFabricacion.present
          ? data.fechaFabricacion.value
          : this.fechaFabricacion,
      fechaVencimiento: data.fechaVencimiento.present
          ? data.fechaVencimiento.value
          : this.fechaVencimiento,
      proveedorId: data.proveedorId.present
          ? data.proveedorId.value
          : this.proveedorId,
      numeroFactura: data.numeroFactura.present
          ? data.numeroFactura.value
          : this.numeroFactura,
      cantidadInicial: data.cantidadInicial.present
          ? data.cantidadInicial.value
          : this.cantidadInicial,
      cantidadActual: data.cantidadActual.present
          ? data.cantidadActual.value
          : this.cantidadActual,
      certificadoCalidadUrl: data.certificadoCalidadUrl.present
          ? data.certificadoCalidadUrl.value
          : this.certificadoCalidadUrl,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      lastSync: data.lastSync.present ? data.lastSync.value : this.lastSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoteTable(')
          ..write('id: $id, ')
          ..write('numeroLote: $numeroLote, ')
          ..write('productoId: $productoId, ')
          ..write('fechaFabricacion: $fechaFabricacion, ')
          ..write('fechaVencimiento: $fechaVencimiento, ')
          ..write('proveedorId: $proveedorId, ')
          ..write('numeroFactura: $numeroFactura, ')
          ..write('cantidadInicial: $cantidadInicial, ')
          ..write('cantidadActual: $cantidadActual, ')
          ..write('certificadoCalidadUrl: $certificadoCalidadUrl, ')
          ..write('observaciones: $observaciones, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('lastSync: $lastSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    numeroLote,
    productoId,
    fechaFabricacion,
    fechaVencimiento,
    proveedorId,
    numeroFactura,
    cantidadInicial,
    cantidadActual,
    certificadoCalidadUrl,
    observaciones,
    createdAt,
    updatedAt,
    syncId,
    lastSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoteTable &&
          other.id == this.id &&
          other.numeroLote == this.numeroLote &&
          other.productoId == this.productoId &&
          other.fechaFabricacion == this.fechaFabricacion &&
          other.fechaVencimiento == this.fechaVencimiento &&
          other.proveedorId == this.proveedorId &&
          other.numeroFactura == this.numeroFactura &&
          other.cantidadInicial == this.cantidadInicial &&
          other.cantidadActual == this.cantidadActual &&
          other.certificadoCalidadUrl == this.certificadoCalidadUrl &&
          other.observaciones == this.observaciones &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncId == this.syncId &&
          other.lastSync == this.lastSync);
}

class LotesCompanion extends UpdateCompanion<LoteTable> {
  final Value<String> id;
  final Value<String> numeroLote;
  final Value<String> productoId;
  final Value<DateTime?> fechaFabricacion;
  final Value<DateTime?> fechaVencimiento;
  final Value<String?> proveedorId;
  final Value<String?> numeroFactura;
  final Value<int> cantidadInicial;
  final Value<int> cantidadActual;
  final Value<String?> certificadoCalidadUrl;
  final Value<String?> observaciones;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> syncId;
  final Value<DateTime?> lastSync;
  final Value<int> rowid;
  const LotesCompanion({
    this.id = const Value.absent(),
    this.numeroLote = const Value.absent(),
    this.productoId = const Value.absent(),
    this.fechaFabricacion = const Value.absent(),
    this.fechaVencimiento = const Value.absent(),
    this.proveedorId = const Value.absent(),
    this.numeroFactura = const Value.absent(),
    this.cantidadInicial = const Value.absent(),
    this.cantidadActual = const Value.absent(),
    this.certificadoCalidadUrl = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LotesCompanion.insert({
    required String id,
    required String numeroLote,
    required String productoId,
    this.fechaFabricacion = const Value.absent(),
    this.fechaVencimiento = const Value.absent(),
    this.proveedorId = const Value.absent(),
    this.numeroFactura = const Value.absent(),
    this.cantidadInicial = const Value.absent(),
    this.cantidadActual = const Value.absent(),
    this.certificadoCalidadUrl = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       numeroLote = Value(numeroLote),
       productoId = Value(productoId);
  static Insertable<LoteTable> custom({
    Expression<String>? id,
    Expression<String>? numeroLote,
    Expression<String>? productoId,
    Expression<DateTime>? fechaFabricacion,
    Expression<DateTime>? fechaVencimiento,
    Expression<String>? proveedorId,
    Expression<String>? numeroFactura,
    Expression<int>? cantidadInicial,
    Expression<int>? cantidadActual,
    Expression<String>? certificadoCalidadUrl,
    Expression<String>? observaciones,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncId,
    Expression<DateTime>? lastSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (numeroLote != null) 'numero_lote': numeroLote,
      if (productoId != null) 'producto_id': productoId,
      if (fechaFabricacion != null) 'fecha_fabricacion': fechaFabricacion,
      if (fechaVencimiento != null) 'fecha_vencimiento': fechaVencimiento,
      if (proveedorId != null) 'proveedor_id': proveedorId,
      if (numeroFactura != null) 'numero_factura': numeroFactura,
      if (cantidadInicial != null) 'cantidad_inicial': cantidadInicial,
      if (cantidadActual != null) 'cantidad_actual': cantidadActual,
      if (certificadoCalidadUrl != null)
        'certificado_calidad_url': certificadoCalidadUrl,
      if (observaciones != null) 'observaciones': observaciones,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncId != null) 'sync_id': syncId,
      if (lastSync != null) 'last_sync': lastSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LotesCompanion copyWith({
    Value<String>? id,
    Value<String>? numeroLote,
    Value<String>? productoId,
    Value<DateTime?>? fechaFabricacion,
    Value<DateTime?>? fechaVencimiento,
    Value<String?>? proveedorId,
    Value<String?>? numeroFactura,
    Value<int>? cantidadInicial,
    Value<int>? cantidadActual,
    Value<String?>? certificadoCalidadUrl,
    Value<String?>? observaciones,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? syncId,
    Value<DateTime?>? lastSync,
    Value<int>? rowid,
  }) {
    return LotesCompanion(
      id: id ?? this.id,
      numeroLote: numeroLote ?? this.numeroLote,
      productoId: productoId ?? this.productoId,
      fechaFabricacion: fechaFabricacion ?? this.fechaFabricacion,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      proveedorId: proveedorId ?? this.proveedorId,
      numeroFactura: numeroFactura ?? this.numeroFactura,
      cantidadInicial: cantidadInicial ?? this.cantidadInicial,
      cantidadActual: cantidadActual ?? this.cantidadActual,
      certificadoCalidadUrl:
          certificadoCalidadUrl ?? this.certificadoCalidadUrl,
      observaciones: observaciones ?? this.observaciones,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncId: syncId ?? this.syncId,
      lastSync: lastSync ?? this.lastSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (numeroLote.present) {
      map['numero_lote'] = Variable<String>(numeroLote.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<String>(productoId.value);
    }
    if (fechaFabricacion.present) {
      map['fecha_fabricacion'] = Variable<DateTime>(fechaFabricacion.value);
    }
    if (fechaVencimiento.present) {
      map['fecha_vencimiento'] = Variable<DateTime>(fechaVencimiento.value);
    }
    if (proveedorId.present) {
      map['proveedor_id'] = Variable<String>(proveedorId.value);
    }
    if (numeroFactura.present) {
      map['numero_factura'] = Variable<String>(numeroFactura.value);
    }
    if (cantidadInicial.present) {
      map['cantidad_inicial'] = Variable<int>(cantidadInicial.value);
    }
    if (cantidadActual.present) {
      map['cantidad_actual'] = Variable<int>(cantidadActual.value);
    }
    if (certificadoCalidadUrl.present) {
      map['certificado_calidad_url'] = Variable<String>(
        certificadoCalidadUrl.value,
      );
    }
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (lastSync.present) {
      map['last_sync'] = Variable<DateTime>(lastSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LotesCompanion(')
          ..write('id: $id, ')
          ..write('numeroLote: $numeroLote, ')
          ..write('productoId: $productoId, ')
          ..write('fechaFabricacion: $fechaFabricacion, ')
          ..write('fechaVencimiento: $fechaVencimiento, ')
          ..write('proveedorId: $proveedorId, ')
          ..write('numeroFactura: $numeroFactura, ')
          ..write('cantidadInicial: $cantidadInicial, ')
          ..write('cantidadActual: $cantidadActual, ')
          ..write('certificadoCalidadUrl: $certificadoCalidadUrl, ')
          ..write('observaciones: $observaciones, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('lastSync: $lastSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventariosTable extends Inventarios
    with TableInfo<$InventariosTable, InventarioTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventariosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productoIdMeta = const VerificationMeta(
    'productoId',
  );
  @override
  late final GeneratedColumn<String> productoId = GeneratedColumn<String>(
    'producto_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES productos (id)',
    ),
  );
  static const VerificationMeta _almacenIdMeta = const VerificationMeta(
    'almacenId',
  );
  @override
  late final GeneratedColumn<String> almacenId = GeneratedColumn<String>(
    'almacen_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES almacenes (id)',
    ),
  );
  static const VerificationMeta _tiendaIdMeta = const VerificationMeta(
    'tiendaId',
  );
  @override
  late final GeneratedColumn<String> tiendaId = GeneratedColumn<String>(
    'tienda_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tiendas (id)',
    ),
  );
  static const VerificationMeta _loteIdMeta = const VerificationMeta('loteId');
  @override
  late final GeneratedColumn<String> loteId = GeneratedColumn<String>(
    'lote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES lotes (id)',
    ),
  );
  static const VerificationMeta _cantidadActualMeta = const VerificationMeta(
    'cantidadActual',
  );
  @override
  late final GeneratedColumn<int> cantidadActual = GeneratedColumn<int>(
    'cantidad_actual',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cantidadReservadaMeta = const VerificationMeta(
    'cantidadReservada',
  );
  @override
  late final GeneratedColumn<int> cantidadReservada = GeneratedColumn<int>(
    'cantidad_reservada',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cantidadDisponibleMeta =
      const VerificationMeta('cantidadDisponible');
  @override
  late final GeneratedColumn<int> cantidadDisponible = GeneratedColumn<int>(
    'cantidad_disponible',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _valorTotalMeta = const VerificationMeta(
    'valorTotal',
  );
  @override
  late final GeneratedColumn<double> valorTotal = GeneratedColumn<double>(
    'valor_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _ubicacionFisicaMeta = const VerificationMeta(
    'ubicacionFisica',
  );
  @override
  late final GeneratedColumn<String> ubicacionFisica = GeneratedColumn<String>(
    'ubicacion_fisica',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ultimaActualizacionMeta =
      const VerificationMeta('ultimaActualizacion');
  @override
  late final GeneratedColumn<DateTime> ultimaActualizacion =
      GeneratedColumn<DateTime>(
        'ultima_actualizacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
    'sync_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncMeta = const VerificationMeta(
    'lastSync',
  );
  @override
  late final GeneratedColumn<DateTime> lastSync = GeneratedColumn<DateTime>(
    'last_sync',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productoId,
    almacenId,
    tiendaId,
    loteId,
    cantidadActual,
    cantidadReservada,
    cantidadDisponible,
    valorTotal,
    ubicacionFisica,
    ultimaActualizacion,
    createdAt,
    updatedAt,
    syncId,
    lastSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventarios';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventarioTable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('producto_id')) {
      context.handle(
        _productoIdMeta,
        productoId.isAcceptableOrUnknown(data['producto_id']!, _productoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('almacen_id')) {
      context.handle(
        _almacenIdMeta,
        almacenId.isAcceptableOrUnknown(data['almacen_id']!, _almacenIdMeta),
      );
    } else if (isInserting) {
      context.missing(_almacenIdMeta);
    }
    if (data.containsKey('tienda_id')) {
      context.handle(
        _tiendaIdMeta,
        tiendaId.isAcceptableOrUnknown(data['tienda_id']!, _tiendaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tiendaIdMeta);
    }
    if (data.containsKey('lote_id')) {
      context.handle(
        _loteIdMeta,
        loteId.isAcceptableOrUnknown(data['lote_id']!, _loteIdMeta),
      );
    }
    if (data.containsKey('cantidad_actual')) {
      context.handle(
        _cantidadActualMeta,
        cantidadActual.isAcceptableOrUnknown(
          data['cantidad_actual']!,
          _cantidadActualMeta,
        ),
      );
    }
    if (data.containsKey('cantidad_reservada')) {
      context.handle(
        _cantidadReservadaMeta,
        cantidadReservada.isAcceptableOrUnknown(
          data['cantidad_reservada']!,
          _cantidadReservadaMeta,
        ),
      );
    }
    if (data.containsKey('cantidad_disponible')) {
      context.handle(
        _cantidadDisponibleMeta,
        cantidadDisponible.isAcceptableOrUnknown(
          data['cantidad_disponible']!,
          _cantidadDisponibleMeta,
        ),
      );
    }
    if (data.containsKey('valor_total')) {
      context.handle(
        _valorTotalMeta,
        valorTotal.isAcceptableOrUnknown(data['valor_total']!, _valorTotalMeta),
      );
    }
    if (data.containsKey('ubicacion_fisica')) {
      context.handle(
        _ubicacionFisicaMeta,
        ubicacionFisica.isAcceptableOrUnknown(
          data['ubicacion_fisica']!,
          _ubicacionFisicaMeta,
        ),
      );
    }
    if (data.containsKey('ultima_actualizacion')) {
      context.handle(
        _ultimaActualizacionMeta,
        ultimaActualizacion.isAcceptableOrUnknown(
          data['ultima_actualizacion']!,
          _ultimaActualizacionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sync_id')) {
      context.handle(
        _syncIdMeta,
        syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta),
      );
    }
    if (data.containsKey('last_sync')) {
      context.handle(
        _lastSyncMeta,
        lastSync.isAcceptableOrUnknown(data['last_sync']!, _lastSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventarioTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventarioTable(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}producto_id'],
      )!,
      almacenId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}almacen_id'],
      )!,
      tiendaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tienda_id'],
      )!,
      loteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lote_id'],
      ),
      cantidadActual: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad_actual'],
      )!,
      cantidadReservada: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad_reservada'],
      )!,
      cantidadDisponible: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad_disponible'],
      )!,
      valorTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}valor_total'],
      )!,
      ubicacionFisica: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ubicacion_fisica'],
      ),
      ultimaActualizacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ultima_actualizacion'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_id'],
      ),
      lastSync: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync'],
      ),
    );
  }

  @override
  $InventariosTable createAlias(String alias) {
    return $InventariosTable(attachedDatabase, alias);
  }
}

class InventarioTable extends DataClass implements Insertable<InventarioTable> {
  final String id;
  final String productoId;
  final String almacenId;
  final String tiendaId;
  final String? loteId;
  final int cantidadActual;
  final int cantidadReservada;
  final int cantidadDisponible;
  final double valorTotal;
  final String? ubicacionFisica;
  final DateTime ultimaActualizacion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? syncId;
  final DateTime? lastSync;
  const InventarioTable({
    required this.id,
    required this.productoId,
    required this.almacenId,
    required this.tiendaId,
    this.loteId,
    required this.cantidadActual,
    required this.cantidadReservada,
    required this.cantidadDisponible,
    required this.valorTotal,
    this.ubicacionFisica,
    required this.ultimaActualizacion,
    required this.createdAt,
    required this.updatedAt,
    this.syncId,
    this.lastSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['producto_id'] = Variable<String>(productoId);
    map['almacen_id'] = Variable<String>(almacenId);
    map['tienda_id'] = Variable<String>(tiendaId);
    if (!nullToAbsent || loteId != null) {
      map['lote_id'] = Variable<String>(loteId);
    }
    map['cantidad_actual'] = Variable<int>(cantidadActual);
    map['cantidad_reservada'] = Variable<int>(cantidadReservada);
    map['cantidad_disponible'] = Variable<int>(cantidadDisponible);
    map['valor_total'] = Variable<double>(valorTotal);
    if (!nullToAbsent || ubicacionFisica != null) {
      map['ubicacion_fisica'] = Variable<String>(ubicacionFisica);
    }
    map['ultima_actualizacion'] = Variable<DateTime>(ultimaActualizacion);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncId != null) {
      map['sync_id'] = Variable<String>(syncId);
    }
    if (!nullToAbsent || lastSync != null) {
      map['last_sync'] = Variable<DateTime>(lastSync);
    }
    return map;
  }

  InventariosCompanion toCompanion(bool nullToAbsent) {
    return InventariosCompanion(
      id: Value(id),
      productoId: Value(productoId),
      almacenId: Value(almacenId),
      tiendaId: Value(tiendaId),
      loteId: loteId == null && nullToAbsent
          ? const Value.absent()
          : Value(loteId),
      cantidadActual: Value(cantidadActual),
      cantidadReservada: Value(cantidadReservada),
      cantidadDisponible: Value(cantidadDisponible),
      valorTotal: Value(valorTotal),
      ubicacionFisica: ubicacionFisica == null && nullToAbsent
          ? const Value.absent()
          : Value(ubicacionFisica),
      ultimaActualizacion: Value(ultimaActualizacion),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncId: syncId == null && nullToAbsent
          ? const Value.absent()
          : Value(syncId),
      lastSync: lastSync == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSync),
    );
  }

  factory InventarioTable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventarioTable(
      id: serializer.fromJson<String>(json['id']),
      productoId: serializer.fromJson<String>(json['productoId']),
      almacenId: serializer.fromJson<String>(json['almacenId']),
      tiendaId: serializer.fromJson<String>(json['tiendaId']),
      loteId: serializer.fromJson<String?>(json['loteId']),
      cantidadActual: serializer.fromJson<int>(json['cantidadActual']),
      cantidadReservada: serializer.fromJson<int>(json['cantidadReservada']),
      cantidadDisponible: serializer.fromJson<int>(json['cantidadDisponible']),
      valorTotal: serializer.fromJson<double>(json['valorTotal']),
      ubicacionFisica: serializer.fromJson<String?>(json['ubicacionFisica']),
      ultimaActualizacion: serializer.fromJson<DateTime>(
        json['ultimaActualizacion'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncId: serializer.fromJson<String?>(json['syncId']),
      lastSync: serializer.fromJson<DateTime?>(json['lastSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productoId': serializer.toJson<String>(productoId),
      'almacenId': serializer.toJson<String>(almacenId),
      'tiendaId': serializer.toJson<String>(tiendaId),
      'loteId': serializer.toJson<String?>(loteId),
      'cantidadActual': serializer.toJson<int>(cantidadActual),
      'cantidadReservada': serializer.toJson<int>(cantidadReservada),
      'cantidadDisponible': serializer.toJson<int>(cantidadDisponible),
      'valorTotal': serializer.toJson<double>(valorTotal),
      'ubicacionFisica': serializer.toJson<String?>(ubicacionFisica),
      'ultimaActualizacion': serializer.toJson<DateTime>(ultimaActualizacion),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncId': serializer.toJson<String?>(syncId),
      'lastSync': serializer.toJson<DateTime?>(lastSync),
    };
  }

  InventarioTable copyWith({
    String? id,
    String? productoId,
    String? almacenId,
    String? tiendaId,
    Value<String?> loteId = const Value.absent(),
    int? cantidadActual,
    int? cantidadReservada,
    int? cantidadDisponible,
    double? valorTotal,
    Value<String?> ubicacionFisica = const Value.absent(),
    DateTime? ultimaActualizacion,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<String?> syncId = const Value.absent(),
    Value<DateTime?> lastSync = const Value.absent(),
  }) => InventarioTable(
    id: id ?? this.id,
    productoId: productoId ?? this.productoId,
    almacenId: almacenId ?? this.almacenId,
    tiendaId: tiendaId ?? this.tiendaId,
    loteId: loteId.present ? loteId.value : this.loteId,
    cantidadActual: cantidadActual ?? this.cantidadActual,
    cantidadReservada: cantidadReservada ?? this.cantidadReservada,
    cantidadDisponible: cantidadDisponible ?? this.cantidadDisponible,
    valorTotal: valorTotal ?? this.valorTotal,
    ubicacionFisica: ubicacionFisica.present
        ? ubicacionFisica.value
        : this.ubicacionFisica,
    ultimaActualizacion: ultimaActualizacion ?? this.ultimaActualizacion,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncId: syncId.present ? syncId.value : this.syncId,
    lastSync: lastSync.present ? lastSync.value : this.lastSync,
  );
  InventarioTable copyWithCompanion(InventariosCompanion data) {
    return InventarioTable(
      id: data.id.present ? data.id.value : this.id,
      productoId: data.productoId.present
          ? data.productoId.value
          : this.productoId,
      almacenId: data.almacenId.present ? data.almacenId.value : this.almacenId,
      tiendaId: data.tiendaId.present ? data.tiendaId.value : this.tiendaId,
      loteId: data.loteId.present ? data.loteId.value : this.loteId,
      cantidadActual: data.cantidadActual.present
          ? data.cantidadActual.value
          : this.cantidadActual,
      cantidadReservada: data.cantidadReservada.present
          ? data.cantidadReservada.value
          : this.cantidadReservada,
      cantidadDisponible: data.cantidadDisponible.present
          ? data.cantidadDisponible.value
          : this.cantidadDisponible,
      valorTotal: data.valorTotal.present
          ? data.valorTotal.value
          : this.valorTotal,
      ubicacionFisica: data.ubicacionFisica.present
          ? data.ubicacionFisica.value
          : this.ubicacionFisica,
      ultimaActualizacion: data.ultimaActualizacion.present
          ? data.ultimaActualizacion.value
          : this.ultimaActualizacion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      lastSync: data.lastSync.present ? data.lastSync.value : this.lastSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventarioTable(')
          ..write('id: $id, ')
          ..write('productoId: $productoId, ')
          ..write('almacenId: $almacenId, ')
          ..write('tiendaId: $tiendaId, ')
          ..write('loteId: $loteId, ')
          ..write('cantidadActual: $cantidadActual, ')
          ..write('cantidadReservada: $cantidadReservada, ')
          ..write('cantidadDisponible: $cantidadDisponible, ')
          ..write('valorTotal: $valorTotal, ')
          ..write('ubicacionFisica: $ubicacionFisica, ')
          ..write('ultimaActualizacion: $ultimaActualizacion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('lastSync: $lastSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productoId,
    almacenId,
    tiendaId,
    loteId,
    cantidadActual,
    cantidadReservada,
    cantidadDisponible,
    valorTotal,
    ubicacionFisica,
    ultimaActualizacion,
    createdAt,
    updatedAt,
    syncId,
    lastSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventarioTable &&
          other.id == this.id &&
          other.productoId == this.productoId &&
          other.almacenId == this.almacenId &&
          other.tiendaId == this.tiendaId &&
          other.loteId == this.loteId &&
          other.cantidadActual == this.cantidadActual &&
          other.cantidadReservada == this.cantidadReservada &&
          other.cantidadDisponible == this.cantidadDisponible &&
          other.valorTotal == this.valorTotal &&
          other.ubicacionFisica == this.ubicacionFisica &&
          other.ultimaActualizacion == this.ultimaActualizacion &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncId == this.syncId &&
          other.lastSync == this.lastSync);
}

class InventariosCompanion extends UpdateCompanion<InventarioTable> {
  final Value<String> id;
  final Value<String> productoId;
  final Value<String> almacenId;
  final Value<String> tiendaId;
  final Value<String?> loteId;
  final Value<int> cantidadActual;
  final Value<int> cantidadReservada;
  final Value<int> cantidadDisponible;
  final Value<double> valorTotal;
  final Value<String?> ubicacionFisica;
  final Value<DateTime> ultimaActualizacion;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> syncId;
  final Value<DateTime?> lastSync;
  final Value<int> rowid;
  const InventariosCompanion({
    this.id = const Value.absent(),
    this.productoId = const Value.absent(),
    this.almacenId = const Value.absent(),
    this.tiendaId = const Value.absent(),
    this.loteId = const Value.absent(),
    this.cantidadActual = const Value.absent(),
    this.cantidadReservada = const Value.absent(),
    this.cantidadDisponible = const Value.absent(),
    this.valorTotal = const Value.absent(),
    this.ubicacionFisica = const Value.absent(),
    this.ultimaActualizacion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventariosCompanion.insert({
    required String id,
    required String productoId,
    required String almacenId,
    required String tiendaId,
    this.loteId = const Value.absent(),
    this.cantidadActual = const Value.absent(),
    this.cantidadReservada = const Value.absent(),
    this.cantidadDisponible = const Value.absent(),
    this.valorTotal = const Value.absent(),
    this.ubicacionFisica = const Value.absent(),
    this.ultimaActualizacion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productoId = Value(productoId),
       almacenId = Value(almacenId),
       tiendaId = Value(tiendaId);
  static Insertable<InventarioTable> custom({
    Expression<String>? id,
    Expression<String>? productoId,
    Expression<String>? almacenId,
    Expression<String>? tiendaId,
    Expression<String>? loteId,
    Expression<int>? cantidadActual,
    Expression<int>? cantidadReservada,
    Expression<int>? cantidadDisponible,
    Expression<double>? valorTotal,
    Expression<String>? ubicacionFisica,
    Expression<DateTime>? ultimaActualizacion,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncId,
    Expression<DateTime>? lastSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productoId != null) 'producto_id': productoId,
      if (almacenId != null) 'almacen_id': almacenId,
      if (tiendaId != null) 'tienda_id': tiendaId,
      if (loteId != null) 'lote_id': loteId,
      if (cantidadActual != null) 'cantidad_actual': cantidadActual,
      if (cantidadReservada != null) 'cantidad_reservada': cantidadReservada,
      if (cantidadDisponible != null) 'cantidad_disponible': cantidadDisponible,
      if (valorTotal != null) 'valor_total': valorTotal,
      if (ubicacionFisica != null) 'ubicacion_fisica': ubicacionFisica,
      if (ultimaActualizacion != null)
        'ultima_actualizacion': ultimaActualizacion,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncId != null) 'sync_id': syncId,
      if (lastSync != null) 'last_sync': lastSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventariosCompanion copyWith({
    Value<String>? id,
    Value<String>? productoId,
    Value<String>? almacenId,
    Value<String>? tiendaId,
    Value<String?>? loteId,
    Value<int>? cantidadActual,
    Value<int>? cantidadReservada,
    Value<int>? cantidadDisponible,
    Value<double>? valorTotal,
    Value<String?>? ubicacionFisica,
    Value<DateTime>? ultimaActualizacion,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? syncId,
    Value<DateTime?>? lastSync,
    Value<int>? rowid,
  }) {
    return InventariosCompanion(
      id: id ?? this.id,
      productoId: productoId ?? this.productoId,
      almacenId: almacenId ?? this.almacenId,
      tiendaId: tiendaId ?? this.tiendaId,
      loteId: loteId ?? this.loteId,
      cantidadActual: cantidadActual ?? this.cantidadActual,
      cantidadReservada: cantidadReservada ?? this.cantidadReservada,
      cantidadDisponible: cantidadDisponible ?? this.cantidadDisponible,
      valorTotal: valorTotal ?? this.valorTotal,
      ubicacionFisica: ubicacionFisica ?? this.ubicacionFisica,
      ultimaActualizacion: ultimaActualizacion ?? this.ultimaActualizacion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncId: syncId ?? this.syncId,
      lastSync: lastSync ?? this.lastSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<String>(productoId.value);
    }
    if (almacenId.present) {
      map['almacen_id'] = Variable<String>(almacenId.value);
    }
    if (tiendaId.present) {
      map['tienda_id'] = Variable<String>(tiendaId.value);
    }
    if (loteId.present) {
      map['lote_id'] = Variable<String>(loteId.value);
    }
    if (cantidadActual.present) {
      map['cantidad_actual'] = Variable<int>(cantidadActual.value);
    }
    if (cantidadReservada.present) {
      map['cantidad_reservada'] = Variable<int>(cantidadReservada.value);
    }
    if (cantidadDisponible.present) {
      map['cantidad_disponible'] = Variable<int>(cantidadDisponible.value);
    }
    if (valorTotal.present) {
      map['valor_total'] = Variable<double>(valorTotal.value);
    }
    if (ubicacionFisica.present) {
      map['ubicacion_fisica'] = Variable<String>(ubicacionFisica.value);
    }
    if (ultimaActualizacion.present) {
      map['ultima_actualizacion'] = Variable<DateTime>(
        ultimaActualizacion.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (lastSync.present) {
      map['last_sync'] = Variable<DateTime>(lastSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventariosCompanion(')
          ..write('id: $id, ')
          ..write('productoId: $productoId, ')
          ..write('almacenId: $almacenId, ')
          ..write('tiendaId: $tiendaId, ')
          ..write('loteId: $loteId, ')
          ..write('cantidadActual: $cantidadActual, ')
          ..write('cantidadReservada: $cantidadReservada, ')
          ..write('cantidadDisponible: $cantidadDisponible, ')
          ..write('valorTotal: $valorTotal, ')
          ..write('ubicacionFisica: $ubicacionFisica, ')
          ..write('ultimaActualizacion: $ultimaActualizacion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('lastSync: $lastSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MovimientosTable extends Movimientos
    with TableInfo<$MovimientosTable, MovimientoTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovimientosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeroMovimientoMeta = const VerificationMeta(
    'numeroMovimiento',
  );
  @override
  late final GeneratedColumn<String> numeroMovimiento = GeneratedColumn<String>(
    'numero_movimiento',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _productoIdMeta = const VerificationMeta(
    'productoId',
  );
  @override
  late final GeneratedColumn<String> productoId = GeneratedColumn<String>(
    'producto_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES productos (id)',
    ),
  );
  static const VerificationMeta _inventarioIdMeta = const VerificationMeta(
    'inventarioId',
  );
  @override
  late final GeneratedColumn<String> inventarioId = GeneratedColumn<String>(
    'inventario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES inventarios (id)',
    ),
  );
  static const VerificationMeta _loteIdMeta = const VerificationMeta('loteId');
  @override
  late final GeneratedColumn<String> loteId = GeneratedColumn<String>(
    'lote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES lotes (id)',
    ),
  );
  static const VerificationMeta _tiendaOrigenIdMeta = const VerificationMeta(
    'tiendaOrigenId',
  );
  @override
  late final GeneratedColumn<String> tiendaOrigenId = GeneratedColumn<String>(
    'tienda_origen_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tiendas (id)',
    ),
  );
  static const VerificationMeta _tiendaDestinoIdMeta = const VerificationMeta(
    'tiendaDestinoId',
  );
  @override
  late final GeneratedColumn<String> tiendaDestinoId = GeneratedColumn<String>(
    'tienda_destino_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tiendas (id)',
    ),
  );
  static const VerificationMeta _proveedorIdMeta = const VerificationMeta(
    'proveedorId',
  );
  @override
  late final GeneratedColumn<String> proveedorId = GeneratedColumn<String>(
    'proveedor_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES proveedores (id)',
    ),
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _motivoMeta = const VerificationMeta('motivo');
  @override
  late final GeneratedColumn<String> motivo = GeneratedColumn<String>(
    'motivo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costoUnitarioMeta = const VerificationMeta(
    'costoUnitario',
  );
  @override
  late final GeneratedColumn<double> costoUnitario = GeneratedColumn<double>(
    'costo_unitario',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _costoTotalMeta = const VerificationMeta(
    'costoTotal',
  );
  @override
  late final GeneratedColumn<double> costoTotal = GeneratedColumn<double>(
    'costo_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _pesoTotalKgMeta = const VerificationMeta(
    'pesoTotalKg',
  );
  @override
  late final GeneratedColumn<double> pesoTotalKg = GeneratedColumn<double>(
    'peso_total_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES usuarios (id)',
    ),
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaMovimientoMeta = const VerificationMeta(
    'fechaMovimiento',
  );
  @override
  late final GeneratedColumn<DateTime> fechaMovimiento =
      GeneratedColumn<DateTime>(
        'fecha_movimiento',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _numeroFacturaMeta = const VerificationMeta(
    'numeroFactura',
  );
  @override
  late final GeneratedColumn<String> numeroFactura = GeneratedColumn<String>(
    'numero_factura',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _numeroGuiaRemisionMeta =
      const VerificationMeta('numeroGuiaRemision');
  @override
  late final GeneratedColumn<String> numeroGuiaRemision =
      GeneratedColumn<String>(
        'numero_guia_remision',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _vehiculoPlacaMeta = const VerificationMeta(
    'vehiculoPlaca',
  );
  @override
  late final GeneratedColumn<String> vehiculoPlaca = GeneratedColumn<String>(
    'vehiculo_placa',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _conductorMeta = const VerificationMeta(
    'conductor',
  );
  @override
  late final GeneratedColumn<String> conductor = GeneratedColumn<String>(
    'conductor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _observacionesMeta = const VerificationMeta(
    'observaciones',
  );
  @override
  late final GeneratedColumn<String> observaciones = GeneratedColumn<String>(
    'observaciones',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
    'sync_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncMeta = const VerificationMeta(
    'lastSync',
  );
  @override
  late final GeneratedColumn<DateTime> lastSync = GeneratedColumn<DateTime>(
    'last_sync',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sincronizadoMeta = const VerificationMeta(
    'sincronizado',
  );
  @override
  late final GeneratedColumn<bool> sincronizado = GeneratedColumn<bool>(
    'sincronizado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sincronizado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    numeroMovimiento,
    productoId,
    inventarioId,
    loteId,
    tiendaOrigenId,
    tiendaDestinoId,
    proveedorId,
    tipo,
    motivo,
    cantidad,
    costoUnitario,
    costoTotal,
    pesoTotalKg,
    usuarioId,
    estado,
    fechaMovimiento,
    numeroFactura,
    numeroGuiaRemision,
    vehiculoPlaca,
    conductor,
    observaciones,
    createdAt,
    updatedAt,
    syncId,
    lastSync,
    sincronizado,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movimientos';
  @override
  VerificationContext validateIntegrity(
    Insertable<MovimientoTable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('numero_movimiento')) {
      context.handle(
        _numeroMovimientoMeta,
        numeroMovimiento.isAcceptableOrUnknown(
          data['numero_movimiento']!,
          _numeroMovimientoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_numeroMovimientoMeta);
    }
    if (data.containsKey('producto_id')) {
      context.handle(
        _productoIdMeta,
        productoId.isAcceptableOrUnknown(data['producto_id']!, _productoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('inventario_id')) {
      context.handle(
        _inventarioIdMeta,
        inventarioId.isAcceptableOrUnknown(
          data['inventario_id']!,
          _inventarioIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inventarioIdMeta);
    }
    if (data.containsKey('lote_id')) {
      context.handle(
        _loteIdMeta,
        loteId.isAcceptableOrUnknown(data['lote_id']!, _loteIdMeta),
      );
    }
    if (data.containsKey('tienda_origen_id')) {
      context.handle(
        _tiendaOrigenIdMeta,
        tiendaOrigenId.isAcceptableOrUnknown(
          data['tienda_origen_id']!,
          _tiendaOrigenIdMeta,
        ),
      );
    }
    if (data.containsKey('tienda_destino_id')) {
      context.handle(
        _tiendaDestinoIdMeta,
        tiendaDestinoId.isAcceptableOrUnknown(
          data['tienda_destino_id']!,
          _tiendaDestinoIdMeta,
        ),
      );
    }
    if (data.containsKey('proveedor_id')) {
      context.handle(
        _proveedorIdMeta,
        proveedorId.isAcceptableOrUnknown(
          data['proveedor_id']!,
          _proveedorIdMeta,
        ),
      );
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('motivo')) {
      context.handle(
        _motivoMeta,
        motivo.isAcceptableOrUnknown(data['motivo']!, _motivoMeta),
      );
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('costo_unitario')) {
      context.handle(
        _costoUnitarioMeta,
        costoUnitario.isAcceptableOrUnknown(
          data['costo_unitario']!,
          _costoUnitarioMeta,
        ),
      );
    }
    if (data.containsKey('costo_total')) {
      context.handle(
        _costoTotalMeta,
        costoTotal.isAcceptableOrUnknown(data['costo_total']!, _costoTotalMeta),
      );
    }
    if (data.containsKey('peso_total_kg')) {
      context.handle(
        _pesoTotalKgMeta,
        pesoTotalKg.isAcceptableOrUnknown(
          data['peso_total_kg']!,
          _pesoTotalKgMeta,
        ),
      );
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    } else if (isInserting) {
      context.missing(_estadoMeta);
    }
    if (data.containsKey('fecha_movimiento')) {
      context.handle(
        _fechaMovimientoMeta,
        fechaMovimiento.isAcceptableOrUnknown(
          data['fecha_movimiento']!,
          _fechaMovimientoMeta,
        ),
      );
    }
    if (data.containsKey('numero_factura')) {
      context.handle(
        _numeroFacturaMeta,
        numeroFactura.isAcceptableOrUnknown(
          data['numero_factura']!,
          _numeroFacturaMeta,
        ),
      );
    }
    if (data.containsKey('numero_guia_remision')) {
      context.handle(
        _numeroGuiaRemisionMeta,
        numeroGuiaRemision.isAcceptableOrUnknown(
          data['numero_guia_remision']!,
          _numeroGuiaRemisionMeta,
        ),
      );
    }
    if (data.containsKey('vehiculo_placa')) {
      context.handle(
        _vehiculoPlacaMeta,
        vehiculoPlaca.isAcceptableOrUnknown(
          data['vehiculo_placa']!,
          _vehiculoPlacaMeta,
        ),
      );
    }
    if (data.containsKey('conductor')) {
      context.handle(
        _conductorMeta,
        conductor.isAcceptableOrUnknown(data['conductor']!, _conductorMeta),
      );
    }
    if (data.containsKey('observaciones')) {
      context.handle(
        _observacionesMeta,
        observaciones.isAcceptableOrUnknown(
          data['observaciones']!,
          _observacionesMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sync_id')) {
      context.handle(
        _syncIdMeta,
        syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta),
      );
    }
    if (data.containsKey('last_sync')) {
      context.handle(
        _lastSyncMeta,
        lastSync.isAcceptableOrUnknown(data['last_sync']!, _lastSyncMeta),
      );
    }
    if (data.containsKey('sincronizado')) {
      context.handle(
        _sincronizadoMeta,
        sincronizado.isAcceptableOrUnknown(
          data['sincronizado']!,
          _sincronizadoMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MovimientoTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MovimientoTable(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      numeroMovimiento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numero_movimiento'],
      )!,
      productoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}producto_id'],
      )!,
      inventarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inventario_id'],
      )!,
      loteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lote_id'],
      ),
      tiendaOrigenId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tienda_origen_id'],
      ),
      tiendaDestinoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tienda_destino_id'],
      ),
      proveedorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proveedor_id'],
      ),
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      motivo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motivo'],
      ),
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      costoUnitario: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}costo_unitario'],
      )!,
      costoTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}costo_total'],
      )!,
      pesoTotalKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}peso_total_kg'],
      ),
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      fechaMovimiento: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_movimiento'],
      )!,
      numeroFactura: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numero_factura'],
      ),
      numeroGuiaRemision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numero_guia_remision'],
      ),
      vehiculoPlaca: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehiculo_placa'],
      ),
      conductor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conductor'],
      ),
      observaciones: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observaciones'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_id'],
      ),
      lastSync: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync'],
      ),
      sincronizado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sincronizado'],
      )!,
    );
  }

  @override
  $MovimientosTable createAlias(String alias) {
    return $MovimientosTable(attachedDatabase, alias);
  }
}

class MovimientoTable extends DataClass implements Insertable<MovimientoTable> {
  final String id;
  final String numeroMovimiento;
  final String productoId;
  final String inventarioId;
  final String? loteId;
  final String? tiendaOrigenId;
  final String? tiendaDestinoId;
  final String? proveedorId;
  final String tipo;
  final String? motivo;
  final int cantidad;
  final double costoUnitario;
  final double costoTotal;
  final double? pesoTotalKg;
  final String usuarioId;
  final String estado;
  final DateTime fechaMovimiento;
  final String? numeroFactura;
  final String? numeroGuiaRemision;
  final String? vehiculoPlaca;
  final String? conductor;
  final String? observaciones;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? syncId;
  final DateTime? lastSync;
  final bool sincronizado;
  const MovimientoTable({
    required this.id,
    required this.numeroMovimiento,
    required this.productoId,
    required this.inventarioId,
    this.loteId,
    this.tiendaOrigenId,
    this.tiendaDestinoId,
    this.proveedorId,
    required this.tipo,
    this.motivo,
    required this.cantidad,
    required this.costoUnitario,
    required this.costoTotal,
    this.pesoTotalKg,
    required this.usuarioId,
    required this.estado,
    required this.fechaMovimiento,
    this.numeroFactura,
    this.numeroGuiaRemision,
    this.vehiculoPlaca,
    this.conductor,
    this.observaciones,
    required this.createdAt,
    required this.updatedAt,
    this.syncId,
    this.lastSync,
    required this.sincronizado,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['numero_movimiento'] = Variable<String>(numeroMovimiento);
    map['producto_id'] = Variable<String>(productoId);
    map['inventario_id'] = Variable<String>(inventarioId);
    if (!nullToAbsent || loteId != null) {
      map['lote_id'] = Variable<String>(loteId);
    }
    if (!nullToAbsent || tiendaOrigenId != null) {
      map['tienda_origen_id'] = Variable<String>(tiendaOrigenId);
    }
    if (!nullToAbsent || tiendaDestinoId != null) {
      map['tienda_destino_id'] = Variable<String>(tiendaDestinoId);
    }
    if (!nullToAbsent || proveedorId != null) {
      map['proveedor_id'] = Variable<String>(proveedorId);
    }
    map['tipo'] = Variable<String>(tipo);
    if (!nullToAbsent || motivo != null) {
      map['motivo'] = Variable<String>(motivo);
    }
    map['cantidad'] = Variable<int>(cantidad);
    map['costo_unitario'] = Variable<double>(costoUnitario);
    map['costo_total'] = Variable<double>(costoTotal);
    if (!nullToAbsent || pesoTotalKg != null) {
      map['peso_total_kg'] = Variable<double>(pesoTotalKg);
    }
    map['usuario_id'] = Variable<String>(usuarioId);
    map['estado'] = Variable<String>(estado);
    map['fecha_movimiento'] = Variable<DateTime>(fechaMovimiento);
    if (!nullToAbsent || numeroFactura != null) {
      map['numero_factura'] = Variable<String>(numeroFactura);
    }
    if (!nullToAbsent || numeroGuiaRemision != null) {
      map['numero_guia_remision'] = Variable<String>(numeroGuiaRemision);
    }
    if (!nullToAbsent || vehiculoPlaca != null) {
      map['vehiculo_placa'] = Variable<String>(vehiculoPlaca);
    }
    if (!nullToAbsent || conductor != null) {
      map['conductor'] = Variable<String>(conductor);
    }
    if (!nullToAbsent || observaciones != null) {
      map['observaciones'] = Variable<String>(observaciones);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncId != null) {
      map['sync_id'] = Variable<String>(syncId);
    }
    if (!nullToAbsent || lastSync != null) {
      map['last_sync'] = Variable<DateTime>(lastSync);
    }
    map['sincronizado'] = Variable<bool>(sincronizado);
    return map;
  }

  MovimientosCompanion toCompanion(bool nullToAbsent) {
    return MovimientosCompanion(
      id: Value(id),
      numeroMovimiento: Value(numeroMovimiento),
      productoId: Value(productoId),
      inventarioId: Value(inventarioId),
      loteId: loteId == null && nullToAbsent
          ? const Value.absent()
          : Value(loteId),
      tiendaOrigenId: tiendaOrigenId == null && nullToAbsent
          ? const Value.absent()
          : Value(tiendaOrigenId),
      tiendaDestinoId: tiendaDestinoId == null && nullToAbsent
          ? const Value.absent()
          : Value(tiendaDestinoId),
      proveedorId: proveedorId == null && nullToAbsent
          ? const Value.absent()
          : Value(proveedorId),
      tipo: Value(tipo),
      motivo: motivo == null && nullToAbsent
          ? const Value.absent()
          : Value(motivo),
      cantidad: Value(cantidad),
      costoUnitario: Value(costoUnitario),
      costoTotal: Value(costoTotal),
      pesoTotalKg: pesoTotalKg == null && nullToAbsent
          ? const Value.absent()
          : Value(pesoTotalKg),
      usuarioId: Value(usuarioId),
      estado: Value(estado),
      fechaMovimiento: Value(fechaMovimiento),
      numeroFactura: numeroFactura == null && nullToAbsent
          ? const Value.absent()
          : Value(numeroFactura),
      numeroGuiaRemision: numeroGuiaRemision == null && nullToAbsent
          ? const Value.absent()
          : Value(numeroGuiaRemision),
      vehiculoPlaca: vehiculoPlaca == null && nullToAbsent
          ? const Value.absent()
          : Value(vehiculoPlaca),
      conductor: conductor == null && nullToAbsent
          ? const Value.absent()
          : Value(conductor),
      observaciones: observaciones == null && nullToAbsent
          ? const Value.absent()
          : Value(observaciones),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncId: syncId == null && nullToAbsent
          ? const Value.absent()
          : Value(syncId),
      lastSync: lastSync == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSync),
      sincronizado: Value(sincronizado),
    );
  }

  factory MovimientoTable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MovimientoTable(
      id: serializer.fromJson<String>(json['id']),
      numeroMovimiento: serializer.fromJson<String>(json['numeroMovimiento']),
      productoId: serializer.fromJson<String>(json['productoId']),
      inventarioId: serializer.fromJson<String>(json['inventarioId']),
      loteId: serializer.fromJson<String?>(json['loteId']),
      tiendaOrigenId: serializer.fromJson<String?>(json['tiendaOrigenId']),
      tiendaDestinoId: serializer.fromJson<String?>(json['tiendaDestinoId']),
      proveedorId: serializer.fromJson<String?>(json['proveedorId']),
      tipo: serializer.fromJson<String>(json['tipo']),
      motivo: serializer.fromJson<String?>(json['motivo']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      costoUnitario: serializer.fromJson<double>(json['costoUnitario']),
      costoTotal: serializer.fromJson<double>(json['costoTotal']),
      pesoTotalKg: serializer.fromJson<double?>(json['pesoTotalKg']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      estado: serializer.fromJson<String>(json['estado']),
      fechaMovimiento: serializer.fromJson<DateTime>(json['fechaMovimiento']),
      numeroFactura: serializer.fromJson<String?>(json['numeroFactura']),
      numeroGuiaRemision: serializer.fromJson<String?>(
        json['numeroGuiaRemision'],
      ),
      vehiculoPlaca: serializer.fromJson<String?>(json['vehiculoPlaca']),
      conductor: serializer.fromJson<String?>(json['conductor']),
      observaciones: serializer.fromJson<String?>(json['observaciones']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncId: serializer.fromJson<String?>(json['syncId']),
      lastSync: serializer.fromJson<DateTime?>(json['lastSync']),
      sincronizado: serializer.fromJson<bool>(json['sincronizado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'numeroMovimiento': serializer.toJson<String>(numeroMovimiento),
      'productoId': serializer.toJson<String>(productoId),
      'inventarioId': serializer.toJson<String>(inventarioId),
      'loteId': serializer.toJson<String?>(loteId),
      'tiendaOrigenId': serializer.toJson<String?>(tiendaOrigenId),
      'tiendaDestinoId': serializer.toJson<String?>(tiendaDestinoId),
      'proveedorId': serializer.toJson<String?>(proveedorId),
      'tipo': serializer.toJson<String>(tipo),
      'motivo': serializer.toJson<String?>(motivo),
      'cantidad': serializer.toJson<int>(cantidad),
      'costoUnitario': serializer.toJson<double>(costoUnitario),
      'costoTotal': serializer.toJson<double>(costoTotal),
      'pesoTotalKg': serializer.toJson<double?>(pesoTotalKg),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'estado': serializer.toJson<String>(estado),
      'fechaMovimiento': serializer.toJson<DateTime>(fechaMovimiento),
      'numeroFactura': serializer.toJson<String?>(numeroFactura),
      'numeroGuiaRemision': serializer.toJson<String?>(numeroGuiaRemision),
      'vehiculoPlaca': serializer.toJson<String?>(vehiculoPlaca),
      'conductor': serializer.toJson<String?>(conductor),
      'observaciones': serializer.toJson<String?>(observaciones),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncId': serializer.toJson<String?>(syncId),
      'lastSync': serializer.toJson<DateTime?>(lastSync),
      'sincronizado': serializer.toJson<bool>(sincronizado),
    };
  }

  MovimientoTable copyWith({
    String? id,
    String? numeroMovimiento,
    String? productoId,
    String? inventarioId,
    Value<String?> loteId = const Value.absent(),
    Value<String?> tiendaOrigenId = const Value.absent(),
    Value<String?> tiendaDestinoId = const Value.absent(),
    Value<String?> proveedorId = const Value.absent(),
    String? tipo,
    Value<String?> motivo = const Value.absent(),
    int? cantidad,
    double? costoUnitario,
    double? costoTotal,
    Value<double?> pesoTotalKg = const Value.absent(),
    String? usuarioId,
    String? estado,
    DateTime? fechaMovimiento,
    Value<String?> numeroFactura = const Value.absent(),
    Value<String?> numeroGuiaRemision = const Value.absent(),
    Value<String?> vehiculoPlaca = const Value.absent(),
    Value<String?> conductor = const Value.absent(),
    Value<String?> observaciones = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<String?> syncId = const Value.absent(),
    Value<DateTime?> lastSync = const Value.absent(),
    bool? sincronizado,
  }) => MovimientoTable(
    id: id ?? this.id,
    numeroMovimiento: numeroMovimiento ?? this.numeroMovimiento,
    productoId: productoId ?? this.productoId,
    inventarioId: inventarioId ?? this.inventarioId,
    loteId: loteId.present ? loteId.value : this.loteId,
    tiendaOrigenId: tiendaOrigenId.present
        ? tiendaOrigenId.value
        : this.tiendaOrigenId,
    tiendaDestinoId: tiendaDestinoId.present
        ? tiendaDestinoId.value
        : this.tiendaDestinoId,
    proveedorId: proveedorId.present ? proveedorId.value : this.proveedorId,
    tipo: tipo ?? this.tipo,
    motivo: motivo.present ? motivo.value : this.motivo,
    cantidad: cantidad ?? this.cantidad,
    costoUnitario: costoUnitario ?? this.costoUnitario,
    costoTotal: costoTotal ?? this.costoTotal,
    pesoTotalKg: pesoTotalKg.present ? pesoTotalKg.value : this.pesoTotalKg,
    usuarioId: usuarioId ?? this.usuarioId,
    estado: estado ?? this.estado,
    fechaMovimiento: fechaMovimiento ?? this.fechaMovimiento,
    numeroFactura: numeroFactura.present
        ? numeroFactura.value
        : this.numeroFactura,
    numeroGuiaRemision: numeroGuiaRemision.present
        ? numeroGuiaRemision.value
        : this.numeroGuiaRemision,
    vehiculoPlaca: vehiculoPlaca.present
        ? vehiculoPlaca.value
        : this.vehiculoPlaca,
    conductor: conductor.present ? conductor.value : this.conductor,
    observaciones: observaciones.present
        ? observaciones.value
        : this.observaciones,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncId: syncId.present ? syncId.value : this.syncId,
    lastSync: lastSync.present ? lastSync.value : this.lastSync,
    sincronizado: sincronizado ?? this.sincronizado,
  );
  MovimientoTable copyWithCompanion(MovimientosCompanion data) {
    return MovimientoTable(
      id: data.id.present ? data.id.value : this.id,
      numeroMovimiento: data.numeroMovimiento.present
          ? data.numeroMovimiento.value
          : this.numeroMovimiento,
      productoId: data.productoId.present
          ? data.productoId.value
          : this.productoId,
      inventarioId: data.inventarioId.present
          ? data.inventarioId.value
          : this.inventarioId,
      loteId: data.loteId.present ? data.loteId.value : this.loteId,
      tiendaOrigenId: data.tiendaOrigenId.present
          ? data.tiendaOrigenId.value
          : this.tiendaOrigenId,
      tiendaDestinoId: data.tiendaDestinoId.present
          ? data.tiendaDestinoId.value
          : this.tiendaDestinoId,
      proveedorId: data.proveedorId.present
          ? data.proveedorId.value
          : this.proveedorId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      motivo: data.motivo.present ? data.motivo.value : this.motivo,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      costoUnitario: data.costoUnitario.present
          ? data.costoUnitario.value
          : this.costoUnitario,
      costoTotal: data.costoTotal.present
          ? data.costoTotal.value
          : this.costoTotal,
      pesoTotalKg: data.pesoTotalKg.present
          ? data.pesoTotalKg.value
          : this.pesoTotalKg,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      estado: data.estado.present ? data.estado.value : this.estado,
      fechaMovimiento: data.fechaMovimiento.present
          ? data.fechaMovimiento.value
          : this.fechaMovimiento,
      numeroFactura: data.numeroFactura.present
          ? data.numeroFactura.value
          : this.numeroFactura,
      numeroGuiaRemision: data.numeroGuiaRemision.present
          ? data.numeroGuiaRemision.value
          : this.numeroGuiaRemision,
      vehiculoPlaca: data.vehiculoPlaca.present
          ? data.vehiculoPlaca.value
          : this.vehiculoPlaca,
      conductor: data.conductor.present ? data.conductor.value : this.conductor,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      lastSync: data.lastSync.present ? data.lastSync.value : this.lastSync,
      sincronizado: data.sincronizado.present
          ? data.sincronizado.value
          : this.sincronizado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MovimientoTable(')
          ..write('id: $id, ')
          ..write('numeroMovimiento: $numeroMovimiento, ')
          ..write('productoId: $productoId, ')
          ..write('inventarioId: $inventarioId, ')
          ..write('loteId: $loteId, ')
          ..write('tiendaOrigenId: $tiendaOrigenId, ')
          ..write('tiendaDestinoId: $tiendaDestinoId, ')
          ..write('proveedorId: $proveedorId, ')
          ..write('tipo: $tipo, ')
          ..write('motivo: $motivo, ')
          ..write('cantidad: $cantidad, ')
          ..write('costoUnitario: $costoUnitario, ')
          ..write('costoTotal: $costoTotal, ')
          ..write('pesoTotalKg: $pesoTotalKg, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('estado: $estado, ')
          ..write('fechaMovimiento: $fechaMovimiento, ')
          ..write('numeroFactura: $numeroFactura, ')
          ..write('numeroGuiaRemision: $numeroGuiaRemision, ')
          ..write('vehiculoPlaca: $vehiculoPlaca, ')
          ..write('conductor: $conductor, ')
          ..write('observaciones: $observaciones, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('lastSync: $lastSync, ')
          ..write('sincronizado: $sincronizado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    numeroMovimiento,
    productoId,
    inventarioId,
    loteId,
    tiendaOrigenId,
    tiendaDestinoId,
    proveedorId,
    tipo,
    motivo,
    cantidad,
    costoUnitario,
    costoTotal,
    pesoTotalKg,
    usuarioId,
    estado,
    fechaMovimiento,
    numeroFactura,
    numeroGuiaRemision,
    vehiculoPlaca,
    conductor,
    observaciones,
    createdAt,
    updatedAt,
    syncId,
    lastSync,
    sincronizado,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovimientoTable &&
          other.id == this.id &&
          other.numeroMovimiento == this.numeroMovimiento &&
          other.productoId == this.productoId &&
          other.inventarioId == this.inventarioId &&
          other.loteId == this.loteId &&
          other.tiendaOrigenId == this.tiendaOrigenId &&
          other.tiendaDestinoId == this.tiendaDestinoId &&
          other.proveedorId == this.proveedorId &&
          other.tipo == this.tipo &&
          other.motivo == this.motivo &&
          other.cantidad == this.cantidad &&
          other.costoUnitario == this.costoUnitario &&
          other.costoTotal == this.costoTotal &&
          other.pesoTotalKg == this.pesoTotalKg &&
          other.usuarioId == this.usuarioId &&
          other.estado == this.estado &&
          other.fechaMovimiento == this.fechaMovimiento &&
          other.numeroFactura == this.numeroFactura &&
          other.numeroGuiaRemision == this.numeroGuiaRemision &&
          other.vehiculoPlaca == this.vehiculoPlaca &&
          other.conductor == this.conductor &&
          other.observaciones == this.observaciones &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncId == this.syncId &&
          other.lastSync == this.lastSync &&
          other.sincronizado == this.sincronizado);
}

class MovimientosCompanion extends UpdateCompanion<MovimientoTable> {
  final Value<String> id;
  final Value<String> numeroMovimiento;
  final Value<String> productoId;
  final Value<String> inventarioId;
  final Value<String?> loteId;
  final Value<String?> tiendaOrigenId;
  final Value<String?> tiendaDestinoId;
  final Value<String?> proveedorId;
  final Value<String> tipo;
  final Value<String?> motivo;
  final Value<int> cantidad;
  final Value<double> costoUnitario;
  final Value<double> costoTotal;
  final Value<double?> pesoTotalKg;
  final Value<String> usuarioId;
  final Value<String> estado;
  final Value<DateTime> fechaMovimiento;
  final Value<String?> numeroFactura;
  final Value<String?> numeroGuiaRemision;
  final Value<String?> vehiculoPlaca;
  final Value<String?> conductor;
  final Value<String?> observaciones;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> syncId;
  final Value<DateTime?> lastSync;
  final Value<bool> sincronizado;
  final Value<int> rowid;
  const MovimientosCompanion({
    this.id = const Value.absent(),
    this.numeroMovimiento = const Value.absent(),
    this.productoId = const Value.absent(),
    this.inventarioId = const Value.absent(),
    this.loteId = const Value.absent(),
    this.tiendaOrigenId = const Value.absent(),
    this.tiendaDestinoId = const Value.absent(),
    this.proveedorId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.motivo = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.costoUnitario = const Value.absent(),
    this.costoTotal = const Value.absent(),
    this.pesoTotalKg = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.estado = const Value.absent(),
    this.fechaMovimiento = const Value.absent(),
    this.numeroFactura = const Value.absent(),
    this.numeroGuiaRemision = const Value.absent(),
    this.vehiculoPlaca = const Value.absent(),
    this.conductor = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.sincronizado = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MovimientosCompanion.insert({
    required String id,
    required String numeroMovimiento,
    required String productoId,
    required String inventarioId,
    this.loteId = const Value.absent(),
    this.tiendaOrigenId = const Value.absent(),
    this.tiendaDestinoId = const Value.absent(),
    this.proveedorId = const Value.absent(),
    required String tipo,
    this.motivo = const Value.absent(),
    required int cantidad,
    this.costoUnitario = const Value.absent(),
    this.costoTotal = const Value.absent(),
    this.pesoTotalKg = const Value.absent(),
    required String usuarioId,
    required String estado,
    this.fechaMovimiento = const Value.absent(),
    this.numeroFactura = const Value.absent(),
    this.numeroGuiaRemision = const Value.absent(),
    this.vehiculoPlaca = const Value.absent(),
    this.conductor = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.sincronizado = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       numeroMovimiento = Value(numeroMovimiento),
       productoId = Value(productoId),
       inventarioId = Value(inventarioId),
       tipo = Value(tipo),
       cantidad = Value(cantidad),
       usuarioId = Value(usuarioId),
       estado = Value(estado);
  static Insertable<MovimientoTable> custom({
    Expression<String>? id,
    Expression<String>? numeroMovimiento,
    Expression<String>? productoId,
    Expression<String>? inventarioId,
    Expression<String>? loteId,
    Expression<String>? tiendaOrigenId,
    Expression<String>? tiendaDestinoId,
    Expression<String>? proveedorId,
    Expression<String>? tipo,
    Expression<String>? motivo,
    Expression<int>? cantidad,
    Expression<double>? costoUnitario,
    Expression<double>? costoTotal,
    Expression<double>? pesoTotalKg,
    Expression<String>? usuarioId,
    Expression<String>? estado,
    Expression<DateTime>? fechaMovimiento,
    Expression<String>? numeroFactura,
    Expression<String>? numeroGuiaRemision,
    Expression<String>? vehiculoPlaca,
    Expression<String>? conductor,
    Expression<String>? observaciones,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncId,
    Expression<DateTime>? lastSync,
    Expression<bool>? sincronizado,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (numeroMovimiento != null) 'numero_movimiento': numeroMovimiento,
      if (productoId != null) 'producto_id': productoId,
      if (inventarioId != null) 'inventario_id': inventarioId,
      if (loteId != null) 'lote_id': loteId,
      if (tiendaOrigenId != null) 'tienda_origen_id': tiendaOrigenId,
      if (tiendaDestinoId != null) 'tienda_destino_id': tiendaDestinoId,
      if (proveedorId != null) 'proveedor_id': proveedorId,
      if (tipo != null) 'tipo': tipo,
      if (motivo != null) 'motivo': motivo,
      if (cantidad != null) 'cantidad': cantidad,
      if (costoUnitario != null) 'costo_unitario': costoUnitario,
      if (costoTotal != null) 'costo_total': costoTotal,
      if (pesoTotalKg != null) 'peso_total_kg': pesoTotalKg,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (estado != null) 'estado': estado,
      if (fechaMovimiento != null) 'fecha_movimiento': fechaMovimiento,
      if (numeroFactura != null) 'numero_factura': numeroFactura,
      if (numeroGuiaRemision != null)
        'numero_guia_remision': numeroGuiaRemision,
      if (vehiculoPlaca != null) 'vehiculo_placa': vehiculoPlaca,
      if (conductor != null) 'conductor': conductor,
      if (observaciones != null) 'observaciones': observaciones,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncId != null) 'sync_id': syncId,
      if (lastSync != null) 'last_sync': lastSync,
      if (sincronizado != null) 'sincronizado': sincronizado,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MovimientosCompanion copyWith({
    Value<String>? id,
    Value<String>? numeroMovimiento,
    Value<String>? productoId,
    Value<String>? inventarioId,
    Value<String?>? loteId,
    Value<String?>? tiendaOrigenId,
    Value<String?>? tiendaDestinoId,
    Value<String?>? proveedorId,
    Value<String>? tipo,
    Value<String?>? motivo,
    Value<int>? cantidad,
    Value<double>? costoUnitario,
    Value<double>? costoTotal,
    Value<double?>? pesoTotalKg,
    Value<String>? usuarioId,
    Value<String>? estado,
    Value<DateTime>? fechaMovimiento,
    Value<String?>? numeroFactura,
    Value<String?>? numeroGuiaRemision,
    Value<String?>? vehiculoPlaca,
    Value<String?>? conductor,
    Value<String?>? observaciones,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? syncId,
    Value<DateTime?>? lastSync,
    Value<bool>? sincronizado,
    Value<int>? rowid,
  }) {
    return MovimientosCompanion(
      id: id ?? this.id,
      numeroMovimiento: numeroMovimiento ?? this.numeroMovimiento,
      productoId: productoId ?? this.productoId,
      inventarioId: inventarioId ?? this.inventarioId,
      loteId: loteId ?? this.loteId,
      tiendaOrigenId: tiendaOrigenId ?? this.tiendaOrigenId,
      tiendaDestinoId: tiendaDestinoId ?? this.tiendaDestinoId,
      proveedorId: proveedorId ?? this.proveedorId,
      tipo: tipo ?? this.tipo,
      motivo: motivo ?? this.motivo,
      cantidad: cantidad ?? this.cantidad,
      costoUnitario: costoUnitario ?? this.costoUnitario,
      costoTotal: costoTotal ?? this.costoTotal,
      pesoTotalKg: pesoTotalKg ?? this.pesoTotalKg,
      usuarioId: usuarioId ?? this.usuarioId,
      estado: estado ?? this.estado,
      fechaMovimiento: fechaMovimiento ?? this.fechaMovimiento,
      numeroFactura: numeroFactura ?? this.numeroFactura,
      numeroGuiaRemision: numeroGuiaRemision ?? this.numeroGuiaRemision,
      vehiculoPlaca: vehiculoPlaca ?? this.vehiculoPlaca,
      conductor: conductor ?? this.conductor,
      observaciones: observaciones ?? this.observaciones,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncId: syncId ?? this.syncId,
      lastSync: lastSync ?? this.lastSync,
      sincronizado: sincronizado ?? this.sincronizado,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (numeroMovimiento.present) {
      map['numero_movimiento'] = Variable<String>(numeroMovimiento.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<String>(productoId.value);
    }
    if (inventarioId.present) {
      map['inventario_id'] = Variable<String>(inventarioId.value);
    }
    if (loteId.present) {
      map['lote_id'] = Variable<String>(loteId.value);
    }
    if (tiendaOrigenId.present) {
      map['tienda_origen_id'] = Variable<String>(tiendaOrigenId.value);
    }
    if (tiendaDestinoId.present) {
      map['tienda_destino_id'] = Variable<String>(tiendaDestinoId.value);
    }
    if (proveedorId.present) {
      map['proveedor_id'] = Variable<String>(proveedorId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (motivo.present) {
      map['motivo'] = Variable<String>(motivo.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (costoUnitario.present) {
      map['costo_unitario'] = Variable<double>(costoUnitario.value);
    }
    if (costoTotal.present) {
      map['costo_total'] = Variable<double>(costoTotal.value);
    }
    if (pesoTotalKg.present) {
      map['peso_total_kg'] = Variable<double>(pesoTotalKg.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (fechaMovimiento.present) {
      map['fecha_movimiento'] = Variable<DateTime>(fechaMovimiento.value);
    }
    if (numeroFactura.present) {
      map['numero_factura'] = Variable<String>(numeroFactura.value);
    }
    if (numeroGuiaRemision.present) {
      map['numero_guia_remision'] = Variable<String>(numeroGuiaRemision.value);
    }
    if (vehiculoPlaca.present) {
      map['vehiculo_placa'] = Variable<String>(vehiculoPlaca.value);
    }
    if (conductor.present) {
      map['conductor'] = Variable<String>(conductor.value);
    }
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (lastSync.present) {
      map['last_sync'] = Variable<DateTime>(lastSync.value);
    }
    if (sincronizado.present) {
      map['sincronizado'] = Variable<bool>(sincronizado.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovimientosCompanion(')
          ..write('id: $id, ')
          ..write('numeroMovimiento: $numeroMovimiento, ')
          ..write('productoId: $productoId, ')
          ..write('inventarioId: $inventarioId, ')
          ..write('loteId: $loteId, ')
          ..write('tiendaOrigenId: $tiendaOrigenId, ')
          ..write('tiendaDestinoId: $tiendaDestinoId, ')
          ..write('proveedorId: $proveedorId, ')
          ..write('tipo: $tipo, ')
          ..write('motivo: $motivo, ')
          ..write('cantidad: $cantidad, ')
          ..write('costoUnitario: $costoUnitario, ')
          ..write('costoTotal: $costoTotal, ')
          ..write('pesoTotalKg: $pesoTotalKg, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('estado: $estado, ')
          ..write('fechaMovimiento: $fechaMovimiento, ')
          ..write('numeroFactura: $numeroFactura, ')
          ..write('numeroGuiaRemision: $numeroGuiaRemision, ')
          ..write('vehiculoPlaca: $vehiculoPlaca, ')
          ..write('conductor: $conductor, ')
          ..write('observaciones: $observaciones, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('lastSync: $lastSync, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditoriasTable extends Auditorias
    with TableInfo<$AuditoriasTable, AuditoriaTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditoriasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES usuarios (id)',
    ),
  );
  static const VerificationMeta _tablaAfectadaMeta = const VerificationMeta(
    'tablaAfectada',
  );
  @override
  late final GeneratedColumn<String> tablaAfectada = GeneratedColumn<String>(
    'tabla_afectada',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accionMeta = const VerificationMeta('accion');
  @override
  late final GeneratedColumn<String> accion = GeneratedColumn<String>(
    'accion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datosAnterioresMeta = const VerificationMeta(
    'datosAnteriores',
  );
  @override
  late final GeneratedColumn<String> datosAnteriores = GeneratedColumn<String>(
    'datos_anteriores',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _datosNuevosMeta = const VerificationMeta(
    'datosNuevos',
  );
  @override
  late final GeneratedColumn<String> datosNuevos = GeneratedColumn<String>(
    'datos_nuevos',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ipAddressMeta = const VerificationMeta(
    'ipAddress',
  );
  @override
  late final GeneratedColumn<String> ipAddress = GeneratedColumn<String>(
    'ip_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dispositivoMeta = const VerificationMeta(
    'dispositivo',
  );
  @override
  late final GeneratedColumn<String> dispositivo = GeneratedColumn<String>(
    'dispositivo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    usuarioId,
    tablaAfectada,
    accion,
    datosAnteriores,
    datosNuevos,
    ipAddress,
    dispositivo,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auditorias';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditoriaTable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('tabla_afectada')) {
      context.handle(
        _tablaAfectadaMeta,
        tablaAfectada.isAcceptableOrUnknown(
          data['tabla_afectada']!,
          _tablaAfectadaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tablaAfectadaMeta);
    }
    if (data.containsKey('accion')) {
      context.handle(
        _accionMeta,
        accion.isAcceptableOrUnknown(data['accion']!, _accionMeta),
      );
    } else if (isInserting) {
      context.missing(_accionMeta);
    }
    if (data.containsKey('datos_anteriores')) {
      context.handle(
        _datosAnterioresMeta,
        datosAnteriores.isAcceptableOrUnknown(
          data['datos_anteriores']!,
          _datosAnterioresMeta,
        ),
      );
    }
    if (data.containsKey('datos_nuevos')) {
      context.handle(
        _datosNuevosMeta,
        datosNuevos.isAcceptableOrUnknown(
          data['datos_nuevos']!,
          _datosNuevosMeta,
        ),
      );
    }
    if (data.containsKey('ip_address')) {
      context.handle(
        _ipAddressMeta,
        ipAddress.isAcceptableOrUnknown(data['ip_address']!, _ipAddressMeta),
      );
    }
    if (data.containsKey('dispositivo')) {
      context.handle(
        _dispositivoMeta,
        dispositivo.isAcceptableOrUnknown(
          data['dispositivo']!,
          _dispositivoMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditoriaTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditoriaTable(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      )!,
      tablaAfectada: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tabla_afectada'],
      )!,
      accion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}accion'],
      )!,
      datosAnteriores: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}datos_anteriores'],
      ),
      datosNuevos: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}datos_nuevos'],
      ),
      ipAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ip_address'],
      ),
      dispositivo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dispositivo'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AuditoriasTable createAlias(String alias) {
    return $AuditoriasTable(attachedDatabase, alias);
  }
}

class AuditoriaTable extends DataClass implements Insertable<AuditoriaTable> {
  final String id;
  final String usuarioId;
  final String tablaAfectada;
  final String accion;
  final String? datosAnteriores;
  final String? datosNuevos;
  final String? ipAddress;
  final String? dispositivo;
  final DateTime createdAt;
  const AuditoriaTable({
    required this.id,
    required this.usuarioId,
    required this.tablaAfectada,
    required this.accion,
    this.datosAnteriores,
    this.datosNuevos,
    this.ipAddress,
    this.dispositivo,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['tabla_afectada'] = Variable<String>(tablaAfectada);
    map['accion'] = Variable<String>(accion);
    if (!nullToAbsent || datosAnteriores != null) {
      map['datos_anteriores'] = Variable<String>(datosAnteriores);
    }
    if (!nullToAbsent || datosNuevos != null) {
      map['datos_nuevos'] = Variable<String>(datosNuevos);
    }
    if (!nullToAbsent || ipAddress != null) {
      map['ip_address'] = Variable<String>(ipAddress);
    }
    if (!nullToAbsent || dispositivo != null) {
      map['dispositivo'] = Variable<String>(dispositivo);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AuditoriasCompanion toCompanion(bool nullToAbsent) {
    return AuditoriasCompanion(
      id: Value(id),
      usuarioId: Value(usuarioId),
      tablaAfectada: Value(tablaAfectada),
      accion: Value(accion),
      datosAnteriores: datosAnteriores == null && nullToAbsent
          ? const Value.absent()
          : Value(datosAnteriores),
      datosNuevos: datosNuevos == null && nullToAbsent
          ? const Value.absent()
          : Value(datosNuevos),
      ipAddress: ipAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(ipAddress),
      dispositivo: dispositivo == null && nullToAbsent
          ? const Value.absent()
          : Value(dispositivo),
      createdAt: Value(createdAt),
    );
  }

  factory AuditoriaTable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditoriaTable(
      id: serializer.fromJson<String>(json['id']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      tablaAfectada: serializer.fromJson<String>(json['tablaAfectada']),
      accion: serializer.fromJson<String>(json['accion']),
      datosAnteriores: serializer.fromJson<String?>(json['datosAnteriores']),
      datosNuevos: serializer.fromJson<String?>(json['datosNuevos']),
      ipAddress: serializer.fromJson<String?>(json['ipAddress']),
      dispositivo: serializer.fromJson<String?>(json['dispositivo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'tablaAfectada': serializer.toJson<String>(tablaAfectada),
      'accion': serializer.toJson<String>(accion),
      'datosAnteriores': serializer.toJson<String?>(datosAnteriores),
      'datosNuevos': serializer.toJson<String?>(datosNuevos),
      'ipAddress': serializer.toJson<String?>(ipAddress),
      'dispositivo': serializer.toJson<String?>(dispositivo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AuditoriaTable copyWith({
    String? id,
    String? usuarioId,
    String? tablaAfectada,
    String? accion,
    Value<String?> datosAnteriores = const Value.absent(),
    Value<String?> datosNuevos = const Value.absent(),
    Value<String?> ipAddress = const Value.absent(),
    Value<String?> dispositivo = const Value.absent(),
    DateTime? createdAt,
  }) => AuditoriaTable(
    id: id ?? this.id,
    usuarioId: usuarioId ?? this.usuarioId,
    tablaAfectada: tablaAfectada ?? this.tablaAfectada,
    accion: accion ?? this.accion,
    datosAnteriores: datosAnteriores.present
        ? datosAnteriores.value
        : this.datosAnteriores,
    datosNuevos: datosNuevos.present ? datosNuevos.value : this.datosNuevos,
    ipAddress: ipAddress.present ? ipAddress.value : this.ipAddress,
    dispositivo: dispositivo.present ? dispositivo.value : this.dispositivo,
    createdAt: createdAt ?? this.createdAt,
  );
  AuditoriaTable copyWithCompanion(AuditoriasCompanion data) {
    return AuditoriaTable(
      id: data.id.present ? data.id.value : this.id,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      tablaAfectada: data.tablaAfectada.present
          ? data.tablaAfectada.value
          : this.tablaAfectada,
      accion: data.accion.present ? data.accion.value : this.accion,
      datosAnteriores: data.datosAnteriores.present
          ? data.datosAnteriores.value
          : this.datosAnteriores,
      datosNuevos: data.datosNuevos.present
          ? data.datosNuevos.value
          : this.datosNuevos,
      ipAddress: data.ipAddress.present ? data.ipAddress.value : this.ipAddress,
      dispositivo: data.dispositivo.present
          ? data.dispositivo.value
          : this.dispositivo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditoriaTable(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('tablaAfectada: $tablaAfectada, ')
          ..write('accion: $accion, ')
          ..write('datosAnteriores: $datosAnteriores, ')
          ..write('datosNuevos: $datosNuevos, ')
          ..write('ipAddress: $ipAddress, ')
          ..write('dispositivo: $dispositivo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    usuarioId,
    tablaAfectada,
    accion,
    datosAnteriores,
    datosNuevos,
    ipAddress,
    dispositivo,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditoriaTable &&
          other.id == this.id &&
          other.usuarioId == this.usuarioId &&
          other.tablaAfectada == this.tablaAfectada &&
          other.accion == this.accion &&
          other.datosAnteriores == this.datosAnteriores &&
          other.datosNuevos == this.datosNuevos &&
          other.ipAddress == this.ipAddress &&
          other.dispositivo == this.dispositivo &&
          other.createdAt == this.createdAt);
}

class AuditoriasCompanion extends UpdateCompanion<AuditoriaTable> {
  final Value<String> id;
  final Value<String> usuarioId;
  final Value<String> tablaAfectada;
  final Value<String> accion;
  final Value<String?> datosAnteriores;
  final Value<String?> datosNuevos;
  final Value<String?> ipAddress;
  final Value<String?> dispositivo;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AuditoriasCompanion({
    this.id = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.tablaAfectada = const Value.absent(),
    this.accion = const Value.absent(),
    this.datosAnteriores = const Value.absent(),
    this.datosNuevos = const Value.absent(),
    this.ipAddress = const Value.absent(),
    this.dispositivo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditoriasCompanion.insert({
    required String id,
    required String usuarioId,
    required String tablaAfectada,
    required String accion,
    this.datosAnteriores = const Value.absent(),
    this.datosNuevos = const Value.absent(),
    this.ipAddress = const Value.absent(),
    this.dispositivo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       usuarioId = Value(usuarioId),
       tablaAfectada = Value(tablaAfectada),
       accion = Value(accion);
  static Insertable<AuditoriaTable> custom({
    Expression<String>? id,
    Expression<String>? usuarioId,
    Expression<String>? tablaAfectada,
    Expression<String>? accion,
    Expression<String>? datosAnteriores,
    Expression<String>? datosNuevos,
    Expression<String>? ipAddress,
    Expression<String>? dispositivo,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (tablaAfectada != null) 'tabla_afectada': tablaAfectada,
      if (accion != null) 'accion': accion,
      if (datosAnteriores != null) 'datos_anteriores': datosAnteriores,
      if (datosNuevos != null) 'datos_nuevos': datosNuevos,
      if (ipAddress != null) 'ip_address': ipAddress,
      if (dispositivo != null) 'dispositivo': dispositivo,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditoriasCompanion copyWith({
    Value<String>? id,
    Value<String>? usuarioId,
    Value<String>? tablaAfectada,
    Value<String>? accion,
    Value<String?>? datosAnteriores,
    Value<String?>? datosNuevos,
    Value<String?>? ipAddress,
    Value<String?>? dispositivo,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AuditoriasCompanion(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      tablaAfectada: tablaAfectada ?? this.tablaAfectada,
      accion: accion ?? this.accion,
      datosAnteriores: datosAnteriores ?? this.datosAnteriores,
      datosNuevos: datosNuevos ?? this.datosNuevos,
      ipAddress: ipAddress ?? this.ipAddress,
      dispositivo: dispositivo ?? this.dispositivo,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (tablaAfectada.present) {
      map['tabla_afectada'] = Variable<String>(tablaAfectada.value);
    }
    if (accion.present) {
      map['accion'] = Variable<String>(accion.value);
    }
    if (datosAnteriores.present) {
      map['datos_anteriores'] = Variable<String>(datosAnteriores.value);
    }
    if (datosNuevos.present) {
      map['datos_nuevos'] = Variable<String>(datosNuevos.value);
    }
    if (ipAddress.present) {
      map['ip_address'] = Variable<String>(ipAddress.value);
    }
    if (dispositivo.present) {
      map['dispositivo'] = Variable<String>(dispositivo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditoriasCompanion(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('tablaAfectada: $tablaAfectada, ')
          ..write('accion: $accion, ')
          ..write('datosAnteriores: $datosAnteriores, ')
          ..write('datosNuevos: $datosNuevos, ')
          ..write('ipAddress: $ipAddress, ')
          ..write('dispositivo: $dispositivo, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TiendasTable tiendas = $TiendasTable(this);
  late final $RolesTable roles = $RolesTable(this);
  late final $UsuariosTable usuarios = $UsuariosTable(this);
  late final $AlmacenesTable almacenes = $AlmacenesTable(this);
  late final $CategoriasTable categorias = $CategoriasTable(this);
  late final $UnidadesMedidaTable unidadesMedida = $UnidadesMedidaTable(this);
  late final $ProveedoresTable proveedores = $ProveedoresTable(this);
  late final $ProductosTable productos = $ProductosTable(this);
  late final $LotesTable lotes = $LotesTable(this);
  late final $InventariosTable inventarios = $InventariosTable(this);
  late final $MovimientosTable movimientos = $MovimientosTable(this);
  late final $AuditoriasTable auditorias = $AuditoriasTable(this);
  late final UsuarioDao usuarioDao = UsuarioDao(this as AppDatabase);
  late final ProductoDao productoDao = ProductoDao(this as AppDatabase);
  late final InventarioDao inventarioDao = InventarioDao(this as AppDatabase);
  late final MovimientoDao movimientoDao = MovimientoDao(this as AppDatabase);
  late final TiendaDao tiendaDao = TiendaDao(this as AppDatabase);
  late final AlmacenDao almacenDao = AlmacenDao(this as AppDatabase);
  late final ProveedorDao proveedorDao = ProveedorDao(this as AppDatabase);
  late final LoteDao loteDao = LoteDao(this as AppDatabase);
  late final CategoriaDao categoriaDao = CategoriaDao(this as AppDatabase);
  late final UnidadMedidaDao unidadMedidaDao = UnidadMedidaDao(
    this as AppDatabase,
  );
  late final RolDao rolDao = RolDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tiendas,
    roles,
    usuarios,
    almacenes,
    categorias,
    unidadesMedida,
    proveedores,
    productos,
    lotes,
    inventarios,
    movimientos,
    auditorias,
  ];
}

typedef $$TiendasTableCreateCompanionBuilder =
    TiendasCompanion Function({
      required String id,
      required String nombre,
      required String codigo,
      required String direccion,
      required String ciudad,
      required String departamento,
      Value<String?> telefono,
      Value<String?> horarioAtencion,
      Value<bool> activo,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> syncId,
      Value<DateTime?> lastSync,
      Value<int> rowid,
    });
typedef $$TiendasTableUpdateCompanionBuilder =
    TiendasCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<String> codigo,
      Value<String> direccion,
      Value<String> ciudad,
      Value<String> departamento,
      Value<String?> telefono,
      Value<String?> horarioAtencion,
      Value<bool> activo,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> syncId,
      Value<DateTime?> lastSync,
      Value<int> rowid,
    });

final class $$TiendasTableReferences
    extends BaseReferences<_$AppDatabase, $TiendasTable, TiendaTable> {
  $$TiendasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UsuariosTable, List<UsuarioTable>>
  _usuariosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.usuarios,
    aliasName: $_aliasNameGenerator(db.tiendas.id, db.usuarios.tiendaId),
  );

  $$UsuariosTableProcessedTableManager get usuariosRefs {
    final manager = $$UsuariosTableTableManager(
      $_db,
      $_db.usuarios,
    ).filter((f) => f.tiendaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_usuariosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AlmacenesTable, List<AlmacenTable>>
  _almacenesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.almacenes,
    aliasName: $_aliasNameGenerator(db.tiendas.id, db.almacenes.tiendaId),
  );

  $$AlmacenesTableProcessedTableManager get almacenesRefs {
    final manager = $$AlmacenesTableTableManager(
      $_db,
      $_db.almacenes,
    ).filter((f) => f.tiendaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_almacenesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InventariosTable, List<InventarioTable>>
  _inventariosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.inventarios,
    aliasName: $_aliasNameGenerator(db.tiendas.id, db.inventarios.tiendaId),
  );

  $$InventariosTableProcessedTableManager get inventariosRefs {
    final manager = $$InventariosTableTableManager(
      $_db,
      $_db.inventarios,
    ).filter((f) => f.tiendaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_inventariosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TiendasTableFilterComposer
    extends Composer<_$AppDatabase, $TiendasTable> {
  $$TiendasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ciudad => $composableBuilder(
    column: $table.ciudad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get departamento => $composableBuilder(
    column: $table.departamento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get horarioAtencion => $composableBuilder(
    column: $table.horarioAtencion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> usuariosRefs(
    Expression<bool> Function($$UsuariosTableFilterComposer f) f,
  ) {
    final $$UsuariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.tiendaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableFilterComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> almacenesRefs(
    Expression<bool> Function($$AlmacenesTableFilterComposer f) f,
  ) {
    final $$AlmacenesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.almacenes,
      getReferencedColumn: (t) => t.tiendaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlmacenesTableFilterComposer(
            $db: $db,
            $table: $db.almacenes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> inventariosRefs(
    Expression<bool> Function($$InventariosTableFilterComposer f) f,
  ) {
    final $$InventariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventarios,
      getReferencedColumn: (t) => t.tiendaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventariosTableFilterComposer(
            $db: $db,
            $table: $db.inventarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TiendasTableOrderingComposer
    extends Composer<_$AppDatabase, $TiendasTable> {
  $$TiendasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ciudad => $composableBuilder(
    column: $table.ciudad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get departamento => $composableBuilder(
    column: $table.departamento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get horarioAtencion => $composableBuilder(
    column: $table.horarioAtencion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TiendasTableAnnotationComposer
    extends Composer<_$AppDatabase, $TiendasTable> {
  $$TiendasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<String> get ciudad =>
      $composableBuilder(column: $table.ciudad, builder: (column) => column);

  GeneratedColumn<String> get departamento => $composableBuilder(
    column: $table.departamento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get horarioAtencion => $composableBuilder(
    column: $table.horarioAtencion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSync =>
      $composableBuilder(column: $table.lastSync, builder: (column) => column);

  Expression<T> usuariosRefs<T extends Object>(
    Expression<T> Function($$UsuariosTableAnnotationComposer a) f,
  ) {
    final $$UsuariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.tiendaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableAnnotationComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> almacenesRefs<T extends Object>(
    Expression<T> Function($$AlmacenesTableAnnotationComposer a) f,
  ) {
    final $$AlmacenesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.almacenes,
      getReferencedColumn: (t) => t.tiendaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlmacenesTableAnnotationComposer(
            $db: $db,
            $table: $db.almacenes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> inventariosRefs<T extends Object>(
    Expression<T> Function($$InventariosTableAnnotationComposer a) f,
  ) {
    final $$InventariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventarios,
      getReferencedColumn: (t) => t.tiendaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventariosTableAnnotationComposer(
            $db: $db,
            $table: $db.inventarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TiendasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TiendasTable,
          TiendaTable,
          $$TiendasTableFilterComposer,
          $$TiendasTableOrderingComposer,
          $$TiendasTableAnnotationComposer,
          $$TiendasTableCreateCompanionBuilder,
          $$TiendasTableUpdateCompanionBuilder,
          (TiendaTable, $$TiendasTableReferences),
          TiendaTable,
          PrefetchHooks Function({
            bool usuariosRefs,
            bool almacenesRefs,
            bool inventariosRefs,
          })
        > {
  $$TiendasTableTableManager(_$AppDatabase db, $TiendasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TiendasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TiendasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TiendasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<String> direccion = const Value.absent(),
                Value<String> ciudad = const Value.absent(),
                Value<String> departamento = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<String?> horarioAtencion = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> syncId = const Value.absent(),
                Value<DateTime?> lastSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TiendasCompanion(
                id: id,
                nombre: nombre,
                codigo: codigo,
                direccion: direccion,
                ciudad: ciudad,
                departamento: departamento,
                telefono: telefono,
                horarioAtencion: horarioAtencion,
                activo: activo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncId: syncId,
                lastSync: lastSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                required String codigo,
                required String direccion,
                required String ciudad,
                required String departamento,
                Value<String?> telefono = const Value.absent(),
                Value<String?> horarioAtencion = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> syncId = const Value.absent(),
                Value<DateTime?> lastSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TiendasCompanion.insert(
                id: id,
                nombre: nombre,
                codigo: codigo,
                direccion: direccion,
                ciudad: ciudad,
                departamento: departamento,
                telefono: telefono,
                horarioAtencion: horarioAtencion,
                activo: activo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncId: syncId,
                lastSync: lastSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TiendasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                usuariosRefs = false,
                almacenesRefs = false,
                inventariosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (usuariosRefs) db.usuarios,
                    if (almacenesRefs) db.almacenes,
                    if (inventariosRefs) db.inventarios,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (usuariosRefs)
                        await $_getPrefetchedData<
                          TiendaTable,
                          $TiendasTable,
                          UsuarioTable
                        >(
                          currentTable: table,
                          referencedTable: $$TiendasTableReferences
                              ._usuariosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TiendasTableReferences(
                                db,
                                table,
                                p0,
                              ).usuariosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tiendaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (almacenesRefs)
                        await $_getPrefetchedData<
                          TiendaTable,
                          $TiendasTable,
                          AlmacenTable
                        >(
                          currentTable: table,
                          referencedTable: $$TiendasTableReferences
                              ._almacenesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TiendasTableReferences(
                                db,
                                table,
                                p0,
                              ).almacenesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tiendaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (inventariosRefs)
                        await $_getPrefetchedData<
                          TiendaTable,
                          $TiendasTable,
                          InventarioTable
                        >(
                          currentTable: table,
                          referencedTable: $$TiendasTableReferences
                              ._inventariosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TiendasTableReferences(
                                db,
                                table,
                                p0,
                              ).inventariosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tiendaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TiendasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TiendasTable,
      TiendaTable,
      $$TiendasTableFilterComposer,
      $$TiendasTableOrderingComposer,
      $$TiendasTableAnnotationComposer,
      $$TiendasTableCreateCompanionBuilder,
      $$TiendasTableUpdateCompanionBuilder,
      (TiendaTable, $$TiendasTableReferences),
      TiendaTable,
      PrefetchHooks Function({
        bool usuariosRefs,
        bool almacenesRefs,
        bool inventariosRefs,
      })
    >;
typedef $$RolesTableCreateCompanionBuilder =
    RolesCompanion Function({
      required String id,
      required String nombre,
      Value<String?> descripcion,
      required String permisos,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$RolesTableUpdateCompanionBuilder =
    RolesCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<String?> descripcion,
      Value<String> permisos,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$RolesTableReferences
    extends BaseReferences<_$AppDatabase, $RolesTable, RolTable> {
  $$RolesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UsuariosTable, List<UsuarioTable>>
  _usuariosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.usuarios,
    aliasName: $_aliasNameGenerator(db.roles.id, db.usuarios.rolId),
  );

  $$UsuariosTableProcessedTableManager get usuariosRefs {
    final manager = $$UsuariosTableTableManager(
      $_db,
      $_db.usuarios,
    ).filter((f) => f.rolId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_usuariosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RolesTableFilterComposer extends Composer<_$AppDatabase, $RolesTable> {
  $$RolesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get permisos => $composableBuilder(
    column: $table.permisos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> usuariosRefs(
    Expression<bool> Function($$UsuariosTableFilterComposer f) f,
  ) {
    final $$UsuariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.rolId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableFilterComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RolesTableOrderingComposer
    extends Composer<_$AppDatabase, $RolesTable> {
  $$RolesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get permisos => $composableBuilder(
    column: $table.permisos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RolesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RolesTable> {
  $$RolesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get permisos =>
      $composableBuilder(column: $table.permisos, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> usuariosRefs<T extends Object>(
    Expression<T> Function($$UsuariosTableAnnotationComposer a) f,
  ) {
    final $$UsuariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.rolId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableAnnotationComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RolesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RolesTable,
          RolTable,
          $$RolesTableFilterComposer,
          $$RolesTableOrderingComposer,
          $$RolesTableAnnotationComposer,
          $$RolesTableCreateCompanionBuilder,
          $$RolesTableUpdateCompanionBuilder,
          (RolTable, $$RolesTableReferences),
          RolTable,
          PrefetchHooks Function({bool usuariosRefs})
        > {
  $$RolesTableTableManager(_$AppDatabase db, $RolesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RolesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RolesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RolesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> descripcion = const Value.absent(),
                Value<String> permisos = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RolesCompanion(
                id: id,
                nombre: nombre,
                descripcion: descripcion,
                permisos: permisos,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                Value<String?> descripcion = const Value.absent(),
                required String permisos,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RolesCompanion.insert(
                id: id,
                nombre: nombre,
                descripcion: descripcion,
                permisos: permisos,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$RolesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({usuariosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (usuariosRefs) db.usuarios],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (usuariosRefs)
                    await $_getPrefetchedData<
                      RolTable,
                      $RolesTable,
                      UsuarioTable
                    >(
                      currentTable: table,
                      referencedTable: $$RolesTableReferences
                          ._usuariosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RolesTableReferences(db, table, p0).usuariosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.rolId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RolesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RolesTable,
      RolTable,
      $$RolesTableFilterComposer,
      $$RolesTableOrderingComposer,
      $$RolesTableAnnotationComposer,
      $$RolesTableCreateCompanionBuilder,
      $$RolesTableUpdateCompanionBuilder,
      (RolTable, $$RolesTableReferences),
      RolTable,
      PrefetchHooks Function({bool usuariosRefs})
    >;
typedef $$UsuariosTableCreateCompanionBuilder =
    UsuariosCompanion Function({
      required String id,
      required String email,
      required String nombreCompleto,
      Value<String?> telefono,
      Value<String?> tiendaId,
      required String rolId,
      Value<bool> activo,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> syncId,
      Value<DateTime?> lastSync,
      Value<int> rowid,
    });
typedef $$UsuariosTableUpdateCompanionBuilder =
    UsuariosCompanion Function({
      Value<String> id,
      Value<String> email,
      Value<String> nombreCompleto,
      Value<String?> telefono,
      Value<String?> tiendaId,
      Value<String> rolId,
      Value<bool> activo,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> syncId,
      Value<DateTime?> lastSync,
      Value<int> rowid,
    });

final class $$UsuariosTableReferences
    extends BaseReferences<_$AppDatabase, $UsuariosTable, UsuarioTable> {
  $$UsuariosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TiendasTable _tiendaIdTable(_$AppDatabase db) => db.tiendas
      .createAlias($_aliasNameGenerator(db.usuarios.tiendaId, db.tiendas.id));

  $$TiendasTableProcessedTableManager? get tiendaId {
    final $_column = $_itemColumn<String>('tienda_id');
    if ($_column == null) return null;
    final manager = $$TiendasTableTableManager(
      $_db,
      $_db.tiendas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tiendaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RolesTable _rolIdTable(_$AppDatabase db) => db.roles.createAlias(
    $_aliasNameGenerator(db.usuarios.rolId, db.roles.id),
  );

  $$RolesTableProcessedTableManager get rolId {
    final $_column = $_itemColumn<String>('rol_id')!;

    final manager = $$RolesTableTableManager(
      $_db,
      $_db.roles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rolIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MovimientosTable, List<MovimientoTable>>
  _movimientosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.movimientos,
    aliasName: $_aliasNameGenerator(db.usuarios.id, db.movimientos.usuarioId),
  );

  $$MovimientosTableProcessedTableManager get movimientosRefs {
    final manager = $$MovimientosTableTableManager(
      $_db,
      $_db.movimientos,
    ).filter((f) => f.usuarioId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_movimientosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AuditoriasTable, List<AuditoriaTable>>
  _auditoriasRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.auditorias,
    aliasName: $_aliasNameGenerator(db.usuarios.id, db.auditorias.usuarioId),
  );

  $$AuditoriasTableProcessedTableManager get auditoriasRefs {
    final manager = $$AuditoriasTableTableManager(
      $_db,
      $_db.auditorias,
    ).filter((f) => f.usuarioId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_auditoriasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsuariosTableFilterComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreCompleto => $composableBuilder(
    column: $table.nombreCompleto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnFilters(column),
  );

  $$TiendasTableFilterComposer get tiendaId {
    final $$TiendasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tiendaId,
      referencedTable: $db.tiendas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiendasTableFilterComposer(
            $db: $db,
            $table: $db.tiendas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RolesTableFilterComposer get rolId {
    final $$RolesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rolId,
      referencedTable: $db.roles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RolesTableFilterComposer(
            $db: $db,
            $table: $db.roles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> movimientosRefs(
    Expression<bool> Function($$MovimientosTableFilterComposer f) f,
  ) {
    final $$MovimientosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableFilterComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> auditoriasRefs(
    Expression<bool> Function($$AuditoriasTableFilterComposer f) f,
  ) {
    final $$AuditoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.auditorias,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuditoriasTableFilterComposer(
            $db: $db,
            $table: $db.auditorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsuariosTableOrderingComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreCompleto => $composableBuilder(
    column: $table.nombreCompleto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnOrderings(column),
  );

  $$TiendasTableOrderingComposer get tiendaId {
    final $$TiendasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tiendaId,
      referencedTable: $db.tiendas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiendasTableOrderingComposer(
            $db: $db,
            $table: $db.tiendas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RolesTableOrderingComposer get rolId {
    final $$RolesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rolId,
      referencedTable: $db.roles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RolesTableOrderingComposer(
            $db: $db,
            $table: $db.roles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UsuariosTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get nombreCompleto => $composableBuilder(
    column: $table.nombreCompleto,
    builder: (column) => column,
  );

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSync =>
      $composableBuilder(column: $table.lastSync, builder: (column) => column);

  $$TiendasTableAnnotationComposer get tiendaId {
    final $$TiendasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tiendaId,
      referencedTable: $db.tiendas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiendasTableAnnotationComposer(
            $db: $db,
            $table: $db.tiendas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RolesTableAnnotationComposer get rolId {
    final $$RolesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rolId,
      referencedTable: $db.roles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RolesTableAnnotationComposer(
            $db: $db,
            $table: $db.roles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> movimientosRefs<T extends Object>(
    Expression<T> Function($$MovimientosTableAnnotationComposer a) f,
  ) {
    final $$MovimientosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableAnnotationComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> auditoriasRefs<T extends Object>(
    Expression<T> Function($$AuditoriasTableAnnotationComposer a) f,
  ) {
    final $$AuditoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.auditorias,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuditoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.auditorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsuariosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsuariosTable,
          UsuarioTable,
          $$UsuariosTableFilterComposer,
          $$UsuariosTableOrderingComposer,
          $$UsuariosTableAnnotationComposer,
          $$UsuariosTableCreateCompanionBuilder,
          $$UsuariosTableUpdateCompanionBuilder,
          (UsuarioTable, $$UsuariosTableReferences),
          UsuarioTable,
          PrefetchHooks Function({
            bool tiendaId,
            bool rolId,
            bool movimientosRefs,
            bool auditoriasRefs,
          })
        > {
  $$UsuariosTableTableManager(_$AppDatabase db, $UsuariosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsuariosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsuariosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsuariosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> nombreCompleto = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<String?> tiendaId = const Value.absent(),
                Value<String> rolId = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> syncId = const Value.absent(),
                Value<DateTime?> lastSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsuariosCompanion(
                id: id,
                email: email,
                nombreCompleto: nombreCompleto,
                telefono: telefono,
                tiendaId: tiendaId,
                rolId: rolId,
                activo: activo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncId: syncId,
                lastSync: lastSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String email,
                required String nombreCompleto,
                Value<String?> telefono = const Value.absent(),
                Value<String?> tiendaId = const Value.absent(),
                required String rolId,
                Value<bool> activo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> syncId = const Value.absent(),
                Value<DateTime?> lastSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsuariosCompanion.insert(
                id: id,
                email: email,
                nombreCompleto: nombreCompleto,
                telefono: telefono,
                tiendaId: tiendaId,
                rolId: rolId,
                activo: activo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncId: syncId,
                lastSync: lastSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UsuariosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                tiendaId = false,
                rolId = false,
                movimientosRefs = false,
                auditoriasRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (movimientosRefs) db.movimientos,
                    if (auditoriasRefs) db.auditorias,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
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
                        if (tiendaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tiendaId,
                                    referencedTable: $$UsuariosTableReferences
                                        ._tiendaIdTable(db),
                                    referencedColumn: $$UsuariosTableReferences
                                        ._tiendaIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (rolId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.rolId,
                                    referencedTable: $$UsuariosTableReferences
                                        ._rolIdTable(db),
                                    referencedColumn: $$UsuariosTableReferences
                                        ._rolIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (movimientosRefs)
                        await $_getPrefetchedData<
                          UsuarioTable,
                          $UsuariosTable,
                          MovimientoTable
                        >(
                          currentTable: table,
                          referencedTable: $$UsuariosTableReferences
                              ._movimientosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsuariosTableReferences(
                                db,
                                table,
                                p0,
                              ).movimientosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.usuarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (auditoriasRefs)
                        await $_getPrefetchedData<
                          UsuarioTable,
                          $UsuariosTable,
                          AuditoriaTable
                        >(
                          currentTable: table,
                          referencedTable: $$UsuariosTableReferences
                              ._auditoriasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsuariosTableReferences(
                                db,
                                table,
                                p0,
                              ).auditoriasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.usuarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UsuariosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsuariosTable,
      UsuarioTable,
      $$UsuariosTableFilterComposer,
      $$UsuariosTableOrderingComposer,
      $$UsuariosTableAnnotationComposer,
      $$UsuariosTableCreateCompanionBuilder,
      $$UsuariosTableUpdateCompanionBuilder,
      (UsuarioTable, $$UsuariosTableReferences),
      UsuarioTable,
      PrefetchHooks Function({
        bool tiendaId,
        bool rolId,
        bool movimientosRefs,
        bool auditoriasRefs,
      })
    >;
typedef $$AlmacenesTableCreateCompanionBuilder =
    AlmacenesCompanion Function({
      required String id,
      required String nombre,
      required String codigo,
      required String tiendaId,
      required String ubicacion,
      required String tipo,
      Value<double?> capacidadM3,
      Value<double?> areaM2,
      Value<bool> activo,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> syncId,
      Value<DateTime?> lastSync,
      Value<int> rowid,
    });
typedef $$AlmacenesTableUpdateCompanionBuilder =
    AlmacenesCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<String> codigo,
      Value<String> tiendaId,
      Value<String> ubicacion,
      Value<String> tipo,
      Value<double?> capacidadM3,
      Value<double?> areaM2,
      Value<bool> activo,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> syncId,
      Value<DateTime?> lastSync,
      Value<int> rowid,
    });

final class $$AlmacenesTableReferences
    extends BaseReferences<_$AppDatabase, $AlmacenesTable, AlmacenTable> {
  $$AlmacenesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TiendasTable _tiendaIdTable(_$AppDatabase db) => db.tiendas
      .createAlias($_aliasNameGenerator(db.almacenes.tiendaId, db.tiendas.id));

  $$TiendasTableProcessedTableManager get tiendaId {
    final $_column = $_itemColumn<String>('tienda_id')!;

    final manager = $$TiendasTableTableManager(
      $_db,
      $_db.tiendas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tiendaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$InventariosTable, List<InventarioTable>>
  _inventariosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.inventarios,
    aliasName: $_aliasNameGenerator(db.almacenes.id, db.inventarios.almacenId),
  );

  $$InventariosTableProcessedTableManager get inventariosRefs {
    final manager = $$InventariosTableTableManager(
      $_db,
      $_db.inventarios,
    ).filter((f) => f.almacenId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_inventariosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AlmacenesTableFilterComposer
    extends Composer<_$AppDatabase, $AlmacenesTable> {
  $$AlmacenesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ubicacion => $composableBuilder(
    column: $table.ubicacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get capacidadM3 => $composableBuilder(
    column: $table.capacidadM3,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get areaM2 => $composableBuilder(
    column: $table.areaM2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnFilters(column),
  );

  $$TiendasTableFilterComposer get tiendaId {
    final $$TiendasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tiendaId,
      referencedTable: $db.tiendas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiendasTableFilterComposer(
            $db: $db,
            $table: $db.tiendas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> inventariosRefs(
    Expression<bool> Function($$InventariosTableFilterComposer f) f,
  ) {
    final $$InventariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventarios,
      getReferencedColumn: (t) => t.almacenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventariosTableFilterComposer(
            $db: $db,
            $table: $db.inventarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AlmacenesTableOrderingComposer
    extends Composer<_$AppDatabase, $AlmacenesTable> {
  $$AlmacenesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ubicacion => $composableBuilder(
    column: $table.ubicacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get capacidadM3 => $composableBuilder(
    column: $table.capacidadM3,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get areaM2 => $composableBuilder(
    column: $table.areaM2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnOrderings(column),
  );

  $$TiendasTableOrderingComposer get tiendaId {
    final $$TiendasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tiendaId,
      referencedTable: $db.tiendas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiendasTableOrderingComposer(
            $db: $db,
            $table: $db.tiendas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AlmacenesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlmacenesTable> {
  $$AlmacenesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get ubicacion =>
      $composableBuilder(column: $table.ubicacion, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<double> get capacidadM3 => $composableBuilder(
    column: $table.capacidadM3,
    builder: (column) => column,
  );

  GeneratedColumn<double> get areaM2 =>
      $composableBuilder(column: $table.areaM2, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSync =>
      $composableBuilder(column: $table.lastSync, builder: (column) => column);

  $$TiendasTableAnnotationComposer get tiendaId {
    final $$TiendasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tiendaId,
      referencedTable: $db.tiendas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiendasTableAnnotationComposer(
            $db: $db,
            $table: $db.tiendas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> inventariosRefs<T extends Object>(
    Expression<T> Function($$InventariosTableAnnotationComposer a) f,
  ) {
    final $$InventariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventarios,
      getReferencedColumn: (t) => t.almacenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventariosTableAnnotationComposer(
            $db: $db,
            $table: $db.inventarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AlmacenesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlmacenesTable,
          AlmacenTable,
          $$AlmacenesTableFilterComposer,
          $$AlmacenesTableOrderingComposer,
          $$AlmacenesTableAnnotationComposer,
          $$AlmacenesTableCreateCompanionBuilder,
          $$AlmacenesTableUpdateCompanionBuilder,
          (AlmacenTable, $$AlmacenesTableReferences),
          AlmacenTable,
          PrefetchHooks Function({bool tiendaId, bool inventariosRefs})
        > {
  $$AlmacenesTableTableManager(_$AppDatabase db, $AlmacenesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlmacenesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlmacenesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlmacenesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<String> tiendaId = const Value.absent(),
                Value<String> ubicacion = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<double?> capacidadM3 = const Value.absent(),
                Value<double?> areaM2 = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> syncId = const Value.absent(),
                Value<DateTime?> lastSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlmacenesCompanion(
                id: id,
                nombre: nombre,
                codigo: codigo,
                tiendaId: tiendaId,
                ubicacion: ubicacion,
                tipo: tipo,
                capacidadM3: capacidadM3,
                areaM2: areaM2,
                activo: activo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncId: syncId,
                lastSync: lastSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                required String codigo,
                required String tiendaId,
                required String ubicacion,
                required String tipo,
                Value<double?> capacidadM3 = const Value.absent(),
                Value<double?> areaM2 = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> syncId = const Value.absent(),
                Value<DateTime?> lastSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlmacenesCompanion.insert(
                id: id,
                nombre: nombre,
                codigo: codigo,
                tiendaId: tiendaId,
                ubicacion: ubicacion,
                tipo: tipo,
                capacidadM3: capacidadM3,
                areaM2: areaM2,
                activo: activo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncId: syncId,
                lastSync: lastSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AlmacenesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tiendaId = false, inventariosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (inventariosRefs) db.inventarios],
              addJoins:
                  <
                    T extends TableManagerState<
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
                    if (tiendaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tiendaId,
                                referencedTable: $$AlmacenesTableReferences
                                    ._tiendaIdTable(db),
                                referencedColumn: $$AlmacenesTableReferences
                                    ._tiendaIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (inventariosRefs)
                    await $_getPrefetchedData<
                      AlmacenTable,
                      $AlmacenesTable,
                      InventarioTable
                    >(
                      currentTable: table,
                      referencedTable: $$AlmacenesTableReferences
                          ._inventariosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$AlmacenesTableReferences(
                            db,
                            table,
                            p0,
                          ).inventariosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.almacenId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AlmacenesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlmacenesTable,
      AlmacenTable,
      $$AlmacenesTableFilterComposer,
      $$AlmacenesTableOrderingComposer,
      $$AlmacenesTableAnnotationComposer,
      $$AlmacenesTableCreateCompanionBuilder,
      $$AlmacenesTableUpdateCompanionBuilder,
      (AlmacenTable, $$AlmacenesTableReferences),
      AlmacenTable,
      PrefetchHooks Function({bool tiendaId, bool inventariosRefs})
    >;
typedef $$CategoriasTableCreateCompanionBuilder =
    CategoriasCompanion Function({
      required String id,
      required String nombre,
      required String codigo,
      Value<String?> descripcion,
      Value<String?> categoriaPadreId,
      Value<bool> requiereLote,
      Value<bool> requiereCertificacion,
      Value<bool> activo,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> syncId,
      Value<DateTime?> lastSync,
      Value<int> rowid,
    });
typedef $$CategoriasTableUpdateCompanionBuilder =
    CategoriasCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<String> codigo,
      Value<String?> descripcion,
      Value<String?> categoriaPadreId,
      Value<bool> requiereLote,
      Value<bool> requiereCertificacion,
      Value<bool> activo,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> syncId,
      Value<DateTime?> lastSync,
      Value<int> rowid,
    });

final class $$CategoriasTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriasTable, CategoriaTable> {
  $$CategoriasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriasTable _categoriaPadreIdTable(_$AppDatabase db) =>
      db.categorias.createAlias(
        $_aliasNameGenerator(db.categorias.categoriaPadreId, db.categorias.id),
      );

  $$CategoriasTableProcessedTableManager? get categoriaPadreId {
    final $_column = $_itemColumn<String>('categoria_padre_id');
    if ($_column == null) return null;
    final manager = $$CategoriasTableTableManager(
      $_db,
      $_db.categorias,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaPadreIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ProductosTable, List<ProductoTable>>
  _productosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.productos,
    aliasName: $_aliasNameGenerator(db.categorias.id, db.productos.categoriaId),
  );

  $$ProductosTableProcessedTableManager get productosRefs {
    final manager = $$ProductosTableTableManager(
      $_db,
      $_db.productos,
    ).filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_productosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriasTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiereLote => $composableBuilder(
    column: $table.requiereLote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiereCertificacion => $composableBuilder(
    column: $table.requiereCertificacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriasTableFilterComposer get categoriaPadreId {
    final $$CategoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaPadreId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableFilterComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> productosRefs(
    Expression<bool> Function($$ProductosTableFilterComposer f) f,
  ) {
    final $$ProductosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableFilterComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriasTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiereLote => $composableBuilder(
    column: $table.requiereLote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiereCertificacion => $composableBuilder(
    column: $table.requiereCertificacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriasTableOrderingComposer get categoriaPadreId {
    final $$CategoriasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaPadreId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableOrderingComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoriasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get requiereLote => $composableBuilder(
    column: $table.requiereLote,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get requiereCertificacion => $composableBuilder(
    column: $table.requiereCertificacion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSync =>
      $composableBuilder(column: $table.lastSync, builder: (column) => column);

  $$CategoriasTableAnnotationComposer get categoriaPadreId {
    final $$CategoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaPadreId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> productosRefs<T extends Object>(
    Expression<T> Function($$ProductosTableAnnotationComposer a) f,
  ) {
    final $$ProductosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableAnnotationComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriasTable,
          CategoriaTable,
          $$CategoriasTableFilterComposer,
          $$CategoriasTableOrderingComposer,
          $$CategoriasTableAnnotationComposer,
          $$CategoriasTableCreateCompanionBuilder,
          $$CategoriasTableUpdateCompanionBuilder,
          (CategoriaTable, $$CategoriasTableReferences),
          CategoriaTable,
          PrefetchHooks Function({bool categoriaPadreId, bool productosRefs})
        > {
  $$CategoriasTableTableManager(_$AppDatabase db, $CategoriasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<String?> descripcion = const Value.absent(),
                Value<String?> categoriaPadreId = const Value.absent(),
                Value<bool> requiereLote = const Value.absent(),
                Value<bool> requiereCertificacion = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> syncId = const Value.absent(),
                Value<DateTime?> lastSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriasCompanion(
                id: id,
                nombre: nombre,
                codigo: codigo,
                descripcion: descripcion,
                categoriaPadreId: categoriaPadreId,
                requiereLote: requiereLote,
                requiereCertificacion: requiereCertificacion,
                activo: activo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncId: syncId,
                lastSync: lastSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                required String codigo,
                Value<String?> descripcion = const Value.absent(),
                Value<String?> categoriaPadreId = const Value.absent(),
                Value<bool> requiereLote = const Value.absent(),
                Value<bool> requiereCertificacion = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> syncId = const Value.absent(),
                Value<DateTime?> lastSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriasCompanion.insert(
                id: id,
                nombre: nombre,
                codigo: codigo,
                descripcion: descripcion,
                categoriaPadreId: categoriaPadreId,
                requiereLote: requiereLote,
                requiereCertificacion: requiereCertificacion,
                activo: activo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncId: syncId,
                lastSync: lastSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({categoriaPadreId = false, productosRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (productosRefs) db.productos],
                  addJoins:
                      <
                        T extends TableManagerState<
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
                        if (categoriaPadreId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoriaPadreId,
                                    referencedTable: $$CategoriasTableReferences
                                        ._categoriaPadreIdTable(db),
                                    referencedColumn:
                                        $$CategoriasTableReferences
                                            ._categoriaPadreIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (productosRefs)
                        await $_getPrefetchedData<
                          CategoriaTable,
                          $CategoriasTable,
                          ProductoTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriasTableReferences
                              ._productosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriasTableReferences(
                                db,
                                table,
                                p0,
                              ).productosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoriaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriasTable,
      CategoriaTable,
      $$CategoriasTableFilterComposer,
      $$CategoriasTableOrderingComposer,
      $$CategoriasTableAnnotationComposer,
      $$CategoriasTableCreateCompanionBuilder,
      $$CategoriasTableUpdateCompanionBuilder,
      (CategoriaTable, $$CategoriasTableReferences),
      CategoriaTable,
      PrefetchHooks Function({bool categoriaPadreId, bool productosRefs})
    >;
typedef $$UnidadesMedidaTableCreateCompanionBuilder =
    UnidadesMedidaCompanion Function({
      required String id,
      required String nombre,
      required String abreviatura,
      required String tipo,
      Value<double> factorConversion,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$UnidadesMedidaTableUpdateCompanionBuilder =
    UnidadesMedidaCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<String> abreviatura,
      Value<String> tipo,
      Value<double> factorConversion,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$UnidadesMedidaTableReferences
    extends
        BaseReferences<_$AppDatabase, $UnidadesMedidaTable, UnidadMedidaTable> {
  $$UnidadesMedidaTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ProductosTable, List<ProductoTable>>
  _productosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.productos,
    aliasName: $_aliasNameGenerator(
      db.unidadesMedida.id,
      db.productos.unidadMedidaId,
    ),
  );

  $$ProductosTableProcessedTableManager get productosRefs {
    final manager = $$ProductosTableTableManager(
      $_db,
      $_db.productos,
    ).filter((f) => f.unidadMedidaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_productosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UnidadesMedidaTableFilterComposer
    extends Composer<_$AppDatabase, $UnidadesMedidaTable> {
  $$UnidadesMedidaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get abreviatura => $composableBuilder(
    column: $table.abreviatura,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get factorConversion => $composableBuilder(
    column: $table.factorConversion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productosRefs(
    Expression<bool> Function($$ProductosTableFilterComposer f) f,
  ) {
    final $$ProductosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.unidadMedidaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableFilterComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UnidadesMedidaTableOrderingComposer
    extends Composer<_$AppDatabase, $UnidadesMedidaTable> {
  $$UnidadesMedidaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get abreviatura => $composableBuilder(
    column: $table.abreviatura,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get factorConversion => $composableBuilder(
    column: $table.factorConversion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UnidadesMedidaTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnidadesMedidaTable> {
  $$UnidadesMedidaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get abreviatura => $composableBuilder(
    column: $table.abreviatura,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<double> get factorConversion => $composableBuilder(
    column: $table.factorConversion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> productosRefs<T extends Object>(
    Expression<T> Function($$ProductosTableAnnotationComposer a) f,
  ) {
    final $$ProductosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.unidadMedidaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableAnnotationComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UnidadesMedidaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnidadesMedidaTable,
          UnidadMedidaTable,
          $$UnidadesMedidaTableFilterComposer,
          $$UnidadesMedidaTableOrderingComposer,
          $$UnidadesMedidaTableAnnotationComposer,
          $$UnidadesMedidaTableCreateCompanionBuilder,
          $$UnidadesMedidaTableUpdateCompanionBuilder,
          (UnidadMedidaTable, $$UnidadesMedidaTableReferences),
          UnidadMedidaTable,
          PrefetchHooks Function({bool productosRefs})
        > {
  $$UnidadesMedidaTableTableManager(
    _$AppDatabase db,
    $UnidadesMedidaTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnidadesMedidaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnidadesMedidaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnidadesMedidaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> abreviatura = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<double> factorConversion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnidadesMedidaCompanion(
                id: id,
                nombre: nombre,
                abreviatura: abreviatura,
                tipo: tipo,
                factorConversion: factorConversion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                required String abreviatura,
                required String tipo,
                Value<double> factorConversion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnidadesMedidaCompanion.insert(
                id: id,
                nombre: nombre,
                abreviatura: abreviatura,
                tipo: tipo,
                factorConversion: factorConversion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UnidadesMedidaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (productosRefs) db.productos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productosRefs)
                    await $_getPrefetchedData<
                      UnidadMedidaTable,
                      $UnidadesMedidaTable,
                      ProductoTable
                    >(
                      currentTable: table,
                      referencedTable: $$UnidadesMedidaTableReferences
                          ._productosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$UnidadesMedidaTableReferences(
                            db,
                            table,
                            p0,
                          ).productosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.unidadMedidaId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UnidadesMedidaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnidadesMedidaTable,
      UnidadMedidaTable,
      $$UnidadesMedidaTableFilterComposer,
      $$UnidadesMedidaTableOrderingComposer,
      $$UnidadesMedidaTableAnnotationComposer,
      $$UnidadesMedidaTableCreateCompanionBuilder,
      $$UnidadesMedidaTableUpdateCompanionBuilder,
      (UnidadMedidaTable, $$UnidadesMedidaTableReferences),
      UnidadMedidaTable,
      PrefetchHooks Function({bool productosRefs})
    >;
typedef $$ProveedoresTableCreateCompanionBuilder =
    ProveedoresCompanion Function({
      required String id,
      required String razonSocial,
      required String nit,
      Value<String?> nombreContacto,
      Value<String?> telefono,
      Value<String?> email,
      Value<String?> direccion,
      Value<String?> ciudad,
      Value<String?> tipoMaterial,
      Value<int> diasCredito,
      Value<bool> activo,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> syncId,
      Value<DateTime?> lastSync,
      Value<int> rowid,
    });
typedef $$ProveedoresTableUpdateCompanionBuilder =
    ProveedoresCompanion Function({
      Value<String> id,
      Value<String> razonSocial,
      Value<String> nit,
      Value<String?> nombreContacto,
      Value<String?> telefono,
      Value<String?> email,
      Value<String?> direccion,
      Value<String?> ciudad,
      Value<String?> tipoMaterial,
      Value<int> diasCredito,
      Value<bool> activo,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> syncId,
      Value<DateTime?> lastSync,
      Value<int> rowid,
    });

final class $$ProveedoresTableReferences
    extends BaseReferences<_$AppDatabase, $ProveedoresTable, ProveedorTable> {
  $$ProveedoresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductosTable, List<ProductoTable>>
  _productosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.productos,
    aliasName: $_aliasNameGenerator(
      db.proveedores.id,
      db.productos.proveedorPrincipalId,
    ),
  );

  $$ProductosTableProcessedTableManager get productosRefs {
    final manager = $$ProductosTableTableManager($_db, $_db.productos).filter(
      (f) => f.proveedorPrincipalId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_productosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LotesTable, List<LoteTable>> _lotesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.lotes,
    aliasName: $_aliasNameGenerator(db.proveedores.id, db.lotes.proveedorId),
  );

  $$LotesTableProcessedTableManager get lotesRefs {
    final manager = $$LotesTableTableManager(
      $_db,
      $_db.lotes,
    ).filter((f) => f.proveedorId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_lotesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MovimientosTable, List<MovimientoTable>>
  _movimientosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.movimientos,
    aliasName: $_aliasNameGenerator(
      db.proveedores.id,
      db.movimientos.proveedorId,
    ),
  );

  $$MovimientosTableProcessedTableManager get movimientosRefs {
    final manager = $$MovimientosTableTableManager(
      $_db,
      $_db.movimientos,
    ).filter((f) => f.proveedorId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_movimientosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProveedoresTableFilterComposer
    extends Composer<_$AppDatabase, $ProveedoresTable> {
  $$ProveedoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get razonSocial => $composableBuilder(
    column: $table.razonSocial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nit => $composableBuilder(
    column: $table.nit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreContacto => $composableBuilder(
    column: $table.nombreContacto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ciudad => $composableBuilder(
    column: $table.ciudad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoMaterial => $composableBuilder(
    column: $table.tipoMaterial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diasCredito => $composableBuilder(
    column: $table.diasCredito,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productosRefs(
    Expression<bool> Function($$ProductosTableFilterComposer f) f,
  ) {
    final $$ProductosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.proveedorPrincipalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableFilterComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> lotesRefs(
    Expression<bool> Function($$LotesTableFilterComposer f) f,
  ) {
    final $$LotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lotes,
      getReferencedColumn: (t) => t.proveedorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LotesTableFilterComposer(
            $db: $db,
            $table: $db.lotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> movimientosRefs(
    Expression<bool> Function($$MovimientosTableFilterComposer f) f,
  ) {
    final $$MovimientosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.proveedorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableFilterComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProveedoresTableOrderingComposer
    extends Composer<_$AppDatabase, $ProveedoresTable> {
  $$ProveedoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get razonSocial => $composableBuilder(
    column: $table.razonSocial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nit => $composableBuilder(
    column: $table.nit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreContacto => $composableBuilder(
    column: $table.nombreContacto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ciudad => $composableBuilder(
    column: $table.ciudad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoMaterial => $composableBuilder(
    column: $table.tipoMaterial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diasCredito => $composableBuilder(
    column: $table.diasCredito,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProveedoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProveedoresTable> {
  $$ProveedoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get razonSocial => $composableBuilder(
    column: $table.razonSocial,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nit =>
      $composableBuilder(column: $table.nit, builder: (column) => column);

  GeneratedColumn<String> get nombreContacto => $composableBuilder(
    column: $table.nombreContacto,
    builder: (column) => column,
  );

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<String> get ciudad =>
      $composableBuilder(column: $table.ciudad, builder: (column) => column);

  GeneratedColumn<String> get tipoMaterial => $composableBuilder(
    column: $table.tipoMaterial,
    builder: (column) => column,
  );

  GeneratedColumn<int> get diasCredito => $composableBuilder(
    column: $table.diasCredito,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSync =>
      $composableBuilder(column: $table.lastSync, builder: (column) => column);

  Expression<T> productosRefs<T extends Object>(
    Expression<T> Function($$ProductosTableAnnotationComposer a) f,
  ) {
    final $$ProductosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.proveedorPrincipalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableAnnotationComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> lotesRefs<T extends Object>(
    Expression<T> Function($$LotesTableAnnotationComposer a) f,
  ) {
    final $$LotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lotes,
      getReferencedColumn: (t) => t.proveedorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LotesTableAnnotationComposer(
            $db: $db,
            $table: $db.lotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> movimientosRefs<T extends Object>(
    Expression<T> Function($$MovimientosTableAnnotationComposer a) f,
  ) {
    final $$MovimientosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.proveedorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableAnnotationComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProveedoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProveedoresTable,
          ProveedorTable,
          $$ProveedoresTableFilterComposer,
          $$ProveedoresTableOrderingComposer,
          $$ProveedoresTableAnnotationComposer,
          $$ProveedoresTableCreateCompanionBuilder,
          $$ProveedoresTableUpdateCompanionBuilder,
          (ProveedorTable, $$ProveedoresTableReferences),
          ProveedorTable,
          PrefetchHooks Function({
            bool productosRefs,
            bool lotesRefs,
            bool movimientosRefs,
          })
        > {
  $$ProveedoresTableTableManager(_$AppDatabase db, $ProveedoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProveedoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProveedoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProveedoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> razonSocial = const Value.absent(),
                Value<String> nit = const Value.absent(),
                Value<String?> nombreContacto = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> direccion = const Value.absent(),
                Value<String?> ciudad = const Value.absent(),
                Value<String?> tipoMaterial = const Value.absent(),
                Value<int> diasCredito = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> syncId = const Value.absent(),
                Value<DateTime?> lastSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProveedoresCompanion(
                id: id,
                razonSocial: razonSocial,
                nit: nit,
                nombreContacto: nombreContacto,
                telefono: telefono,
                email: email,
                direccion: direccion,
                ciudad: ciudad,
                tipoMaterial: tipoMaterial,
                diasCredito: diasCredito,
                activo: activo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncId: syncId,
                lastSync: lastSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String razonSocial,
                required String nit,
                Value<String?> nombreContacto = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> direccion = const Value.absent(),
                Value<String?> ciudad = const Value.absent(),
                Value<String?> tipoMaterial = const Value.absent(),
                Value<int> diasCredito = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> syncId = const Value.absent(),
                Value<DateTime?> lastSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProveedoresCompanion.insert(
                id: id,
                razonSocial: razonSocial,
                nit: nit,
                nombreContacto: nombreContacto,
                telefono: telefono,
                email: email,
                direccion: direccion,
                ciudad: ciudad,
                tipoMaterial: tipoMaterial,
                diasCredito: diasCredito,
                activo: activo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncId: syncId,
                lastSync: lastSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProveedoresTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                productosRefs = false,
                lotesRefs = false,
                movimientosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (productosRefs) db.productos,
                    if (lotesRefs) db.lotes,
                    if (movimientosRefs) db.movimientos,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (productosRefs)
                        await $_getPrefetchedData<
                          ProveedorTable,
                          $ProveedoresTable,
                          ProductoTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProveedoresTableReferences
                              ._productosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProveedoresTableReferences(
                                db,
                                table,
                                p0,
                              ).productosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.proveedorPrincipalId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (lotesRefs)
                        await $_getPrefetchedData<
                          ProveedorTable,
                          $ProveedoresTable,
                          LoteTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProveedoresTableReferences
                              ._lotesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProveedoresTableReferences(
                                db,
                                table,
                                p0,
                              ).lotesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.proveedorId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (movimientosRefs)
                        await $_getPrefetchedData<
                          ProveedorTable,
                          $ProveedoresTable,
                          MovimientoTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProveedoresTableReferences
                              ._movimientosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProveedoresTableReferences(
                                db,
                                table,
                                p0,
                              ).movimientosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.proveedorId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProveedoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProveedoresTable,
      ProveedorTable,
      $$ProveedoresTableFilterComposer,
      $$ProveedoresTableOrderingComposer,
      $$ProveedoresTableAnnotationComposer,
      $$ProveedoresTableCreateCompanionBuilder,
      $$ProveedoresTableUpdateCompanionBuilder,
      (ProveedorTable, $$ProveedoresTableReferences),
      ProveedorTable,
      PrefetchHooks Function({
        bool productosRefs,
        bool lotesRefs,
        bool movimientosRefs,
      })
    >;
typedef $$ProductosTableCreateCompanionBuilder =
    ProductosCompanion Function({
      required String id,
      required String nombre,
      required String codigo,
      Value<String?> descripcion,
      required String categoriaId,
      required String unidadMedidaId,
      Value<String?> proveedorPrincipalId,
      Value<double> precioCompra,
      Value<double> precioVenta,
      Value<double?> pesoUnitarioKg,
      Value<double?> volumenUnitarioM3,
      Value<int> stockMinimo,
      Value<int> stockMaximo,
      Value<String?> marca,
      Value<String?> gradoCalidad,
      Value<String?> normaTecnica,
      Value<bool> requiereAlmacenCubierto,
      Value<bool> materialPeligroso,
      Value<String?> imagenUrl,
      Value<String?> fichaTecnicaUrl,
      Value<bool> activo,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> syncId,
      Value<DateTime?> lastSync,
      Value<int> rowid,
    });
typedef $$ProductosTableUpdateCompanionBuilder =
    ProductosCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<String> codigo,
      Value<String?> descripcion,
      Value<String> categoriaId,
      Value<String> unidadMedidaId,
      Value<String?> proveedorPrincipalId,
      Value<double> precioCompra,
      Value<double> precioVenta,
      Value<double?> pesoUnitarioKg,
      Value<double?> volumenUnitarioM3,
      Value<int> stockMinimo,
      Value<int> stockMaximo,
      Value<String?> marca,
      Value<String?> gradoCalidad,
      Value<String?> normaTecnica,
      Value<bool> requiereAlmacenCubierto,
      Value<bool> materialPeligroso,
      Value<String?> imagenUrl,
      Value<String?> fichaTecnicaUrl,
      Value<bool> activo,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> syncId,
      Value<DateTime?> lastSync,
      Value<int> rowid,
    });

final class $$ProductosTableReferences
    extends BaseReferences<_$AppDatabase, $ProductosTable, ProductoTable> {
  $$ProductosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriasTable _categoriaIdTable(_$AppDatabase db) =>
      db.categorias.createAlias(
        $_aliasNameGenerator(db.productos.categoriaId, db.categorias.id),
      );

  $$CategoriasTableProcessedTableManager get categoriaId {
    final $_column = $_itemColumn<String>('categoria_id')!;

    final manager = $$CategoriasTableTableManager(
      $_db,
      $_db.categorias,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UnidadesMedidaTable _unidadMedidaIdTable(_$AppDatabase db) =>
      db.unidadesMedida.createAlias(
        $_aliasNameGenerator(db.productos.unidadMedidaId, db.unidadesMedida.id),
      );

  $$UnidadesMedidaTableProcessedTableManager get unidadMedidaId {
    final $_column = $_itemColumn<String>('unidad_medida_id')!;

    final manager = $$UnidadesMedidaTableTableManager(
      $_db,
      $_db.unidadesMedida,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_unidadMedidaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProveedoresTable _proveedorPrincipalIdTable(_$AppDatabase db) =>
      db.proveedores.createAlias(
        $_aliasNameGenerator(
          db.productos.proveedorPrincipalId,
          db.proveedores.id,
        ),
      );

  $$ProveedoresTableProcessedTableManager? get proveedorPrincipalId {
    final $_column = $_itemColumn<String>('proveedor_principal_id');
    if ($_column == null) return null;
    final manager = $$ProveedoresTableTableManager(
      $_db,
      $_db.proveedores,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _proveedorPrincipalIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$LotesTable, List<LoteTable>> _lotesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.lotes,
    aliasName: $_aliasNameGenerator(db.productos.id, db.lotes.productoId),
  );

  $$LotesTableProcessedTableManager get lotesRefs {
    final manager = $$LotesTableTableManager(
      $_db,
      $_db.lotes,
    ).filter((f) => f.productoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_lotesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InventariosTable, List<InventarioTable>>
  _inventariosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.inventarios,
    aliasName: $_aliasNameGenerator(db.productos.id, db.inventarios.productoId),
  );

  $$InventariosTableProcessedTableManager get inventariosRefs {
    final manager = $$InventariosTableTableManager(
      $_db,
      $_db.inventarios,
    ).filter((f) => f.productoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_inventariosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MovimientosTable, List<MovimientoTable>>
  _movimientosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.movimientos,
    aliasName: $_aliasNameGenerator(db.productos.id, db.movimientos.productoId),
  );

  $$MovimientosTableProcessedTableManager get movimientosRefs {
    final manager = $$MovimientosTableTableManager(
      $_db,
      $_db.movimientos,
    ).filter((f) => f.productoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_movimientosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductosTableFilterComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioCompra => $composableBuilder(
    column: $table.precioCompra,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioVenta => $composableBuilder(
    column: $table.precioVenta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pesoUnitarioKg => $composableBuilder(
    column: $table.pesoUnitarioKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get volumenUnitarioM3 => $composableBuilder(
    column: $table.volumenUnitarioM3,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stockMinimo => $composableBuilder(
    column: $table.stockMinimo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stockMaximo => $composableBuilder(
    column: $table.stockMaximo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get marca => $composableBuilder(
    column: $table.marca,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gradoCalidad => $composableBuilder(
    column: $table.gradoCalidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normaTecnica => $composableBuilder(
    column: $table.normaTecnica,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiereAlmacenCubierto => $composableBuilder(
    column: $table.requiereAlmacenCubierto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get materialPeligroso => $composableBuilder(
    column: $table.materialPeligroso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagenUrl => $composableBuilder(
    column: $table.imagenUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fichaTecnicaUrl => $composableBuilder(
    column: $table.fichaTecnicaUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriasTableFilterComposer get categoriaId {
    final $$CategoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableFilterComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnidadesMedidaTableFilterComposer get unidadMedidaId {
    final $$UnidadesMedidaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unidadMedidaId,
      referencedTable: $db.unidadesMedida,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnidadesMedidaTableFilterComposer(
            $db: $db,
            $table: $db.unidadesMedida,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProveedoresTableFilterComposer get proveedorPrincipalId {
    final $$ProveedoresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proveedorPrincipalId,
      referencedTable: $db.proveedores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProveedoresTableFilterComposer(
            $db: $db,
            $table: $db.proveedores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> lotesRefs(
    Expression<bool> Function($$LotesTableFilterComposer f) f,
  ) {
    final $$LotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lotes,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LotesTableFilterComposer(
            $db: $db,
            $table: $db.lotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> inventariosRefs(
    Expression<bool> Function($$InventariosTableFilterComposer f) f,
  ) {
    final $$InventariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventarios,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventariosTableFilterComposer(
            $db: $db,
            $table: $db.inventarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> movimientosRefs(
    Expression<bool> Function($$MovimientosTableFilterComposer f) f,
  ) {
    final $$MovimientosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableFilterComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductosTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioCompra => $composableBuilder(
    column: $table.precioCompra,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioVenta => $composableBuilder(
    column: $table.precioVenta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pesoUnitarioKg => $composableBuilder(
    column: $table.pesoUnitarioKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get volumenUnitarioM3 => $composableBuilder(
    column: $table.volumenUnitarioM3,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stockMinimo => $composableBuilder(
    column: $table.stockMinimo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stockMaximo => $composableBuilder(
    column: $table.stockMaximo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marca => $composableBuilder(
    column: $table.marca,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gradoCalidad => $composableBuilder(
    column: $table.gradoCalidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normaTecnica => $composableBuilder(
    column: $table.normaTecnica,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiereAlmacenCubierto => $composableBuilder(
    column: $table.requiereAlmacenCubierto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get materialPeligroso => $composableBuilder(
    column: $table.materialPeligroso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagenUrl => $composableBuilder(
    column: $table.imagenUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fichaTecnicaUrl => $composableBuilder(
    column: $table.fichaTecnicaUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriasTableOrderingComposer get categoriaId {
    final $$CategoriasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableOrderingComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnidadesMedidaTableOrderingComposer get unidadMedidaId {
    final $$UnidadesMedidaTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unidadMedidaId,
      referencedTable: $db.unidadesMedida,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnidadesMedidaTableOrderingComposer(
            $db: $db,
            $table: $db.unidadesMedida,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProveedoresTableOrderingComposer get proveedorPrincipalId {
    final $$ProveedoresTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proveedorPrincipalId,
      referencedTable: $db.proveedores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProveedoresTableOrderingComposer(
            $db: $db,
            $table: $db.proveedores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<double> get precioCompra => $composableBuilder(
    column: $table.precioCompra,
    builder: (column) => column,
  );

  GeneratedColumn<double> get precioVenta => $composableBuilder(
    column: $table.precioVenta,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pesoUnitarioKg => $composableBuilder(
    column: $table.pesoUnitarioKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get volumenUnitarioM3 => $composableBuilder(
    column: $table.volumenUnitarioM3,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stockMinimo => $composableBuilder(
    column: $table.stockMinimo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stockMaximo => $composableBuilder(
    column: $table.stockMaximo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get marca =>
      $composableBuilder(column: $table.marca, builder: (column) => column);

  GeneratedColumn<String> get gradoCalidad => $composableBuilder(
    column: $table.gradoCalidad,
    builder: (column) => column,
  );

  GeneratedColumn<String> get normaTecnica => $composableBuilder(
    column: $table.normaTecnica,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get requiereAlmacenCubierto => $composableBuilder(
    column: $table.requiereAlmacenCubierto,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get materialPeligroso => $composableBuilder(
    column: $table.materialPeligroso,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagenUrl =>
      $composableBuilder(column: $table.imagenUrl, builder: (column) => column);

  GeneratedColumn<String> get fichaTecnicaUrl => $composableBuilder(
    column: $table.fichaTecnicaUrl,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSync =>
      $composableBuilder(column: $table.lastSync, builder: (column) => column);

  $$CategoriasTableAnnotationComposer get categoriaId {
    final $$CategoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnidadesMedidaTableAnnotationComposer get unidadMedidaId {
    final $$UnidadesMedidaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unidadMedidaId,
      referencedTable: $db.unidadesMedida,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnidadesMedidaTableAnnotationComposer(
            $db: $db,
            $table: $db.unidadesMedida,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProveedoresTableAnnotationComposer get proveedorPrincipalId {
    final $$ProveedoresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proveedorPrincipalId,
      referencedTable: $db.proveedores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProveedoresTableAnnotationComposer(
            $db: $db,
            $table: $db.proveedores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> lotesRefs<T extends Object>(
    Expression<T> Function($$LotesTableAnnotationComposer a) f,
  ) {
    final $$LotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lotes,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LotesTableAnnotationComposer(
            $db: $db,
            $table: $db.lotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> inventariosRefs<T extends Object>(
    Expression<T> Function($$InventariosTableAnnotationComposer a) f,
  ) {
    final $$InventariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventarios,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventariosTableAnnotationComposer(
            $db: $db,
            $table: $db.inventarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> movimientosRefs<T extends Object>(
    Expression<T> Function($$MovimientosTableAnnotationComposer a) f,
  ) {
    final $$MovimientosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableAnnotationComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductosTable,
          ProductoTable,
          $$ProductosTableFilterComposer,
          $$ProductosTableOrderingComposer,
          $$ProductosTableAnnotationComposer,
          $$ProductosTableCreateCompanionBuilder,
          $$ProductosTableUpdateCompanionBuilder,
          (ProductoTable, $$ProductosTableReferences),
          ProductoTable,
          PrefetchHooks Function({
            bool categoriaId,
            bool unidadMedidaId,
            bool proveedorPrincipalId,
            bool lotesRefs,
            bool inventariosRefs,
            bool movimientosRefs,
          })
        > {
  $$ProductosTableTableManager(_$AppDatabase db, $ProductosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<String?> descripcion = const Value.absent(),
                Value<String> categoriaId = const Value.absent(),
                Value<String> unidadMedidaId = const Value.absent(),
                Value<String?> proveedorPrincipalId = const Value.absent(),
                Value<double> precioCompra = const Value.absent(),
                Value<double> precioVenta = const Value.absent(),
                Value<double?> pesoUnitarioKg = const Value.absent(),
                Value<double?> volumenUnitarioM3 = const Value.absent(),
                Value<int> stockMinimo = const Value.absent(),
                Value<int> stockMaximo = const Value.absent(),
                Value<String?> marca = const Value.absent(),
                Value<String?> gradoCalidad = const Value.absent(),
                Value<String?> normaTecnica = const Value.absent(),
                Value<bool> requiereAlmacenCubierto = const Value.absent(),
                Value<bool> materialPeligroso = const Value.absent(),
                Value<String?> imagenUrl = const Value.absent(),
                Value<String?> fichaTecnicaUrl = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> syncId = const Value.absent(),
                Value<DateTime?> lastSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductosCompanion(
                id: id,
                nombre: nombre,
                codigo: codigo,
                descripcion: descripcion,
                categoriaId: categoriaId,
                unidadMedidaId: unidadMedidaId,
                proveedorPrincipalId: proveedorPrincipalId,
                precioCompra: precioCompra,
                precioVenta: precioVenta,
                pesoUnitarioKg: pesoUnitarioKg,
                volumenUnitarioM3: volumenUnitarioM3,
                stockMinimo: stockMinimo,
                stockMaximo: stockMaximo,
                marca: marca,
                gradoCalidad: gradoCalidad,
                normaTecnica: normaTecnica,
                requiereAlmacenCubierto: requiereAlmacenCubierto,
                materialPeligroso: materialPeligroso,
                imagenUrl: imagenUrl,
                fichaTecnicaUrl: fichaTecnicaUrl,
                activo: activo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncId: syncId,
                lastSync: lastSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                required String codigo,
                Value<String?> descripcion = const Value.absent(),
                required String categoriaId,
                required String unidadMedidaId,
                Value<String?> proveedorPrincipalId = const Value.absent(),
                Value<double> precioCompra = const Value.absent(),
                Value<double> precioVenta = const Value.absent(),
                Value<double?> pesoUnitarioKg = const Value.absent(),
                Value<double?> volumenUnitarioM3 = const Value.absent(),
                Value<int> stockMinimo = const Value.absent(),
                Value<int> stockMaximo = const Value.absent(),
                Value<String?> marca = const Value.absent(),
                Value<String?> gradoCalidad = const Value.absent(),
                Value<String?> normaTecnica = const Value.absent(),
                Value<bool> requiereAlmacenCubierto = const Value.absent(),
                Value<bool> materialPeligroso = const Value.absent(),
                Value<String?> imagenUrl = const Value.absent(),
                Value<String?> fichaTecnicaUrl = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> syncId = const Value.absent(),
                Value<DateTime?> lastSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductosCompanion.insert(
                id: id,
                nombre: nombre,
                codigo: codigo,
                descripcion: descripcion,
                categoriaId: categoriaId,
                unidadMedidaId: unidadMedidaId,
                proveedorPrincipalId: proveedorPrincipalId,
                precioCompra: precioCompra,
                precioVenta: precioVenta,
                pesoUnitarioKg: pesoUnitarioKg,
                volumenUnitarioM3: volumenUnitarioM3,
                stockMinimo: stockMinimo,
                stockMaximo: stockMaximo,
                marca: marca,
                gradoCalidad: gradoCalidad,
                normaTecnica: normaTecnica,
                requiereAlmacenCubierto: requiereAlmacenCubierto,
                materialPeligroso: materialPeligroso,
                imagenUrl: imagenUrl,
                fichaTecnicaUrl: fichaTecnicaUrl,
                activo: activo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncId: syncId,
                lastSync: lastSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoriaId = false,
                unidadMedidaId = false,
                proveedorPrincipalId = false,
                lotesRefs = false,
                inventariosRefs = false,
                movimientosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (lotesRefs) db.lotes,
                    if (inventariosRefs) db.inventarios,
                    if (movimientosRefs) db.movimientos,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
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
                        if (categoriaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoriaId,
                                    referencedTable: $$ProductosTableReferences
                                        ._categoriaIdTable(db),
                                    referencedColumn: $$ProductosTableReferences
                                        ._categoriaIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (unidadMedidaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.unidadMedidaId,
                                    referencedTable: $$ProductosTableReferences
                                        ._unidadMedidaIdTable(db),
                                    referencedColumn: $$ProductosTableReferences
                                        ._unidadMedidaIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (proveedorPrincipalId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.proveedorPrincipalId,
                                    referencedTable: $$ProductosTableReferences
                                        ._proveedorPrincipalIdTable(db),
                                    referencedColumn: $$ProductosTableReferences
                                        ._proveedorPrincipalIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (lotesRefs)
                        await $_getPrefetchedData<
                          ProductoTable,
                          $ProductosTable,
                          LoteTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProductosTableReferences
                              ._lotesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductosTableReferences(
                                db,
                                table,
                                p0,
                              ).lotesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (inventariosRefs)
                        await $_getPrefetchedData<
                          ProductoTable,
                          $ProductosTable,
                          InventarioTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProductosTableReferences
                              ._inventariosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductosTableReferences(
                                db,
                                table,
                                p0,
                              ).inventariosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (movimientosRefs)
                        await $_getPrefetchedData<
                          ProductoTable,
                          $ProductosTable,
                          MovimientoTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProductosTableReferences
                              ._movimientosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductosTableReferences(
                                db,
                                table,
                                p0,
                              ).movimientosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProductosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductosTable,
      ProductoTable,
      $$ProductosTableFilterComposer,
      $$ProductosTableOrderingComposer,
      $$ProductosTableAnnotationComposer,
      $$ProductosTableCreateCompanionBuilder,
      $$ProductosTableUpdateCompanionBuilder,
      (ProductoTable, $$ProductosTableReferences),
      ProductoTable,
      PrefetchHooks Function({
        bool categoriaId,
        bool unidadMedidaId,
        bool proveedorPrincipalId,
        bool lotesRefs,
        bool inventariosRefs,
        bool movimientosRefs,
      })
    >;
typedef $$LotesTableCreateCompanionBuilder =
    LotesCompanion Function({
      required String id,
      required String numeroLote,
      required String productoId,
      Value<DateTime?> fechaFabricacion,
      Value<DateTime?> fechaVencimiento,
      Value<String?> proveedorId,
      Value<String?> numeroFactura,
      Value<int> cantidadInicial,
      Value<int> cantidadActual,
      Value<String?> certificadoCalidadUrl,
      Value<String?> observaciones,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> syncId,
      Value<DateTime?> lastSync,
      Value<int> rowid,
    });
typedef $$LotesTableUpdateCompanionBuilder =
    LotesCompanion Function({
      Value<String> id,
      Value<String> numeroLote,
      Value<String> productoId,
      Value<DateTime?> fechaFabricacion,
      Value<DateTime?> fechaVencimiento,
      Value<String?> proveedorId,
      Value<String?> numeroFactura,
      Value<int> cantidadInicial,
      Value<int> cantidadActual,
      Value<String?> certificadoCalidadUrl,
      Value<String?> observaciones,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> syncId,
      Value<DateTime?> lastSync,
      Value<int> rowid,
    });

final class $$LotesTableReferences
    extends BaseReferences<_$AppDatabase, $LotesTable, LoteTable> {
  $$LotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductosTable _productoIdTable(_$AppDatabase db) => db.productos
      .createAlias($_aliasNameGenerator(db.lotes.productoId, db.productos.id));

  $$ProductosTableProcessedTableManager get productoId {
    final $_column = $_itemColumn<String>('producto_id')!;

    final manager = $$ProductosTableTableManager(
      $_db,
      $_db.productos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProveedoresTable _proveedorIdTable(_$AppDatabase db) =>
      db.proveedores.createAlias(
        $_aliasNameGenerator(db.lotes.proveedorId, db.proveedores.id),
      );

  $$ProveedoresTableProcessedTableManager? get proveedorId {
    final $_column = $_itemColumn<String>('proveedor_id');
    if ($_column == null) return null;
    final manager = $$ProveedoresTableTableManager(
      $_db,
      $_db.proveedores,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_proveedorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$InventariosTable, List<InventarioTable>>
  _inventariosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.inventarios,
    aliasName: $_aliasNameGenerator(db.lotes.id, db.inventarios.loteId),
  );

  $$InventariosTableProcessedTableManager get inventariosRefs {
    final manager = $$InventariosTableTableManager(
      $_db,
      $_db.inventarios,
    ).filter((f) => f.loteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_inventariosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MovimientosTable, List<MovimientoTable>>
  _movimientosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.movimientos,
    aliasName: $_aliasNameGenerator(db.lotes.id, db.movimientos.loteId),
  );

  $$MovimientosTableProcessedTableManager get movimientosRefs {
    final manager = $$MovimientosTableTableManager(
      $_db,
      $_db.movimientos,
    ).filter((f) => f.loteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_movimientosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LotesTableFilterComposer extends Composer<_$AppDatabase, $LotesTable> {
  $$LotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numeroLote => $composableBuilder(
    column: $table.numeroLote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaFabricacion => $composableBuilder(
    column: $table.fechaFabricacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaVencimiento => $composableBuilder(
    column: $table.fechaVencimiento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numeroFactura => $composableBuilder(
    column: $table.numeroFactura,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidadInicial => $composableBuilder(
    column: $table.cantidadInicial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidadActual => $composableBuilder(
    column: $table.cantidadActual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get certificadoCalidadUrl => $composableBuilder(
    column: $table.certificadoCalidadUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductosTableFilterComposer get productoId {
    final $$ProductosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableFilterComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProveedoresTableFilterComposer get proveedorId {
    final $$ProveedoresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proveedorId,
      referencedTable: $db.proveedores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProveedoresTableFilterComposer(
            $db: $db,
            $table: $db.proveedores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> inventariosRefs(
    Expression<bool> Function($$InventariosTableFilterComposer f) f,
  ) {
    final $$InventariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventarios,
      getReferencedColumn: (t) => t.loteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventariosTableFilterComposer(
            $db: $db,
            $table: $db.inventarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> movimientosRefs(
    Expression<bool> Function($$MovimientosTableFilterComposer f) f,
  ) {
    final $$MovimientosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.loteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableFilterComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LotesTableOrderingComposer
    extends Composer<_$AppDatabase, $LotesTable> {
  $$LotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numeroLote => $composableBuilder(
    column: $table.numeroLote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaFabricacion => $composableBuilder(
    column: $table.fechaFabricacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaVencimiento => $composableBuilder(
    column: $table.fechaVencimiento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numeroFactura => $composableBuilder(
    column: $table.numeroFactura,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidadInicial => $composableBuilder(
    column: $table.cantidadInicial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidadActual => $composableBuilder(
    column: $table.cantidadActual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get certificadoCalidadUrl => $composableBuilder(
    column: $table.certificadoCalidadUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductosTableOrderingComposer get productoId {
    final $$ProductosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableOrderingComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProveedoresTableOrderingComposer get proveedorId {
    final $$ProveedoresTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proveedorId,
      referencedTable: $db.proveedores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProveedoresTableOrderingComposer(
            $db: $db,
            $table: $db.proveedores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LotesTable> {
  $$LotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get numeroLote => $composableBuilder(
    column: $table.numeroLote,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaFabricacion => $composableBuilder(
    column: $table.fechaFabricacion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaVencimiento => $composableBuilder(
    column: $table.fechaVencimiento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get numeroFactura => $composableBuilder(
    column: $table.numeroFactura,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cantidadInicial => $composableBuilder(
    column: $table.cantidadInicial,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cantidadActual => $composableBuilder(
    column: $table.cantidadActual,
    builder: (column) => column,
  );

  GeneratedColumn<String> get certificadoCalidadUrl => $composableBuilder(
    column: $table.certificadoCalidadUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSync =>
      $composableBuilder(column: $table.lastSync, builder: (column) => column);

  $$ProductosTableAnnotationComposer get productoId {
    final $$ProductosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableAnnotationComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProveedoresTableAnnotationComposer get proveedorId {
    final $$ProveedoresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proveedorId,
      referencedTable: $db.proveedores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProveedoresTableAnnotationComposer(
            $db: $db,
            $table: $db.proveedores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> inventariosRefs<T extends Object>(
    Expression<T> Function($$InventariosTableAnnotationComposer a) f,
  ) {
    final $$InventariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventarios,
      getReferencedColumn: (t) => t.loteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventariosTableAnnotationComposer(
            $db: $db,
            $table: $db.inventarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> movimientosRefs<T extends Object>(
    Expression<T> Function($$MovimientosTableAnnotationComposer a) f,
  ) {
    final $$MovimientosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.loteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableAnnotationComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LotesTable,
          LoteTable,
          $$LotesTableFilterComposer,
          $$LotesTableOrderingComposer,
          $$LotesTableAnnotationComposer,
          $$LotesTableCreateCompanionBuilder,
          $$LotesTableUpdateCompanionBuilder,
          (LoteTable, $$LotesTableReferences),
          LoteTable,
          PrefetchHooks Function({
            bool productoId,
            bool proveedorId,
            bool inventariosRefs,
            bool movimientosRefs,
          })
        > {
  $$LotesTableTableManager(_$AppDatabase db, $LotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> numeroLote = const Value.absent(),
                Value<String> productoId = const Value.absent(),
                Value<DateTime?> fechaFabricacion = const Value.absent(),
                Value<DateTime?> fechaVencimiento = const Value.absent(),
                Value<String?> proveedorId = const Value.absent(),
                Value<String?> numeroFactura = const Value.absent(),
                Value<int> cantidadInicial = const Value.absent(),
                Value<int> cantidadActual = const Value.absent(),
                Value<String?> certificadoCalidadUrl = const Value.absent(),
                Value<String?> observaciones = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> syncId = const Value.absent(),
                Value<DateTime?> lastSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LotesCompanion(
                id: id,
                numeroLote: numeroLote,
                productoId: productoId,
                fechaFabricacion: fechaFabricacion,
                fechaVencimiento: fechaVencimiento,
                proveedorId: proveedorId,
                numeroFactura: numeroFactura,
                cantidadInicial: cantidadInicial,
                cantidadActual: cantidadActual,
                certificadoCalidadUrl: certificadoCalidadUrl,
                observaciones: observaciones,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncId: syncId,
                lastSync: lastSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String numeroLote,
                required String productoId,
                Value<DateTime?> fechaFabricacion = const Value.absent(),
                Value<DateTime?> fechaVencimiento = const Value.absent(),
                Value<String?> proveedorId = const Value.absent(),
                Value<String?> numeroFactura = const Value.absent(),
                Value<int> cantidadInicial = const Value.absent(),
                Value<int> cantidadActual = const Value.absent(),
                Value<String?> certificadoCalidadUrl = const Value.absent(),
                Value<String?> observaciones = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> syncId = const Value.absent(),
                Value<DateTime?> lastSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LotesCompanion.insert(
                id: id,
                numeroLote: numeroLote,
                productoId: productoId,
                fechaFabricacion: fechaFabricacion,
                fechaVencimiento: fechaVencimiento,
                proveedorId: proveedorId,
                numeroFactura: numeroFactura,
                cantidadInicial: cantidadInicial,
                cantidadActual: cantidadActual,
                certificadoCalidadUrl: certificadoCalidadUrl,
                observaciones: observaciones,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncId: syncId,
                lastSync: lastSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$LotesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                productoId = false,
                proveedorId = false,
                inventariosRefs = false,
                movimientosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (inventariosRefs) db.inventarios,
                    if (movimientosRefs) db.movimientos,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
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
                        if (productoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productoId,
                                    referencedTable: $$LotesTableReferences
                                        ._productoIdTable(db),
                                    referencedColumn: $$LotesTableReferences
                                        ._productoIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (proveedorId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.proveedorId,
                                    referencedTable: $$LotesTableReferences
                                        ._proveedorIdTable(db),
                                    referencedColumn: $$LotesTableReferences
                                        ._proveedorIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (inventariosRefs)
                        await $_getPrefetchedData<
                          LoteTable,
                          $LotesTable,
                          InventarioTable
                        >(
                          currentTable: table,
                          referencedTable: $$LotesTableReferences
                              ._inventariosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LotesTableReferences(
                                db,
                                table,
                                p0,
                              ).inventariosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.loteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (movimientosRefs)
                        await $_getPrefetchedData<
                          LoteTable,
                          $LotesTable,
                          MovimientoTable
                        >(
                          currentTable: table,
                          referencedTable: $$LotesTableReferences
                              ._movimientosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LotesTableReferences(
                                db,
                                table,
                                p0,
                              ).movimientosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.loteId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LotesTable,
      LoteTable,
      $$LotesTableFilterComposer,
      $$LotesTableOrderingComposer,
      $$LotesTableAnnotationComposer,
      $$LotesTableCreateCompanionBuilder,
      $$LotesTableUpdateCompanionBuilder,
      (LoteTable, $$LotesTableReferences),
      LoteTable,
      PrefetchHooks Function({
        bool productoId,
        bool proveedorId,
        bool inventariosRefs,
        bool movimientosRefs,
      })
    >;
typedef $$InventariosTableCreateCompanionBuilder =
    InventariosCompanion Function({
      required String id,
      required String productoId,
      required String almacenId,
      required String tiendaId,
      Value<String?> loteId,
      Value<int> cantidadActual,
      Value<int> cantidadReservada,
      Value<int> cantidadDisponible,
      Value<double> valorTotal,
      Value<String?> ubicacionFisica,
      Value<DateTime> ultimaActualizacion,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> syncId,
      Value<DateTime?> lastSync,
      Value<int> rowid,
    });
typedef $$InventariosTableUpdateCompanionBuilder =
    InventariosCompanion Function({
      Value<String> id,
      Value<String> productoId,
      Value<String> almacenId,
      Value<String> tiendaId,
      Value<String?> loteId,
      Value<int> cantidadActual,
      Value<int> cantidadReservada,
      Value<int> cantidadDisponible,
      Value<double> valorTotal,
      Value<String?> ubicacionFisica,
      Value<DateTime> ultimaActualizacion,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> syncId,
      Value<DateTime?> lastSync,
      Value<int> rowid,
    });

final class $$InventariosTableReferences
    extends BaseReferences<_$AppDatabase, $InventariosTable, InventarioTable> {
  $$InventariosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductosTable _productoIdTable(_$AppDatabase db) =>
      db.productos.createAlias(
        $_aliasNameGenerator(db.inventarios.productoId, db.productos.id),
      );

  $$ProductosTableProcessedTableManager get productoId {
    final $_column = $_itemColumn<String>('producto_id')!;

    final manager = $$ProductosTableTableManager(
      $_db,
      $_db.productos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AlmacenesTable _almacenIdTable(_$AppDatabase db) =>
      db.almacenes.createAlias(
        $_aliasNameGenerator(db.inventarios.almacenId, db.almacenes.id),
      );

  $$AlmacenesTableProcessedTableManager get almacenId {
    final $_column = $_itemColumn<String>('almacen_id')!;

    final manager = $$AlmacenesTableTableManager(
      $_db,
      $_db.almacenes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_almacenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TiendasTable _tiendaIdTable(_$AppDatabase db) =>
      db.tiendas.createAlias(
        $_aliasNameGenerator(db.inventarios.tiendaId, db.tiendas.id),
      );

  $$TiendasTableProcessedTableManager get tiendaId {
    final $_column = $_itemColumn<String>('tienda_id')!;

    final manager = $$TiendasTableTableManager(
      $_db,
      $_db.tiendas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tiendaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LotesTable _loteIdTable(_$AppDatabase db) => db.lotes.createAlias(
    $_aliasNameGenerator(db.inventarios.loteId, db.lotes.id),
  );

  $$LotesTableProcessedTableManager? get loteId {
    final $_column = $_itemColumn<String>('lote_id');
    if ($_column == null) return null;
    final manager = $$LotesTableTableManager(
      $_db,
      $_db.lotes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_loteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MovimientosTable, List<MovimientoTable>>
  _movimientosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.movimientos,
    aliasName: $_aliasNameGenerator(
      db.inventarios.id,
      db.movimientos.inventarioId,
    ),
  );

  $$MovimientosTableProcessedTableManager get movimientosRefs {
    final manager = $$MovimientosTableTableManager(
      $_db,
      $_db.movimientos,
    ).filter((f) => f.inventarioId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_movimientosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InventariosTableFilterComposer
    extends Composer<_$AppDatabase, $InventariosTable> {
  $$InventariosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidadActual => $composableBuilder(
    column: $table.cantidadActual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidadReservada => $composableBuilder(
    column: $table.cantidadReservada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidadDisponible => $composableBuilder(
    column: $table.cantidadDisponible,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valorTotal => $composableBuilder(
    column: $table.valorTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ubicacionFisica => $composableBuilder(
    column: $table.ubicacionFisica,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get ultimaActualizacion => $composableBuilder(
    column: $table.ultimaActualizacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductosTableFilterComposer get productoId {
    final $$ProductosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableFilterComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AlmacenesTableFilterComposer get almacenId {
    final $$AlmacenesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.almacenId,
      referencedTable: $db.almacenes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlmacenesTableFilterComposer(
            $db: $db,
            $table: $db.almacenes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TiendasTableFilterComposer get tiendaId {
    final $$TiendasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tiendaId,
      referencedTable: $db.tiendas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiendasTableFilterComposer(
            $db: $db,
            $table: $db.tiendas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LotesTableFilterComposer get loteId {
    final $$LotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loteId,
      referencedTable: $db.lotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LotesTableFilterComposer(
            $db: $db,
            $table: $db.lotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> movimientosRefs(
    Expression<bool> Function($$MovimientosTableFilterComposer f) f,
  ) {
    final $$MovimientosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.inventarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableFilterComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InventariosTableOrderingComposer
    extends Composer<_$AppDatabase, $InventariosTable> {
  $$InventariosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidadActual => $composableBuilder(
    column: $table.cantidadActual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidadReservada => $composableBuilder(
    column: $table.cantidadReservada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidadDisponible => $composableBuilder(
    column: $table.cantidadDisponible,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valorTotal => $composableBuilder(
    column: $table.valorTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ubicacionFisica => $composableBuilder(
    column: $table.ubicacionFisica,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get ultimaActualizacion => $composableBuilder(
    column: $table.ultimaActualizacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductosTableOrderingComposer get productoId {
    final $$ProductosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableOrderingComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AlmacenesTableOrderingComposer get almacenId {
    final $$AlmacenesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.almacenId,
      referencedTable: $db.almacenes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlmacenesTableOrderingComposer(
            $db: $db,
            $table: $db.almacenes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TiendasTableOrderingComposer get tiendaId {
    final $$TiendasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tiendaId,
      referencedTable: $db.tiendas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiendasTableOrderingComposer(
            $db: $db,
            $table: $db.tiendas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LotesTableOrderingComposer get loteId {
    final $$LotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loteId,
      referencedTable: $db.lotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LotesTableOrderingComposer(
            $db: $db,
            $table: $db.lotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventariosTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventariosTable> {
  $$InventariosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cantidadActual => $composableBuilder(
    column: $table.cantidadActual,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cantidadReservada => $composableBuilder(
    column: $table.cantidadReservada,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cantidadDisponible => $composableBuilder(
    column: $table.cantidadDisponible,
    builder: (column) => column,
  );

  GeneratedColumn<double> get valorTotal => $composableBuilder(
    column: $table.valorTotal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ubicacionFisica => $composableBuilder(
    column: $table.ubicacionFisica,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get ultimaActualizacion => $composableBuilder(
    column: $table.ultimaActualizacion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSync =>
      $composableBuilder(column: $table.lastSync, builder: (column) => column);

  $$ProductosTableAnnotationComposer get productoId {
    final $$ProductosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableAnnotationComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AlmacenesTableAnnotationComposer get almacenId {
    final $$AlmacenesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.almacenId,
      referencedTable: $db.almacenes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlmacenesTableAnnotationComposer(
            $db: $db,
            $table: $db.almacenes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TiendasTableAnnotationComposer get tiendaId {
    final $$TiendasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tiendaId,
      referencedTable: $db.tiendas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiendasTableAnnotationComposer(
            $db: $db,
            $table: $db.tiendas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LotesTableAnnotationComposer get loteId {
    final $$LotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loteId,
      referencedTable: $db.lotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LotesTableAnnotationComposer(
            $db: $db,
            $table: $db.lotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> movimientosRefs<T extends Object>(
    Expression<T> Function($$MovimientosTableAnnotationComposer a) f,
  ) {
    final $$MovimientosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.inventarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableAnnotationComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InventariosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventariosTable,
          InventarioTable,
          $$InventariosTableFilterComposer,
          $$InventariosTableOrderingComposer,
          $$InventariosTableAnnotationComposer,
          $$InventariosTableCreateCompanionBuilder,
          $$InventariosTableUpdateCompanionBuilder,
          (InventarioTable, $$InventariosTableReferences),
          InventarioTable,
          PrefetchHooks Function({
            bool productoId,
            bool almacenId,
            bool tiendaId,
            bool loteId,
            bool movimientosRefs,
          })
        > {
  $$InventariosTableTableManager(_$AppDatabase db, $InventariosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventariosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventariosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventariosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productoId = const Value.absent(),
                Value<String> almacenId = const Value.absent(),
                Value<String> tiendaId = const Value.absent(),
                Value<String?> loteId = const Value.absent(),
                Value<int> cantidadActual = const Value.absent(),
                Value<int> cantidadReservada = const Value.absent(),
                Value<int> cantidadDisponible = const Value.absent(),
                Value<double> valorTotal = const Value.absent(),
                Value<String?> ubicacionFisica = const Value.absent(),
                Value<DateTime> ultimaActualizacion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> syncId = const Value.absent(),
                Value<DateTime?> lastSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventariosCompanion(
                id: id,
                productoId: productoId,
                almacenId: almacenId,
                tiendaId: tiendaId,
                loteId: loteId,
                cantidadActual: cantidadActual,
                cantidadReservada: cantidadReservada,
                cantidadDisponible: cantidadDisponible,
                valorTotal: valorTotal,
                ubicacionFisica: ubicacionFisica,
                ultimaActualizacion: ultimaActualizacion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncId: syncId,
                lastSync: lastSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productoId,
                required String almacenId,
                required String tiendaId,
                Value<String?> loteId = const Value.absent(),
                Value<int> cantidadActual = const Value.absent(),
                Value<int> cantidadReservada = const Value.absent(),
                Value<int> cantidadDisponible = const Value.absent(),
                Value<double> valorTotal = const Value.absent(),
                Value<String?> ubicacionFisica = const Value.absent(),
                Value<DateTime> ultimaActualizacion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> syncId = const Value.absent(),
                Value<DateTime?> lastSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventariosCompanion.insert(
                id: id,
                productoId: productoId,
                almacenId: almacenId,
                tiendaId: tiendaId,
                loteId: loteId,
                cantidadActual: cantidadActual,
                cantidadReservada: cantidadReservada,
                cantidadDisponible: cantidadDisponible,
                valorTotal: valorTotal,
                ubicacionFisica: ubicacionFisica,
                ultimaActualizacion: ultimaActualizacion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncId: syncId,
                lastSync: lastSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InventariosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                productoId = false,
                almacenId = false,
                tiendaId = false,
                loteId = false,
                movimientosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (movimientosRefs) db.movimientos,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
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
                        if (productoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productoId,
                                    referencedTable:
                                        $$InventariosTableReferences
                                            ._productoIdTable(db),
                                    referencedColumn:
                                        $$InventariosTableReferences
                                            ._productoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (almacenId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.almacenId,
                                    referencedTable:
                                        $$InventariosTableReferences
                                            ._almacenIdTable(db),
                                    referencedColumn:
                                        $$InventariosTableReferences
                                            ._almacenIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (tiendaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tiendaId,
                                    referencedTable:
                                        $$InventariosTableReferences
                                            ._tiendaIdTable(db),
                                    referencedColumn:
                                        $$InventariosTableReferences
                                            ._tiendaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (loteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.loteId,
                                    referencedTable:
                                        $$InventariosTableReferences
                                            ._loteIdTable(db),
                                    referencedColumn:
                                        $$InventariosTableReferences
                                            ._loteIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (movimientosRefs)
                        await $_getPrefetchedData<
                          InventarioTable,
                          $InventariosTable,
                          MovimientoTable
                        >(
                          currentTable: table,
                          referencedTable: $$InventariosTableReferences
                              ._movimientosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InventariosTableReferences(
                                db,
                                table,
                                p0,
                              ).movimientosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.inventarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$InventariosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventariosTable,
      InventarioTable,
      $$InventariosTableFilterComposer,
      $$InventariosTableOrderingComposer,
      $$InventariosTableAnnotationComposer,
      $$InventariosTableCreateCompanionBuilder,
      $$InventariosTableUpdateCompanionBuilder,
      (InventarioTable, $$InventariosTableReferences),
      InventarioTable,
      PrefetchHooks Function({
        bool productoId,
        bool almacenId,
        bool tiendaId,
        bool loteId,
        bool movimientosRefs,
      })
    >;
typedef $$MovimientosTableCreateCompanionBuilder =
    MovimientosCompanion Function({
      required String id,
      required String numeroMovimiento,
      required String productoId,
      required String inventarioId,
      Value<String?> loteId,
      Value<String?> tiendaOrigenId,
      Value<String?> tiendaDestinoId,
      Value<String?> proveedorId,
      required String tipo,
      Value<String?> motivo,
      required int cantidad,
      Value<double> costoUnitario,
      Value<double> costoTotal,
      Value<double?> pesoTotalKg,
      required String usuarioId,
      required String estado,
      Value<DateTime> fechaMovimiento,
      Value<String?> numeroFactura,
      Value<String?> numeroGuiaRemision,
      Value<String?> vehiculoPlaca,
      Value<String?> conductor,
      Value<String?> observaciones,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> syncId,
      Value<DateTime?> lastSync,
      Value<bool> sincronizado,
      Value<int> rowid,
    });
typedef $$MovimientosTableUpdateCompanionBuilder =
    MovimientosCompanion Function({
      Value<String> id,
      Value<String> numeroMovimiento,
      Value<String> productoId,
      Value<String> inventarioId,
      Value<String?> loteId,
      Value<String?> tiendaOrigenId,
      Value<String?> tiendaDestinoId,
      Value<String?> proveedorId,
      Value<String> tipo,
      Value<String?> motivo,
      Value<int> cantidad,
      Value<double> costoUnitario,
      Value<double> costoTotal,
      Value<double?> pesoTotalKg,
      Value<String> usuarioId,
      Value<String> estado,
      Value<DateTime> fechaMovimiento,
      Value<String?> numeroFactura,
      Value<String?> numeroGuiaRemision,
      Value<String?> vehiculoPlaca,
      Value<String?> conductor,
      Value<String?> observaciones,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> syncId,
      Value<DateTime?> lastSync,
      Value<bool> sincronizado,
      Value<int> rowid,
    });

final class $$MovimientosTableReferences
    extends BaseReferences<_$AppDatabase, $MovimientosTable, MovimientoTable> {
  $$MovimientosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductosTable _productoIdTable(_$AppDatabase db) =>
      db.productos.createAlias(
        $_aliasNameGenerator(db.movimientos.productoId, db.productos.id),
      );

  $$ProductosTableProcessedTableManager get productoId {
    final $_column = $_itemColumn<String>('producto_id')!;

    final manager = $$ProductosTableTableManager(
      $_db,
      $_db.productos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $InventariosTable _inventarioIdTable(_$AppDatabase db) =>
      db.inventarios.createAlias(
        $_aliasNameGenerator(db.movimientos.inventarioId, db.inventarios.id),
      );

  $$InventariosTableProcessedTableManager get inventarioId {
    final $_column = $_itemColumn<String>('inventario_id')!;

    final manager = $$InventariosTableTableManager(
      $_db,
      $_db.inventarios,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_inventarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LotesTable _loteIdTable(_$AppDatabase db) => db.lotes.createAlias(
    $_aliasNameGenerator(db.movimientos.loteId, db.lotes.id),
  );

  $$LotesTableProcessedTableManager? get loteId {
    final $_column = $_itemColumn<String>('lote_id');
    if ($_column == null) return null;
    final manager = $$LotesTableTableManager(
      $_db,
      $_db.lotes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_loteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TiendasTable _tiendaOrigenIdTable(_$AppDatabase db) =>
      db.tiendas.createAlias(
        $_aliasNameGenerator(db.movimientos.tiendaOrigenId, db.tiendas.id),
      );

  $$TiendasTableProcessedTableManager? get tiendaOrigenId {
    final $_column = $_itemColumn<String>('tienda_origen_id');
    if ($_column == null) return null;
    final manager = $$TiendasTableTableManager(
      $_db,
      $_db.tiendas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tiendaOrigenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TiendasTable _tiendaDestinoIdTable(_$AppDatabase db) =>
      db.tiendas.createAlias(
        $_aliasNameGenerator(db.movimientos.tiendaDestinoId, db.tiendas.id),
      );

  $$TiendasTableProcessedTableManager? get tiendaDestinoId {
    final $_column = $_itemColumn<String>('tienda_destino_id');
    if ($_column == null) return null;
    final manager = $$TiendasTableTableManager(
      $_db,
      $_db.tiendas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tiendaDestinoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProveedoresTable _proveedorIdTable(_$AppDatabase db) =>
      db.proveedores.createAlias(
        $_aliasNameGenerator(db.movimientos.proveedorId, db.proveedores.id),
      );

  $$ProveedoresTableProcessedTableManager? get proveedorId {
    final $_column = $_itemColumn<String>('proveedor_id');
    if ($_column == null) return null;
    final manager = $$ProveedoresTableTableManager(
      $_db,
      $_db.proveedores,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_proveedorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsuariosTable _usuarioIdTable(_$AppDatabase db) =>
      db.usuarios.createAlias(
        $_aliasNameGenerator(db.movimientos.usuarioId, db.usuarios.id),
      );

  $$UsuariosTableProcessedTableManager get usuarioId {
    final $_column = $_itemColumn<String>('usuario_id')!;

    final manager = $$UsuariosTableTableManager(
      $_db,
      $_db.usuarios,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MovimientosTableFilterComposer
    extends Composer<_$AppDatabase, $MovimientosTable> {
  $$MovimientosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numeroMovimiento => $composableBuilder(
    column: $table.numeroMovimiento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motivo => $composableBuilder(
    column: $table.motivo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get costoUnitario => $composableBuilder(
    column: $table.costoUnitario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get costoTotal => $composableBuilder(
    column: $table.costoTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pesoTotalKg => $composableBuilder(
    column: $table.pesoTotalKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaMovimiento => $composableBuilder(
    column: $table.fechaMovimiento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numeroFactura => $composableBuilder(
    column: $table.numeroFactura,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numeroGuiaRemision => $composableBuilder(
    column: $table.numeroGuiaRemision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehiculoPlaca => $composableBuilder(
    column: $table.vehiculoPlaca,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conductor => $composableBuilder(
    column: $table.conductor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sincronizado => $composableBuilder(
    column: $table.sincronizado,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductosTableFilterComposer get productoId {
    final $$ProductosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableFilterComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InventariosTableFilterComposer get inventarioId {
    final $$InventariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inventarioId,
      referencedTable: $db.inventarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventariosTableFilterComposer(
            $db: $db,
            $table: $db.inventarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LotesTableFilterComposer get loteId {
    final $$LotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loteId,
      referencedTable: $db.lotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LotesTableFilterComposer(
            $db: $db,
            $table: $db.lotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TiendasTableFilterComposer get tiendaOrigenId {
    final $$TiendasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tiendaOrigenId,
      referencedTable: $db.tiendas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiendasTableFilterComposer(
            $db: $db,
            $table: $db.tiendas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TiendasTableFilterComposer get tiendaDestinoId {
    final $$TiendasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tiendaDestinoId,
      referencedTable: $db.tiendas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiendasTableFilterComposer(
            $db: $db,
            $table: $db.tiendas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProveedoresTableFilterComposer get proveedorId {
    final $$ProveedoresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proveedorId,
      referencedTable: $db.proveedores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProveedoresTableFilterComposer(
            $db: $db,
            $table: $db.proveedores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsuariosTableFilterComposer get usuarioId {
    final $$UsuariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableFilterComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosTableOrderingComposer
    extends Composer<_$AppDatabase, $MovimientosTable> {
  $$MovimientosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numeroMovimiento => $composableBuilder(
    column: $table.numeroMovimiento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motivo => $composableBuilder(
    column: $table.motivo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get costoUnitario => $composableBuilder(
    column: $table.costoUnitario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get costoTotal => $composableBuilder(
    column: $table.costoTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pesoTotalKg => $composableBuilder(
    column: $table.pesoTotalKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaMovimiento => $composableBuilder(
    column: $table.fechaMovimiento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numeroFactura => $composableBuilder(
    column: $table.numeroFactura,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numeroGuiaRemision => $composableBuilder(
    column: $table.numeroGuiaRemision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehiculoPlaca => $composableBuilder(
    column: $table.vehiculoPlaca,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conductor => $composableBuilder(
    column: $table.conductor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sincronizado => $composableBuilder(
    column: $table.sincronizado,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductosTableOrderingComposer get productoId {
    final $$ProductosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableOrderingComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InventariosTableOrderingComposer get inventarioId {
    final $$InventariosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inventarioId,
      referencedTable: $db.inventarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventariosTableOrderingComposer(
            $db: $db,
            $table: $db.inventarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LotesTableOrderingComposer get loteId {
    final $$LotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loteId,
      referencedTable: $db.lotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LotesTableOrderingComposer(
            $db: $db,
            $table: $db.lotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TiendasTableOrderingComposer get tiendaOrigenId {
    final $$TiendasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tiendaOrigenId,
      referencedTable: $db.tiendas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiendasTableOrderingComposer(
            $db: $db,
            $table: $db.tiendas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TiendasTableOrderingComposer get tiendaDestinoId {
    final $$TiendasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tiendaDestinoId,
      referencedTable: $db.tiendas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiendasTableOrderingComposer(
            $db: $db,
            $table: $db.tiendas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProveedoresTableOrderingComposer get proveedorId {
    final $$ProveedoresTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proveedorId,
      referencedTable: $db.proveedores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProveedoresTableOrderingComposer(
            $db: $db,
            $table: $db.proveedores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsuariosTableOrderingComposer get usuarioId {
    final $$UsuariosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableOrderingComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosTableAnnotationComposer
    extends Composer<_$AppDatabase, $MovimientosTable> {
  $$MovimientosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get numeroMovimiento => $composableBuilder(
    column: $table.numeroMovimiento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get motivo =>
      $composableBuilder(column: $table.motivo, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get costoUnitario => $composableBuilder(
    column: $table.costoUnitario,
    builder: (column) => column,
  );

  GeneratedColumn<double> get costoTotal => $composableBuilder(
    column: $table.costoTotal,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pesoTotalKg => $composableBuilder(
    column: $table.pesoTotalKg,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaMovimiento => $composableBuilder(
    column: $table.fechaMovimiento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get numeroFactura => $composableBuilder(
    column: $table.numeroFactura,
    builder: (column) => column,
  );

  GeneratedColumn<String> get numeroGuiaRemision => $composableBuilder(
    column: $table.numeroGuiaRemision,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vehiculoPlaca => $composableBuilder(
    column: $table.vehiculoPlaca,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conductor =>
      $composableBuilder(column: $table.conductor, builder: (column) => column);

  GeneratedColumn<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSync =>
      $composableBuilder(column: $table.lastSync, builder: (column) => column);

  GeneratedColumn<bool> get sincronizado => $composableBuilder(
    column: $table.sincronizado,
    builder: (column) => column,
  );

  $$ProductosTableAnnotationComposer get productoId {
    final $$ProductosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableAnnotationComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InventariosTableAnnotationComposer get inventarioId {
    final $$InventariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inventarioId,
      referencedTable: $db.inventarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventariosTableAnnotationComposer(
            $db: $db,
            $table: $db.inventarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LotesTableAnnotationComposer get loteId {
    final $$LotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loteId,
      referencedTable: $db.lotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LotesTableAnnotationComposer(
            $db: $db,
            $table: $db.lotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TiendasTableAnnotationComposer get tiendaOrigenId {
    final $$TiendasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tiendaOrigenId,
      referencedTable: $db.tiendas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiendasTableAnnotationComposer(
            $db: $db,
            $table: $db.tiendas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TiendasTableAnnotationComposer get tiendaDestinoId {
    final $$TiendasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tiendaDestinoId,
      referencedTable: $db.tiendas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiendasTableAnnotationComposer(
            $db: $db,
            $table: $db.tiendas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProveedoresTableAnnotationComposer get proveedorId {
    final $$ProveedoresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proveedorId,
      referencedTable: $db.proveedores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProveedoresTableAnnotationComposer(
            $db: $db,
            $table: $db.proveedores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsuariosTableAnnotationComposer get usuarioId {
    final $$UsuariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableAnnotationComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MovimientosTable,
          MovimientoTable,
          $$MovimientosTableFilterComposer,
          $$MovimientosTableOrderingComposer,
          $$MovimientosTableAnnotationComposer,
          $$MovimientosTableCreateCompanionBuilder,
          $$MovimientosTableUpdateCompanionBuilder,
          (MovimientoTable, $$MovimientosTableReferences),
          MovimientoTable,
          PrefetchHooks Function({
            bool productoId,
            bool inventarioId,
            bool loteId,
            bool tiendaOrigenId,
            bool tiendaDestinoId,
            bool proveedorId,
            bool usuarioId,
          })
        > {
  $$MovimientosTableTableManager(_$AppDatabase db, $MovimientosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovimientosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MovimientosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MovimientosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> numeroMovimiento = const Value.absent(),
                Value<String> productoId = const Value.absent(),
                Value<String> inventarioId = const Value.absent(),
                Value<String?> loteId = const Value.absent(),
                Value<String?> tiendaOrigenId = const Value.absent(),
                Value<String?> tiendaDestinoId = const Value.absent(),
                Value<String?> proveedorId = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String?> motivo = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<double> costoUnitario = const Value.absent(),
                Value<double> costoTotal = const Value.absent(),
                Value<double?> pesoTotalKg = const Value.absent(),
                Value<String> usuarioId = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<DateTime> fechaMovimiento = const Value.absent(),
                Value<String?> numeroFactura = const Value.absent(),
                Value<String?> numeroGuiaRemision = const Value.absent(),
                Value<String?> vehiculoPlaca = const Value.absent(),
                Value<String?> conductor = const Value.absent(),
                Value<String?> observaciones = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> syncId = const Value.absent(),
                Value<DateTime?> lastSync = const Value.absent(),
                Value<bool> sincronizado = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MovimientosCompanion(
                id: id,
                numeroMovimiento: numeroMovimiento,
                productoId: productoId,
                inventarioId: inventarioId,
                loteId: loteId,
                tiendaOrigenId: tiendaOrigenId,
                tiendaDestinoId: tiendaDestinoId,
                proveedorId: proveedorId,
                tipo: tipo,
                motivo: motivo,
                cantidad: cantidad,
                costoUnitario: costoUnitario,
                costoTotal: costoTotal,
                pesoTotalKg: pesoTotalKg,
                usuarioId: usuarioId,
                estado: estado,
                fechaMovimiento: fechaMovimiento,
                numeroFactura: numeroFactura,
                numeroGuiaRemision: numeroGuiaRemision,
                vehiculoPlaca: vehiculoPlaca,
                conductor: conductor,
                observaciones: observaciones,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncId: syncId,
                lastSync: lastSync,
                sincronizado: sincronizado,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String numeroMovimiento,
                required String productoId,
                required String inventarioId,
                Value<String?> loteId = const Value.absent(),
                Value<String?> tiendaOrigenId = const Value.absent(),
                Value<String?> tiendaDestinoId = const Value.absent(),
                Value<String?> proveedorId = const Value.absent(),
                required String tipo,
                Value<String?> motivo = const Value.absent(),
                required int cantidad,
                Value<double> costoUnitario = const Value.absent(),
                Value<double> costoTotal = const Value.absent(),
                Value<double?> pesoTotalKg = const Value.absent(),
                required String usuarioId,
                required String estado,
                Value<DateTime> fechaMovimiento = const Value.absent(),
                Value<String?> numeroFactura = const Value.absent(),
                Value<String?> numeroGuiaRemision = const Value.absent(),
                Value<String?> vehiculoPlaca = const Value.absent(),
                Value<String?> conductor = const Value.absent(),
                Value<String?> observaciones = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> syncId = const Value.absent(),
                Value<DateTime?> lastSync = const Value.absent(),
                Value<bool> sincronizado = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MovimientosCompanion.insert(
                id: id,
                numeroMovimiento: numeroMovimiento,
                productoId: productoId,
                inventarioId: inventarioId,
                loteId: loteId,
                tiendaOrigenId: tiendaOrigenId,
                tiendaDestinoId: tiendaDestinoId,
                proveedorId: proveedorId,
                tipo: tipo,
                motivo: motivo,
                cantidad: cantidad,
                costoUnitario: costoUnitario,
                costoTotal: costoTotal,
                pesoTotalKg: pesoTotalKg,
                usuarioId: usuarioId,
                estado: estado,
                fechaMovimiento: fechaMovimiento,
                numeroFactura: numeroFactura,
                numeroGuiaRemision: numeroGuiaRemision,
                vehiculoPlaca: vehiculoPlaca,
                conductor: conductor,
                observaciones: observaciones,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncId: syncId,
                lastSync: lastSync,
                sincronizado: sincronizado,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MovimientosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                productoId = false,
                inventarioId = false,
                loteId = false,
                tiendaOrigenId = false,
                tiendaDestinoId = false,
                proveedorId = false,
                usuarioId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
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
                        if (productoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productoId,
                                    referencedTable:
                                        $$MovimientosTableReferences
                                            ._productoIdTable(db),
                                    referencedColumn:
                                        $$MovimientosTableReferences
                                            ._productoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (inventarioId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.inventarioId,
                                    referencedTable:
                                        $$MovimientosTableReferences
                                            ._inventarioIdTable(db),
                                    referencedColumn:
                                        $$MovimientosTableReferences
                                            ._inventarioIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (loteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.loteId,
                                    referencedTable:
                                        $$MovimientosTableReferences
                                            ._loteIdTable(db),
                                    referencedColumn:
                                        $$MovimientosTableReferences
                                            ._loteIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (tiendaOrigenId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tiendaOrigenId,
                                    referencedTable:
                                        $$MovimientosTableReferences
                                            ._tiendaOrigenIdTable(db),
                                    referencedColumn:
                                        $$MovimientosTableReferences
                                            ._tiendaOrigenIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (tiendaDestinoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tiendaDestinoId,
                                    referencedTable:
                                        $$MovimientosTableReferences
                                            ._tiendaDestinoIdTable(db),
                                    referencedColumn:
                                        $$MovimientosTableReferences
                                            ._tiendaDestinoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (proveedorId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.proveedorId,
                                    referencedTable:
                                        $$MovimientosTableReferences
                                            ._proveedorIdTable(db),
                                    referencedColumn:
                                        $$MovimientosTableReferences
                                            ._proveedorIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (usuarioId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.usuarioId,
                                    referencedTable:
                                        $$MovimientosTableReferences
                                            ._usuarioIdTable(db),
                                    referencedColumn:
                                        $$MovimientosTableReferences
                                            ._usuarioIdTable(db)
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

typedef $$MovimientosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MovimientosTable,
      MovimientoTable,
      $$MovimientosTableFilterComposer,
      $$MovimientosTableOrderingComposer,
      $$MovimientosTableAnnotationComposer,
      $$MovimientosTableCreateCompanionBuilder,
      $$MovimientosTableUpdateCompanionBuilder,
      (MovimientoTable, $$MovimientosTableReferences),
      MovimientoTable,
      PrefetchHooks Function({
        bool productoId,
        bool inventarioId,
        bool loteId,
        bool tiendaOrigenId,
        bool tiendaDestinoId,
        bool proveedorId,
        bool usuarioId,
      })
    >;
typedef $$AuditoriasTableCreateCompanionBuilder =
    AuditoriasCompanion Function({
      required String id,
      required String usuarioId,
      required String tablaAfectada,
      required String accion,
      Value<String?> datosAnteriores,
      Value<String?> datosNuevos,
      Value<String?> ipAddress,
      Value<String?> dispositivo,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$AuditoriasTableUpdateCompanionBuilder =
    AuditoriasCompanion Function({
      Value<String> id,
      Value<String> usuarioId,
      Value<String> tablaAfectada,
      Value<String> accion,
      Value<String?> datosAnteriores,
      Value<String?> datosNuevos,
      Value<String?> ipAddress,
      Value<String?> dispositivo,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$AuditoriasTableReferences
    extends BaseReferences<_$AppDatabase, $AuditoriasTable, AuditoriaTable> {
  $$AuditoriasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsuariosTable _usuarioIdTable(_$AppDatabase db) =>
      db.usuarios.createAlias(
        $_aliasNameGenerator(db.auditorias.usuarioId, db.usuarios.id),
      );

  $$UsuariosTableProcessedTableManager get usuarioId {
    final $_column = $_itemColumn<String>('usuario_id')!;

    final manager = $$UsuariosTableTableManager(
      $_db,
      $_db.usuarios,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AuditoriasTableFilterComposer
    extends Composer<_$AppDatabase, $AuditoriasTable> {
  $$AuditoriasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tablaAfectada => $composableBuilder(
    column: $table.tablaAfectada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accion => $composableBuilder(
    column: $table.accion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datosAnteriores => $composableBuilder(
    column: $table.datosAnteriores,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datosNuevos => $composableBuilder(
    column: $table.datosNuevos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ipAddress => $composableBuilder(
    column: $table.ipAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dispositivo => $composableBuilder(
    column: $table.dispositivo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsuariosTableFilterComposer get usuarioId {
    final $$UsuariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableFilterComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AuditoriasTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditoriasTable> {
  $$AuditoriasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tablaAfectada => $composableBuilder(
    column: $table.tablaAfectada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accion => $composableBuilder(
    column: $table.accion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datosAnteriores => $composableBuilder(
    column: $table.datosAnteriores,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datosNuevos => $composableBuilder(
    column: $table.datosNuevos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ipAddress => $composableBuilder(
    column: $table.ipAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dispositivo => $composableBuilder(
    column: $table.dispositivo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsuariosTableOrderingComposer get usuarioId {
    final $$UsuariosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableOrderingComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AuditoriasTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditoriasTable> {
  $$AuditoriasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tablaAfectada => $composableBuilder(
    column: $table.tablaAfectada,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accion =>
      $composableBuilder(column: $table.accion, builder: (column) => column);

  GeneratedColumn<String> get datosAnteriores => $composableBuilder(
    column: $table.datosAnteriores,
    builder: (column) => column,
  );

  GeneratedColumn<String> get datosNuevos => $composableBuilder(
    column: $table.datosNuevos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ipAddress =>
      $composableBuilder(column: $table.ipAddress, builder: (column) => column);

  GeneratedColumn<String> get dispositivo => $composableBuilder(
    column: $table.dispositivo,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsuariosTableAnnotationComposer get usuarioId {
    final $$UsuariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableAnnotationComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AuditoriasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditoriasTable,
          AuditoriaTable,
          $$AuditoriasTableFilterComposer,
          $$AuditoriasTableOrderingComposer,
          $$AuditoriasTableAnnotationComposer,
          $$AuditoriasTableCreateCompanionBuilder,
          $$AuditoriasTableUpdateCompanionBuilder,
          (AuditoriaTable, $$AuditoriasTableReferences),
          AuditoriaTable,
          PrefetchHooks Function({bool usuarioId})
        > {
  $$AuditoriasTableTableManager(_$AppDatabase db, $AuditoriasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditoriasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditoriasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditoriasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> usuarioId = const Value.absent(),
                Value<String> tablaAfectada = const Value.absent(),
                Value<String> accion = const Value.absent(),
                Value<String?> datosAnteriores = const Value.absent(),
                Value<String?> datosNuevos = const Value.absent(),
                Value<String?> ipAddress = const Value.absent(),
                Value<String?> dispositivo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditoriasCompanion(
                id: id,
                usuarioId: usuarioId,
                tablaAfectada: tablaAfectada,
                accion: accion,
                datosAnteriores: datosAnteriores,
                datosNuevos: datosNuevos,
                ipAddress: ipAddress,
                dispositivo: dispositivo,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String usuarioId,
                required String tablaAfectada,
                required String accion,
                Value<String?> datosAnteriores = const Value.absent(),
                Value<String?> datosNuevos = const Value.absent(),
                Value<String?> ipAddress = const Value.absent(),
                Value<String?> dispositivo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditoriasCompanion.insert(
                id: id,
                usuarioId: usuarioId,
                tablaAfectada: tablaAfectada,
                accion: accion,
                datosAnteriores: datosAnteriores,
                datosNuevos: datosNuevos,
                ipAddress: ipAddress,
                dispositivo: dispositivo,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AuditoriasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({usuarioId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
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
                    if (usuarioId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.usuarioId,
                                referencedTable: $$AuditoriasTableReferences
                                    ._usuarioIdTable(db),
                                referencedColumn: $$AuditoriasTableReferences
                                    ._usuarioIdTable(db)
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

typedef $$AuditoriasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditoriasTable,
      AuditoriaTable,
      $$AuditoriasTableFilterComposer,
      $$AuditoriasTableOrderingComposer,
      $$AuditoriasTableAnnotationComposer,
      $$AuditoriasTableCreateCompanionBuilder,
      $$AuditoriasTableUpdateCompanionBuilder,
      (AuditoriaTable, $$AuditoriasTableReferences),
      AuditoriaTable,
      PrefetchHooks Function({bool usuarioId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TiendasTableTableManager get tiendas =>
      $$TiendasTableTableManager(_db, _db.tiendas);
  $$RolesTableTableManager get roles =>
      $$RolesTableTableManager(_db, _db.roles);
  $$UsuariosTableTableManager get usuarios =>
      $$UsuariosTableTableManager(_db, _db.usuarios);
  $$AlmacenesTableTableManager get almacenes =>
      $$AlmacenesTableTableManager(_db, _db.almacenes);
  $$CategoriasTableTableManager get categorias =>
      $$CategoriasTableTableManager(_db, _db.categorias);
  $$UnidadesMedidaTableTableManager get unidadesMedida =>
      $$UnidadesMedidaTableTableManager(_db, _db.unidadesMedida);
  $$ProveedoresTableTableManager get proveedores =>
      $$ProveedoresTableTableManager(_db, _db.proveedores);
  $$ProductosTableTableManager get productos =>
      $$ProductosTableTableManager(_db, _db.productos);
  $$LotesTableTableManager get lotes =>
      $$LotesTableTableManager(_db, _db.lotes);
  $$InventariosTableTableManager get inventarios =>
      $$InventariosTableTableManager(_db, _db.inventarios);
  $$MovimientosTableTableManager get movimientos =>
      $$MovimientosTableTableManager(_db, _db.movimientos);
  $$AuditoriasTableTableManager get auditorias =>
      $$AuditoriasTableTableManager(_db, _db.auditorias);
}
