import '../../../data/models/producto_model.dart';
import '../../../data/datasources/local/database/tables/productos_table.dart';
import '../../../domain/entities/producto.dart';

extension ProductoTableExtension on Productos {
  Producto toEntity() {
    return Producto(
      id: id.toString(),
      nombre: nombre.toString(),
      codigo: codigo.toString(),
      descripcion: descripcion.toString(),
      categoriaId: categoriaId.toString(),
      unidadMedidaId: unidadMedidaId.toString(),
      precioCompra: (precioCompra as num).toDouble(),
      precioVenta: (precioVenta as num).toDouble(),
      stockMinimo: (stockMinimo as num).toInt(),
      stockMaximo: (stockMaximo as num).toInt(),
      activo: (activo as bool),
      requiereAlmacenCubierto: (requiereAlmacenCubierto as bool),
      materialPeligroso: (materialPeligroso as bool),
      createdAt: createdAt as DateTime,
      updatedAt: updatedAt as DateTime,
    );
  }
}

extension ProductoModelExtension on ProductoModel {
  Producto toTable() {
    return Producto(
      id: id,
      nombre: nombre,
      codigo: codigo,
      descripcion: descripcion,
      categoriaId: categoriaId,
      unidadMedidaId: unidadMedidaId,
      precioCompra: precioCompra,
      precioVenta: precioVenta,
      stockMinimo: stockMinimo,
      stockMaximo: stockMaximo,
      activo: activo,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      requiereAlmacenCubierto: requiereAlmacenCubierto,
      materialPeligroso: materialPeligroso,
      syncId: syncId,
      lastSync: lastSync,
    );
  }

  static ProductoModel fromEntity(Producto entity) {
    return ProductoModel(
      id: entity.id,
      nombre: entity.nombre,
      codigo: entity.codigo,
      descripcion: entity.descripcion,
      categoriaId: entity.categoriaId!,
      unidadMedidaId: entity.unidadMedidaId!,
      precioCompra: entity.precioCompra,
      precioVenta: entity.precioVenta,
      stockMinimo: entity.stockMinimo,
      stockMaximo: entity.stockMaximo,
      activo: entity.activo,
      requiereAlmacenCubierto: entity.requiereAlmacenCubierto,
      materialPeligroso: entity.materialPeligroso,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
