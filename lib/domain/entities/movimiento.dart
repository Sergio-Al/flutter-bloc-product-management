import 'package:equatable/equatable.dart';

/// Movimiento entity - Pure business object
/// Represents an inventory movement (purchase, sale, transfer, adjustment, return, loss)
class Movimiento extends Equatable {
  final String id;
  final String numeroMovimiento;
  final String productoId;
  final String? inventarioId;
  final String? loteId;
  final String? tiendaOrigenId;
  final String? tiendaDestinoId;
  final String? proveedorId;
  final String tipo; // COMPRA, VENTA, TRANSFERENCIA, AJUSTE, DEVOLUCION, MERMA
  final String? motivo;
  final int cantidad;
  final double costoUnitario;
  final double costoTotal;
  final double? pesoTotalKg;
  final String usuarioId;
  final String estado; // PENDIENTE, EN_TRANSITO, COMPLETADO, CANCELADO
  final DateTime fechaMovimiento;
  final String? numeroFactura;
  final String? numeroGuiaRemision;
  final String? vehiculoPlaca;
  final String? conductor;
  final String? observaciones;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool sincronizado;

  const Movimiento({
    required this.id,
    required this.numeroMovimiento,
    required this.productoId,
    this.inventarioId,
    this.loteId,
    this.tiendaOrigenId,
    this.tiendaDestinoId,
    this.proveedorId,
    required this.tipo,
    this.motivo,
    required this.cantidad,
    required this.costoUnitario,
    required this.costoTotal,
    this.pesoTotalKg,
    required this.usuarioId,
    required this.estado,
    required this.fechaMovimiento,
    this.numeroFactura,
    this.numeroGuiaRemision,
    this.vehiculoPlaca,
    this.conductor,
    this.observaciones,
    required this.createdAt,
    required this.updatedAt,
    required this.sincronizado,
  });

  /// Check if movement is a purchase
  bool get isCompra => tipo == 'COMPRA';

  /// Check if movement is a sale
  bool get isVenta => tipo == 'VENTA';

  /// Check if movement is a transfer
  bool get isTransferencia => tipo == 'TRANSFERENCIA';

  /// Check if movement is an adjustment
  bool get isAjuste => tipo == 'AJUSTE';

  /// Check if movement is a return
  bool get isDevolucion => tipo == 'DEVOLUCION';

  /// Check if movement is a loss/shrinkage
  bool get isMerma => tipo == 'MERMA';

  /// Check if movement is pending
  bool get isPendiente => estado == 'PENDIENTE';

  /// Check if movement is in transit
  bool get isEnTransito => estado == 'EN_TRANSITO';

  /// Check if movement is completed
  bool get isCompletado => estado == 'COMPLETADO';

  /// Check if movement is cancelled
  bool get isCancelado => estado == 'CANCELADO';

  /// Check if movement can be cancelled
  bool get canBeCancelled => isPendiente || isEnTransito;

  /// Check if movement can be edited
  bool get canBeEdited => isPendiente;

  /// Check if movement requires logistics info (transfer)
  bool get requiresLogistics => isTransferencia;

  /// Check if movement has logistics info
  bool get hasLogisticsInfo =>
      vehiculoPlaca != null && conductor != null;

  /// Check if movement has been synchronized
  bool get isSynchronized => sincronizado;

  /// Check if movement increases inventory
  bool get increasesInventory => isCompra || isDevolucion || (isAjuste && cantidad > 0);

  /// Check if movement decreases inventory
  bool get decreasesInventory => isVenta || isMerma || (isAjuste && cantidad < 0);

  /// Get movement direction as string
  String get direction {
    if (increasesInventory) return 'ENTRADA';
    if (decreasesInventory) return 'SALIDA';
    if (isTransferencia) return 'TRANSFERENCIA';
    return 'NEUTRO';
  }

  @override
  List<Object?> get props => [
        id,
        numeroMovimiento,
        productoId,
        inventarioId,
        loteId,
        tiendaOrigenId,
        tiendaDestinoId,
        proveedorId,
        tipo,
        motivo,
        cantidad,
        costoUnitario,
        costoTotal,
        pesoTotalKg,
        usuarioId,
        estado,
        fechaMovimiento,
        numeroFactura,
        numeroGuiaRemision,
        vehiculoPlaca,
        conductor,
        observaciones,
        createdAt,
        updatedAt,
        sincronizado,
      ];

  @override
  String toString() {
    return 'Movimiento(id: $id, numero: $numeroMovimiento, tipo: $tipo, estado: $estado, cantidad: $cantidad)';
  }
}
