import 'package:equatable/equatable.dart';

/// Modelo de datos para Almacen
class AlmacenModel extends Equatable {
  final String id;
  final String nombre;
  final String codigo;
  final String tiendaId;
  final String? ubicacion;
  final String tipo; // Principal, Obra, Transito
  final double? capacidadM3;
  final double? areaM2;
  final bool activo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? syncId;
  final DateTime? lastSync;

  const AlmacenModel({
    required this.id,
    required this.nombre,
    required this.codigo,
    required this.tiendaId,
    this.ubicacion,
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

  factory AlmacenModel.fromJson(Map<String, dynamic> json) {
    return AlmacenModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      codigo: json['codigo'] as String,
      tiendaId: json['tienda_id'] as String,
      ubicacion: json['ubicacion'] as String?,
      tipo: json['tipo'] as String,
      capacidadM3: json['capacidad_m3'] != null
          ? (json['capacidad_m3'] as num).toDouble()
          : null,
      areaM2: json['area_m2'] != null
          ? (json['area_m2'] as num).toDouble()
          : null,
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
      'tienda_id': tiendaId,
      'ubicacion': ubicacion,
      'tipo': tipo,
      'capacidad_m3': capacidadM3,
      'area_m2': areaM2,
      'activo': activo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'sync_id': syncId,
      'last_sync': lastSync?.toIso8601String(),
    };
  }

  AlmacenModel copyWith({
    String? id,
    String? nombre,
    String? codigo,
    String? tiendaId,
    String? ubicacion,
    String? tipo,
    double? capacidadM3,
    double? areaM2,
    bool? activo,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? syncId,
    DateTime? lastSync,
  }) {
    return AlmacenModel(
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
    );
  }

  @override
  List<Object?> get props => [
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
  String toString() => 'AlmacenModel(id: $id, nombre: $nombre, tipo: $tipo)';
}
