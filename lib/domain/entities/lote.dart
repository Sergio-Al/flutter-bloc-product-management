import 'package:equatable/equatable.dart';

/// Lote entity - Pure business object
/// Represents a batch/lot with expiration tracking
class Lote extends Equatable {
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

  const Lote({
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
  });

  /// Check if lot is expired
  bool get isExpired {
    if (fechaVencimiento == null) return false;
    return DateTime.now().isAfter(fechaVencimiento!);
  }

  /// Check if lot is near expiration (within 30 days)
  bool get isNearExpiration {
    if (fechaVencimiento == null) return false;
    final daysUntilExpiration = fechaVencimiento!.difference(DateTime.now()).inDays;
    return daysUntilExpiration > 0 && daysUntilExpiration <= 30;
  }

  /// Get days until expiration
  int? get daysUntilExpiration {
    if (fechaVencimiento == null) return null;
    return fechaVencimiento!.difference(DateTime.now()).inDays;
  }

  /// Check if lot is empty
  bool get isEmpty => cantidadActual <= 0;

  /// Get usage percentage
  double get usagePercentage {
    if (cantidadInicial <= 0) return 0;
    return ((cantidadInicial - cantidadActual) / cantidadInicial) * 100;
  }

  /// Check if lot has quality certificate
  bool get hasCertificate => certificadoCalidadUrl != null && certificadoCalidadUrl!.isNotEmpty;

  @override
  List<Object?> get props => [
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
      ];

  @override
  String toString() {
    return 'Lote(id: $id, numeroLote: $numeroLote, cantidadActual: $cantidadActual/$cantidadInicial)';
  }
}
