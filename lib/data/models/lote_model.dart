import 'package:equatable/equatable.dart';

/// Modelo de datos para Lote
class LoteModel extends Equatable {
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
  final String? syncId;
  final DateTime? lastSync;

  const LoteModel({
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
    this.syncId,
    this.lastSync,
  });

  factory LoteModel.fromJson(Map<String, dynamic> json) {
    return LoteModel(
      id: json['id'] as String,
      numeroLote: json['numero_lote'] as String,
      productoId: json['producto_id'] as String,
      fechaFabricacion: json['fecha_fabricacion'] != null
          ? DateTime.parse(json['fecha_fabricacion'] as String)
          : null,
      fechaVencimiento: json['fecha_vencimiento'] != null
          ? DateTime.parse(json['fecha_vencimiento'] as String)
          : null,
      proveedorId: json['proveedor_id'] as String?,
      numeroFactura: json['numero_factura'] as String?,
      cantidadInicial: json['cantidad_inicial'] as int,
      cantidadActual: json['cantidad_actual'] as int,
      certificadoCalidadUrl: json['certificado_calidad_url'] as String?,
      observaciones: json['observaciones'] as String?,
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
      'numero_lote': numeroLote,
      'producto_id': productoId,
      'fecha_fabricacion': fechaFabricacion?.toIso8601String(),
      'fecha_vencimiento': fechaVencimiento?.toIso8601String(),
      'proveedor_id': proveedorId,
      'numero_factura': numeroFactura,
      'cantidad_inicial': cantidadInicial,
      'cantidad_actual': cantidadActual,
      'certificado_calidad_url': certificadoCalidadUrl,
      'observaciones': observaciones,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'sync_id': syncId,
      'last_sync': lastSync?.toIso8601String(),
    };
  }

  LoteModel copyWith({
    String? id,
    String? numeroLote,
    String? productoId,
    DateTime? fechaFabricacion,
    DateTime? fechaVencimiento,
    String? proveedorId,
    String? numeroFactura,
    int? cantidadInicial,
    int? cantidadActual,
    String? certificadoCalidadUrl,
    String? observaciones,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncId,
    DateTime? lastSync,
  }) {
    return LoteModel(
      id: id ?? this.id,
      numeroLote: numeroLote ?? this.numeroLote,
      productoId: productoId ?? this.productoId,
      fechaFabricacion: fechaFabricacion ?? this.fechaFabricacion,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      proveedorId: proveedorId ?? this.proveedorId,
      numeroFactura: numeroFactura ?? this.numeroFactura,
      cantidadInicial: cantidadInicial ?? this.cantidadInicial,
      cantidadActual: cantidadActual ?? this.cantidadActual,
      certificadoCalidadUrl: certificadoCalidadUrl ?? this.certificadoCalidadUrl,
      observaciones: observaciones ?? this.observaciones,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncId: syncId ?? this.syncId,
      lastSync: lastSync ?? this.lastSync,
    );
  }

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
        syncId,
        lastSync,
      ];

  @override
  String toString() => 'LoteModel(id: $id, numeroLote: $numeroLote, cantidadActual: $cantidadActual)';
}
