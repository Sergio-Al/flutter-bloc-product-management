import 'package:equatable/equatable.dart';

/// Modelo de datos para Categoria
class CategoriaModel extends Equatable {
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

  const CategoriaModel({
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

  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      codigo: json['codigo'] as String,
      descripcion: json['descripcion'] as String?,
      categoriaPadreId: json['categoria_padre_id'] as String?,
      requiereLote: json['requiere_lote'] as bool? ?? false,
      requiereCertificacion: json['requiere_certificacion'] as bool? ?? false,
      activo: json['activo'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
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
      'descripcion': descripcion,
      'categoria_padre_id': categoriaPadreId,
      'requiere_lote': requiereLote,
      'requiere_certificacion': requiereCertificacion,
      'activo': activo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'sync_id': syncId,
      'last_sync': lastSync?.toIso8601String(),
    };
  }

  CategoriaModel copyWith({
    String? id,
    String? nombre,
    String? codigo,
    String? descripcion,
    String? categoriaPadreId,
    bool? requiereLote,
    bool? requiereCertificacion,
    bool? activo,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncId,
    DateTime? lastSync,
  }) {
    return CategoriaModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      codigo: codigo ?? this.codigo,
      descripcion: descripcion ?? this.descripcion,
      categoriaPadreId: categoriaPadreId ?? this.categoriaPadreId,
      requiereLote: requiereLote ?? this.requiereLote,
      requiereCertificacion: requiereCertificacion ?? this.requiereCertificacion,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncId: syncId ?? this.syncId,
      lastSync: lastSync ?? this.lastSync,
    );
  }

  @override
  List<Object?> get props => [
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
  String toString() => 'CategoriaModel(id: $id, nombre: $nombre, codigo: $codigo)';
}
