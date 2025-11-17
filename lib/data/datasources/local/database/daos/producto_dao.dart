import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/productos_table.dart';
import '../tables/categorias_table.dart';
import '../tables/unidades_medida_table.dart';

part 'producto_dao.g.dart';

@DriftAccessor(tables: [Productos, Categorias, UnidadesMedida])
class ProductoDao extends DatabaseAccessor<AppDatabase>
    with _$ProductoDaoMixin {
  ProductoDao(AppDatabase db) : super(db);

  // Obtener todos los productos
  Future<List<ProductoTable>> getAllProductos() {
    return (select(
      productos,
    )..where((tbl) => tbl.deletedAt.isNull())).get();
  }

  // Obtener productos activos
  Future<List<ProductoTable>> getProductosActivos() {
    return (select(
      productos,
    )..where((tbl) => tbl.activo.equals(true) & tbl.deletedAt.isNull())).get();
  } 

  // Obtener productos con paginación
  Future<List<ProductoTable>> getProductosPaginated(int limit, int offset) {
    return (select(productos)
          ..where((tbl) => tbl.activo.equals(true) & tbl.deletedAt.isNull())
          ..limit(limit, offset: offset))
        .get();
  }

  // Buscar productos por nombre o código
  Future<List<ProductoTable>> searchProductos(String query) {
    final searchTerm = '%${query.toLowerCase()}%';
    return (select(productos)..where(
          (tbl) =>
              (tbl.nombre.lower().like(searchTerm) |
                  tbl.codigo.lower().like(searchTerm)) &
              tbl.activo.equals(true) &
              tbl.deletedAt.isNull(),
        ))
        .get();
  }

  // Obtener producto por ID
  Future<ProductoTable?> getProductoById(String id) {
    return (select(
      productos,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // Obtener producto por código
  Future<ProductoTable?> getProductoByCodigo(String codigo) {
    return (select(
      productos,
    )..where((tbl) => tbl.codigo.equals(codigo))).getSingleOrNull();
  }

  // Obtener productos por categoría
  Future<List<ProductoTable>> getProductosByCategoria(String categoriaId) {
    return (select(productos)..where(
          (tbl) =>
              tbl.categoriaId.equals(categoriaId) &
              tbl.activo.equals(true) &
              tbl.deletedAt.isNull(),
        ))
        .get();
  }

  // Obtener productos con stock bajo
  Stream<List<ProductoTable>> watchProductosStockBajo() {
    // Nota: Esto requiere join con inventarios, simplificado aquí
    return (select(productos)
          ..where((tbl) => tbl.activo.equals(true) & tbl.deletedAt.isNull()))
        .watch();
  }

  // Insertar producto
  Future<int> insertProducto(ProductoTable producto) {
    return into(productos).insert(
      ProductosCompanion.insert(
        id: producto.id,
        nombre: producto.nombre,
        codigo: producto.codigo,
        categoriaId: producto.categoriaId,
        unidadMedidaId: producto.unidadMedidaId,
        descripcion: Value(producto.descripcion),
        precioCompra: Value(producto.precioCompra),
        precioVenta: Value(producto.precioVenta),
        stockMinimo: Value(producto.stockMinimo),
        stockMaximo: Value(producto.stockMaximo),
        marca: Value(producto.marca),
        syncId: Value(producto.syncId),
      ),
    );
  }

  // Actualizar producto
  Future<bool> updateProducto(ProductoTable producto) async {
    final result = await (update(
      productos,
    )..where((tbl) => tbl.id.equals(producto.id))).write(
      ProductosCompanion(
        nombre: Value(producto.nombre),
        descripcion: Value(producto.descripcion),
        precioCompra: Value(producto.precioCompra),
        precioVenta: Value(producto.precioVenta),
        stockMinimo: Value(producto.stockMinimo),
        stockMaximo: Value(producto.stockMaximo),
        marca: Value(producto.marca),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return result > 0;
  }

  // Soft delete
  Future<bool> deleteProducto(String id) async {
    final result = await (update(productos)..where((tbl) => tbl.id.equals(id))).write(
      ProductosCompanion(
        activo: const Value(false),
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return result > 0;
  }

  // Obtener productos que requieren almacenamiento especial
  Future<List<ProductoTable>> getProductosAlmacenamientoEspecial() {
    return (select(productos)..where(
          (tbl) =>
              tbl.requiereAlmacenCubierto.equals(true) &
              tbl.deletedAt.isNull(),
        ))
        .get();
  }

  // Obtener productos no sincronizados
  Future<List<ProductoTable>> getProductosNoSincronizados() {
    return (select(productos)..where((tbl) => tbl.lastSync.isNull())).get();
  }

  // 🧹 Clean up productos with invalid temp IDs (legacy cleanup)
  Future<int> deleteProductosWithTempIds() async {
    return await (delete(productos)..where((tbl) => tbl.id.like('temp_%'))).go();
  }

  // Get productos with temp IDs (for debugging)
  Future<List<ProductoTable>> getProductosWithTempIds() {
    return (select(productos)..where((tbl) => tbl.id.like('temp_%'))).get();
  }

  // 🧹 Reset temp sync_id to null (fixes sync issues)
  Future<int> resetTempSyncIds() async {
    return await (update(productos)
      ..where((tbl) => tbl.syncId.like('temp_%')))
      .write(const ProductosCompanion(
        syncId: Value(null),
      ));
  }

  // Get productos with temp sync_id (for debugging)
  Future<List<ProductoTable>> getProductosWithTempSyncIds() {
    return (select(productos)..where((tbl) => tbl.syncId.like('temp_%'))).get();
  }
}
