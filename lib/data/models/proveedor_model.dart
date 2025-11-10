import 'package:equatable/equatable.dart';

/// Modelo de datos para Proveedor
class ProveedorModel extends Equatable {
  final String id;
  final String razonSocial;
  final String nit;
  final String? nombreContacto;
  final String? telefono;
  final String? email;
  final String? direccion;
  final String? ciudad;
  final String? tipoMaterial;
  final int? diasCredito;
  final bool activo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? syncId;
  final DateTime? lastSync;

  const ProveedorModel({
    required this.id,
    required this.razonSocial,
    required this.nit,
    this.nombreContacto,
    this.telefono,
    this.email,
    this.direccion,
    this.ciudad,
    this.tipoMaterial,
    this.diasCredito,
    required this.activo,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.syncId,
    this.lastSync,
  });

  factory ProveedorModel.fromJson(Map<String, dynamic> json) {
    return ProveedorModel(
      id: json['id'] as String,
      razonSocial: json['razon_social'] as String,
      nit: json['nit'] as String,
      nombreContacto: json['nombre_contacto'] as String?,
      telefono: json['telefono'] as String?,
      email: json['email'] as String?,
      direccion: json['direccion'] as String?,
      ciudad: json['ciudad'] as String?,
      tipoMaterial: json['tipo_material'] as String?,
      diasCredito: json['dias_credito'] as int?,
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
      'razon_social': razonSocial,
      'nit': nit,
      'nombre_contacto': nombreContacto,
      'telefono': telefono,
      'email': email,
      'direccion': direccion,
      'ciudad': ciudad,
      'tipo_material': tipoMaterial,
      'dias_credito': diasCredito,
      'activo': activo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'sync_id': syncId,
      'last_sync': lastSync?.toIso8601String(),
    };
  }

  ProveedorModel copyWith({
    String? id,
    String? razonSocial,
    String? nit,
    String? nombreContacto,
    String? telefono,
    String? email,
    String? direccion,
    String? ciudad,
    String? tipoMaterial,
    int? diasCredito,
    bool? activo,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? syncId,
    DateTime? lastSync,
  }) {
    return ProveedorModel(
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
    );
  }

  @override
  List<Object?> get props => [
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
  String toString() => 'ProveedorModel(id: $id, razonSocial: $razonSocial, nit: $nit)';
}
