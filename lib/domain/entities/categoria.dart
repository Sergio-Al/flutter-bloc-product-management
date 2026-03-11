import 'package:equatable/equatable.dart';

/// Categoria entity - Pure business object
/// Represents a hierarchical product category
class Categoria extends Equatable {
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

  const Categoria({
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
  });

  /// Check if this is a root category (no parent)
  bool get isRootCategory => categoriaPadreId == null;

  /// Check if this is a subcategory (has parent)
  bool get isSubcategory => categoriaPadreId != null;

  /// Check if this category is active
  bool get isActive => activo;

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
      ];

  /// Convert Categoria to JSON (camelCase keys for local sync queue)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'codigo': codigo,
      'descripcion': descripcion,
      'categoriaPadreId': categoriaPadreId,
      'requiereLote': requiereLote,
      'requiereCertificacion': requiereCertificacion,
      'activo': activo,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create Categoria from JSON (camelCase keys)
  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      codigo: json['codigo'] as String,
      descripcion: json['descripcion'] as String?,
      categoriaPadreId: json['categoriaPadreId'] as String?,
      requiereLote: json['requiereLote'] as bool? ?? false,
      requiereCertificacion: json['requiereCertificacion'] as bool? ?? false,
      activo: json['activo'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  String toString() {
    return 'Categoria(id: $id, nombre: $nombre, codigo: $codigo, activo: $activo)';
  }
}
