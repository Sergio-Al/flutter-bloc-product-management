import 'package:flutter_management_system/data/datasources/local/database/app_database.dart';
import 'package:flutter_management_system/domain/entities/inventario.dart';

extension InventarioTableMapper on InventarioTable {
  Inventario toEntity() {
    return Inventario(
      id: id,
      productoId: productoId,
      almacenId: almacenId,
      tiendaId: tiendaId,
      loteId: loteId,
      cantidadActual: cantidadActual,
      cantidadReservada: cantidadReservada,
      cantidadDisponible: cantidadDisponible,
      valorTotal: valorTotal,
      ubicacionFisica: ubicacionFisica,
      ultimaActualizacion: ultimaActualizacion,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension InventarioEntityMapper on Inventario {
  InventarioTable toTable() {
    return InventarioTable(
      id: id,
      productoId: productoId,
      almacenId: almacenId,
      tiendaId: tiendaId,
      loteId: loteId,
      cantidadActual: cantidadActual,
      cantidadReservada: cantidadReservada,
      cantidadDisponible: cantidadDisponible,
      valorTotal: valorTotal,
      ubicacionFisica: ubicacionFisica,
      ultimaActualizacion: ultimaActualizacion != null
          ? ultimaActualizacion!
          : DateTime.now(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
