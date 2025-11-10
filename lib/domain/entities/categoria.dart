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

  @override
  String toString() {
    return 'Categoria(id: $id, nombre: $nombre, codigo: $codigo, activo: $activo)';
  }
}
