import 'package:equatable/equatable.dart';

/// Inventario entity - Pure business object
/// Represents current stock levels at a specific warehouse location
class Inventario extends Equatable {
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
  final DateTime? ultimaActualizacion;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Inventario({
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
    this.ultimaActualizacion,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if inventory is empty
  bool get isEmpty => cantidadActual <= 0;

  /// Check if there's available stock
  bool get hasAvailableStock => cantidadDisponible > 0;

  /// Check if all stock is reserved
  bool get isFullyReserved => cantidadReservada >= cantidadActual;

  /// Get reservation percentage
  double get reservationPercentage {
    if (cantidadActual <= 0) return 0;
    return (cantidadReservada / cantidadActual) * 100;
  }

  /// Check if quantity can be reserved
  bool canReserve(int quantity) {
    return cantidadDisponible >= quantity;
  }

  /// Get average unit value
  double get valorUnitario {
    if (cantidadActual <= 0) return 0;
    return valorTotal / cantidadActual;
  }

  /// Check if inventory belongs to a specific lot
  bool get hasLote => loteId != null;

  /// Check if inventory has physical location assigned
  bool get hasUbicacionFisica =>
      ubicacionFisica != null && ubicacionFisica!.isNotEmpty;

  @override
  List<Object?> get props => [
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
      ];

  @override
  String toString() {
    return 'Inventario(id: $id, productoId: $productoId, cantidadActual: $cantidadActual, cantidadDisponible: $cantidadDisponible)';
  }

  // Convert to JSON (for sync or other purposes)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productoId': productoId,
      'almacenId': almacenId,
      'tiendaId': tiendaId,
      'loteId': loteId,
      'cantidadActual': cantidadActual,
      'cantidadReservada': cantidadReservada,
      'cantidadDisponible': cantidadDisponible,
      'valorTotal': valorTotal,
      'ubicacionFisica': ubicacionFisica,
      'ultimaActualizacion': ultimaActualizacion?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
