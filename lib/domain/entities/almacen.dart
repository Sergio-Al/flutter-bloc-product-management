import 'package:equatable/equatable.dart';

/// Almacen entity - Pure business object
/// Represents a warehouse within a store
class Almacen extends Equatable {
  final String id;
  final String nombre;
  final String codigo;
  final String tiendaId;
  final String? ubicacion;
  final String? tipo; // Principal, Obra, Transito
  final double? capacidadM3;
  final double? areaM2;
  final bool activo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const Almacen({
    required this.id,
    required this.nombre,
    required this.codigo,
    required this.tiendaId,
    this.ubicacion,
    this.tipo,
    this.capacidadM3,
    this.areaM2,
    required this.activo,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  /// Check if warehouse is deleted (soft delete)
  bool get isDeleted => deletedAt != null;

  /// Check if warehouse is active and not deleted
  bool get isActiveAndNotDeleted => activo && !isDeleted;

  /// Check if this is the main warehouse
  bool get isPrincipal => tipo?.toLowerCase() == 'principal';

  /// Get capacity utilization percentage
  double? getCapacityUtilization(double usedM3) {
    if (capacidadM3 == null || capacidadM3! <= 0) return null;
    return (usedM3 / capacidadM3!) * 100;
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
      ];

  @override
  String toString() {
    return 'Almacen(id: $id, nombre: $nombre, codigo: $codigo, tipo: $tipo, activo: $activo)';
  }
}
