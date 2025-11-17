// lib/data/mappers/almacen_mapper.dart
import 'package:flutter_management_system/data/datasources/local/database/app_database.dart';
import 'package:flutter_management_system/domain/entities/almacen.dart';

/// Extension to convert AlmacenTable (data layer) to Almacen entity (domain layer)
/// This keeps conversion logic in the data layer where it belongs
extension AlmacenTableMapper on AlmacenTable {
  Almacen toEntity() {
    return Almacen(
      id: id,
      nombre: nombre,
      codigo: codigo,
      tiendaId: tiendaId,
      ubicacion: ubicacion,
      tipo: tipo,
      capacidadM3: capacidadM3,
      areaM2: areaM2,
      activo: activo,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}

/// Extension to convert Almacen entity (domain layer) to AlmacenTable (data layer)
extension AlmacenEntityMapper on Almacen {
  AlmacenTable toTable() {
    return AlmacenTable(
      id: id,
      nombre: nombre,
      codigo: codigo,
      tiendaId: tiendaId,
      ubicacion: ubicacion,
      tipo: tipo,
      capacidadM3: capacidadM3,
      areaM2: areaM2,
      activo: activo,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}
