import 'package:flutter_management_system/data/datasources/local/database/app_database.dart';
import 'package:flutter_management_system/domain/entities/categoria.dart';

/// Extension to convert CategoriaTable (data layer) to Categoria entity (domain layer)
extension CategoriaTableMapper on CategoriaTable {
  Categoria toEntity() {
    return Categoria(
      id: id,
      nombre: nombre,
      codigo: codigo,
      descripcion: descripcion,
      categoriaPadreId: categoriaPadreId,
      requiereLote: requiereLote,
      requiereCertificacion: requiereCertificacion,
      activo: activo,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// Extension to convert Categoria entity (domain layer) to CategoriaTable (data layer)
extension CategoriaEntityMapper on Categoria {
  CategoriaTable toTable() {
    return CategoriaTable(
      id: id,
      nombre: nombre,
      codigo: codigo,
      descripcion: descripcion,
      categoriaPadreId: categoriaPadreId,
      requiereLote: requiereLote,
      requiereCertificacion: requiereCertificacion,
      activo: activo,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
