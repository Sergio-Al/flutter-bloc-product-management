import 'package:flutter_management_system/data/datasources/local/database/app_database.dart';
import 'package:flutter_management_system/domain/entities/lote.dart';

extension LoteTableMapper on LoteTable {
  Lote toEntity() {
    return Lote(
      id: id,
      numeroLote: numeroLote,
      productoId: productoId,
      fechaFabricacion: fechaFabricacion,
      fechaVencimiento: fechaVencimiento,
      proveedorId: proveedorId?.isEmpty == true ? null : proveedorId,
      numeroFactura: numeroFactura?.isEmpty == true ? null : numeroFactura,
      cantidadInicial: cantidadInicial,
      cantidadActual: cantidadActual,
      certificadoCalidadUrl: certificadoCalidadUrl?.isEmpty == true
          ? null
          : certificadoCalidadUrl,
      observaciones: observaciones?.isEmpty == true ? null : observaciones,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension LoteEntityMapper on Lote {
  LoteTable toTable() {
    return LoteTable(
      id: id,
      numeroLote: numeroLote,
      productoId: productoId,
      fechaFabricacion: fechaFabricacion,
      fechaVencimiento: fechaVencimiento,
      proveedorId: proveedorId ?? '',
      numeroFactura: numeroFactura ?? '',
      cantidadInicial: cantidadInicial,
      cantidadActual: cantidadActual,
      certificadoCalidadUrl: certificadoCalidadUrl ?? '',
      observaciones: observaciones ?? '',
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
