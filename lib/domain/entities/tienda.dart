import 'package:equatable/equatable.dart';

/// Tienda entity - Pure business object
/// Represents a store/branch in the multi-tenant system
class Tienda extends Equatable {
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

  const Tienda({
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
  });

  /// Check if store is deleted (soft delete)
  bool get isDeleted => deletedAt != null;

  /// Check if store is active and not deleted
  bool get isActiveAndNotDeleted => activo && !isDeleted;

  /// Get full address
  String get fullAddress {
    final parts = <String>[];
    if (direccion != null) parts.add(direccion!);
    if (ciudad != null) parts.add(ciudad!);
    if (departamento != null) parts.add(departamento!);
    return parts.join(', ');
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
      ];

  @override
  String toString() {
    return 'Tienda(id: $id, nombre: $nombre, codigo: $codigo, activo: $activo)';
  }
}
