import 'package:equatable/equatable.dart';

/// Modelo de datos para Movimiento
class MovimientoModel extends Equatable {
  final String id;
  final String numeroMovimiento;
  final String productoId;
  final String inventarioId;
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
  final String? syncId;
  final DateTime? lastSync;
  final bool sincronizado;

  const MovimientoModel({
    required this.id,
    required this.numeroMovimiento,
    required this.productoId,
    required this.inventarioId,
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
    this.syncId,
    this.lastSync,
    required this.sincronizado,
  });

  factory MovimientoModel.fromJson(Map<String, dynamic> json) {
    return MovimientoModel(
      id: json['id'] as String,
      numeroMovimiento: json['numero_movimiento'] as String,
      productoId: json['producto_id'] as String,
      inventarioId: json['inventario_id'] as String,
      loteId: json['lote_id'] as String?,
      tiendaOrigenId: json['tienda_origen_id'] as String?,
      tiendaDestinoId: json['tienda_destino_id'] as String?,
      proveedorId: json['proveedor_id'] as String?,
      tipo: json['tipo'] as String,
      motivo: json['motivo'] as String?,
      cantidad: json['cantidad'] as int,
      costoUnitario: (json['costo_unitario'] as num).toDouble(),
      costoTotal: (json['costo_total'] as num).toDouble(),
      pesoTotalKg: json['peso_total_kg'] != null
          ? (json['peso_total_kg'] as num).toDouble()
          : null,
      usuarioId: json['usuario_id'] as String,
      estado: json['estado'] as String,
      fechaMovimiento: DateTime.parse(json['fecha_movimiento'] as String),
      numeroFactura: json['numero_factura'] as String?,
      numeroGuiaRemision: json['numero_guia_remision'] as String?,
      vehiculoPlaca: json['vehiculo_placa'] as String?,
      conductor: json['conductor'] as String?,
      observaciones: json['observaciones'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      syncId: json['sync_id'] as String?,
      lastSync: json['last_sync'] != null
          ? DateTime.parse(json['last_sync'] as String)
          : null,
      sincronizado: json['sincronizado'] as bool? ?? false,
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
      'sync_id': syncId,
      'last_sync': lastSync?.toIso8601String(),
      'sincronizado': sincronizado,
    };
  }

  MovimientoModel copyWith({
    String? id,
    String? numeroMovimiento,
    String? productoId,
    String? inventarioId,
    String? loteId,
    String? tiendaOrigenId,
    String? tiendaDestinoId,
    String? proveedorId,
    String? tipo,
    String? motivo,
    int? cantidad,
    double? costoUnitario,
    double? costoTotal,
    double? pesoTotalKg,
    String? usuarioId,
    String? estado,
    DateTime? fechaMovimiento,
    String? numeroFactura,
    String? numeroGuiaRemision,
    String? vehiculoPlaca,
    String? conductor,
    String? observaciones,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncId,
    DateTime? lastSync,
    bool? sincronizado,
  }) {
    return MovimientoModel(
      id: id ?? this.id,
      numeroMovimiento: numeroMovimiento ?? this.numeroMovimiento,
      productoId: productoId ?? this.productoId,
      inventarioId: inventarioId ?? this.inventarioId,
      loteId: loteId ?? this.loteId,
      tiendaOrigenId: tiendaOrigenId ?? this.tiendaOrigenId,
      tiendaDestinoId: tiendaDestinoId ?? this.tiendaDestinoId,
      proveedorId: proveedorId ?? this.proveedorId,
      tipo: tipo ?? this.tipo,
      motivo: motivo ?? this.motivo,
      cantidad: cantidad ?? this.cantidad,
      costoUnitario: costoUnitario ?? this.costoUnitario,
      costoTotal: costoTotal ?? this.costoTotal,
      pesoTotalKg: pesoTotalKg ?? this.pesoTotalKg,
      usuarioId: usuarioId ?? this.usuarioId,
      estado: estado ?? this.estado,
      fechaMovimiento: fechaMovimiento ?? this.fechaMovimiento,
      numeroFactura: numeroFactura ?? this.numeroFactura,
      numeroGuiaRemision: numeroGuiaRemision ?? this.numeroGuiaRemision,
      vehiculoPlaca: vehiculoPlaca ?? this.vehiculoPlaca,
      conductor: conductor ?? this.conductor,
      observaciones: observaciones ?? this.observaciones,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncId: syncId ?? this.syncId,
      lastSync: lastSync ?? this.lastSync,
      sincronizado: sincronizado ?? this.sincronizado,
    );
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
        syncId,
        lastSync,
        sincronizado,
      ];

  @override
  String toString() => 'MovimientoModel(id: $id, numeroMovimiento: $numeroMovimiento, tipo: $tipo, estado: $estado)';
}
