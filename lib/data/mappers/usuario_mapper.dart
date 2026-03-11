import 'package:flutter_management_system/data/datasources/local/database/app_database.dart';
import 'package:flutter_management_system/domain/entities/usuario.dart';

/// Extension to convert UsuarioTable (data layer) to Usuario entity (domain layer)
extension UsuarioTableMapper on UsuarioTable {
  Usuario toEntity() {
    return Usuario(
      id: id,
      email: email,
      nombreCompleto: nombreCompleto,
      telefono: telefono,
      tiendaId: tiendaId,
      rolId: rolId,
      activo: activo,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}

/// Extension to convert Usuario entity (domain layer) to UsuarioTable (data layer)
extension UsuarioEntityMapper on Usuario {
  UsuarioTable toTable() {
    return UsuarioTable(
      id: id,
      email: email,
      nombreCompleto: nombreCompleto,
      telefono: telefono,
      tiendaId: tiendaId,
      rolId: rolId ?? '',
      activo: activo,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}
