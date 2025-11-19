import 'package:flutter_management_system/data/datasources/local/database/app_database.dart';
import 'package:flutter_management_system/domain/entities/movimiento.dart';

/* 
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
*/

extension MovimientoTableMapper on MovimientoTable {
  Movimiento toEntity() {
    return Movimiento(
      id: id,
      numeroMovimiento: numeroMovimiento,
      productoId: productoId,
      inventarioId: inventarioId?.isEmpty == true ? null : inventarioId,
      loteId: loteId?.isEmpty == true ? null : loteId,
      tiendaOrigenId: tiendaOrigenId?.isEmpty == true ? null : tiendaOrigenId,
      tiendaDestinoId: tiendaDestinoId?.isEmpty == true ? null : tiendaDestinoId,
      proveedorId: proveedorId?.isEmpty == true ? null : proveedorId,
      tipo: tipo,
      motivo: motivo?.isEmpty == true ? null : motivo,
      cantidad: cantidad,
      costoUnitario: costoUnitario,
      costoTotal: costoTotal,
      pesoTotalKg: pesoTotalKg,
      usuarioId: usuarioId,
      estado: estado,
      fechaMovimiento: fechaMovimiento,
      numeroFactura: numeroFactura?.isEmpty == true ? null : numeroFactura,
      numeroGuiaRemision: numeroGuiaRemision?.isEmpty == true
          ? null
          : numeroGuiaRemision,
      vehiculoPlaca: vehiculoPlaca?.isEmpty == true ? null : vehiculoPlaca,
      conductor: conductor?.isEmpty == true ? null : conductor,
      observaciones: observaciones?.isEmpty == true ? null : observaciones,
      createdAt: createdAt,
      updatedAt: updatedAt,
      sincronizado: sincronizado,
    );
  }
}


extension MovimientoEntityMapper on Movimiento {
  MovimientoTable toTable() {
    return MovimientoTable(
      id: id,
      numeroMovimiento: numeroMovimiento,
      productoId: productoId,
      inventarioId: inventarioId,
      loteId: loteId,
      tiendaOrigenId: tiendaOrigenId,
      tiendaDestinoId: tiendaDestinoId,
      proveedorId: proveedorId,
      tipo: tipo,
      motivo: motivo,
      cantidad: cantidad,
      costoUnitario: costoUnitario,
      costoTotal: costoTotal,
      pesoTotalKg: pesoTotalKg,
      usuarioId: usuarioId,
      estado: estado,
      fechaMovimiento: fechaMovimiento,
      numeroFactura: numeroFactura,
      numeroGuiaRemision: numeroGuiaRemision,
      vehiculoPlaca: vehiculoPlaca,
      conductor: conductor,
      observaciones: observaciones,
      createdAt: createdAt,
      updatedAt: updatedAt,
      sincronizado: sincronizado,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero_movimiento': numeroMovimiento,
      'producto_id': productoId,
      'inventario_id': inventarioId,
      'lote_id': loteId,
      'tienda_origen_id': tiendaOrigenId,
      'tienda_destino_id': tiendaDestinoId,
      'proveedor_id': proveedorId,
      'tipo': tipo,
      'motivo': motivo,
      'cantidad': cantidad,
      'costo_unitario': costoUnitario,
      'costo_total': costoTotal,
      'peso_total_kg': pesoTotalKg,
      'usuario_id': usuarioId,
      'estado': estado,
      'fecha_movimiento': fechaMovimiento.toIso8601String(),
      'numero_factura': numeroFactura,
      'numero_guia_remision': numeroGuiaRemision,
      'vehiculo_placa': vehiculoPlaca,
      'conductor': conductor,
      'observaciones': observaciones,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'sincronizado': sincronizado,
    };
  }
}
