import 'package:equatable/equatable.dart';

/// Modelo de datos para Tienda
class TiendaModel extends Equatable {
  final String id;
  final String nombre;
  final String codigo;
  final String? direccion;
  final String? ciudad;
  final String? departamento;
  final String? telefono;
  final String? horarioAtencion;
  final bool activo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? syncId;
  final DateTime? lastSync;

  const TiendaModel({
    required this.id,
    required this.nombre,
    required this.codigo,
    this.direccion,
    this.ciudad,
    this.departamento,
    this.telefono,
    this.horarioAtencion,
    required this.activo,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.syncId,
    this.lastSync,
  });

  factory TiendaModel.fromJson(Map<String, dynamic> json) {
    return TiendaModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      codigo: json['codigo'] as String,
      direccion: json['direccion'] as String?,
      ciudad: json['ciudad'] as String?,
      departamento: json['departamento'] as String?,
      telefono: json['telefono'] as String?,
      horarioAtencion: json['horario_atencion'] as String?,
      activo: json['activo'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
      syncId: json['sync_id'] as String?,
      lastSync: json['last_sync'] != null
          ? DateTime.parse(json['last_sync'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'codigo': codigo,
      'direccion': direccion,
      'ciudad': ciudad,
      'departamento': departamento,
      'telefono': telefono,
      'horario_atencion': horarioAtencion,
      'activo': activo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'sync_id': syncId,
      'last_sync': lastSync?.toIso8601String(),
    };
  }

  TiendaModel copyWith({
    String? id,
    String? nombre,
    String? codigo,
    String? direccion,
    String? ciudad,
    String? departamento,
    String? telefono,
    String? horarioAtencion,
    bool? activo,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? syncId,
    DateTime? lastSync,
  }) {
    return TiendaModel(
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
    );
  }

  @override
  List<Object?> get props => [
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
  String toString() => 'TiendaModel(id: $id, nombre: $nombre, codigo: $codigo)';
}
