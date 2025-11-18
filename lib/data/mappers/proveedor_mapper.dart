

import 'package:flutter_management_system/data/datasources/local/database/app_database.dart';
import 'package:flutter_management_system/domain/entities/proveedor.dart';

/* final String id;
  final String razonSocial;
  final String nit;
  final String? nombreContacto;
  final String? telefono;
  final String? email;
  final String? direccion;
  final String? ciudad;
  final String? tipoMaterial;
  final int? diasCredito;
  final bool activo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;*/
extension ProveedorTableMapper on ProveedorTable {
  Proveedor toEntity() {
    return Proveedor(
      id: id,
      razonSocial: razonSocial,
      nit: nit,
      nombreContacto: nombreContacto,
      telefono: telefono,
      email: email,
      direccion: direccion,
      ciudad: ciudad,
      tipoMaterial: tipoMaterial,
      diasCredito: diasCredito,
      activo: activo,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}

extension ProveedorEntityMapper on Proveedor {
  ProveedorTable toTable() {
    return ProveedorTable(
      id: id,
      razonSocial: razonSocial,
      nit: nit,
      nombreContacto: nombreContacto ?? '',
      telefono: telefono ?? '',
      email: email ?? '',
      direccion: direccion ?? '',
      ciudad: ciudad ?? '',
      tipoMaterial: tipoMaterial ?? '',
      diasCredito: diasCredito,
      activo: activo,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}
