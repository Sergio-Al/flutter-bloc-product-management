import 'package:flutter_management_system/data/datasources/local/database/app_database.dart';
import 'package:flutter_management_system/domain/entities/tienda.dart';

extension TiendaTableMapper on TiendaTable {
  Tienda toEntity() {
    return Tienda(
      id: id,
      nombre: nombre,
      codigo: codigo,
      direccion: direccion,
      ciudad: ciudad,
      departamento: departamento,
      telefono: telefono,
      horarioAtencion: horarioAtencion,
      activo: activo,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}

extension TiendaEntityMapper on Tienda {
  TiendaTable toTable() {
    return TiendaTable(
      id: id,
      nombre: nombre,
      codigo: codigo,
      direccion: direccion ?? '',
      ciudad: ciudad ?? '',
      departamento: departamento ?? '',
      telefono: telefono,
      horarioAtencion: horarioAtencion,
      activo: activo,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}
