import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/inventarios_table.dart';
import '../tables/productos_table.dart';
import '../tables/almacenes_table.dart';

part 'inventario_dao.g.dart';

@DriftAccessor(tables: [Inventarios, Productos, Almacenes])
class InventarioDao extends DatabaseAccessor<AppDatabase>
    with _$InventarioDaoMixin {
  InventarioDao(AppDatabase db) : super(db);

  // Obtener todos los inventarios
  Future<List<InventarioTable>> getAllInventarios() {
    return (select(inventarios)
          ..orderBy([(t) => OrderingTerm.asc(t.productoId)]))
        .get();
  }

  // Obtener inventario por lote
  Future<List<InventarioTable>> getInventarioByLote(String loteId) {
    return (select(
      inventarios,
    )..where((tbl) => tbl.loteId.equals(loteId))).get();
  }

  // Obtener inventario por almacén
  Future<List<InventarioTable>> getInventarioByAlmacen(String almacenId) {
    return (select(
      inventarios,
    )..where((tbl) => tbl.almacenId.equals(almacenId))).get();
  }

  // Obtener inventario por id
  Future<InventarioTable?> getInventarioById(String id) {
    return (select(
      inventarios,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // Obtener inventario por tienda
  Future<List<InventarioTable>> getInventarioByTienda(String tiendaId) {
    return (select(
      inventarios,
    )..where((tbl) => tbl.tiendaId.equals(tiendaId))).get();
  }

  // Obtener inventario de un producto en un almacén específico
  Future<InventarioTable?> getInventarioByProductoAlmacen(
    String productoId,
    String almacenId,
  ) {
    return (select(inventarios)..where(
          (tbl) =>
              tbl.productoId.equals(productoId) &
              tbl.almacenId.equals(almacenId),
        ))
        .getSingleOrNull();
  }

  // Obtener todos los inventarios de un producto
  Future<List<InventarioTable>> getInventarioByProducto(String productoId) {
    return (select(inventarios)..where((tbl) => tbl.productoId.equals(productoId))).get();
  }

  // Obtener inventarios disponibles (con stock > 0)
  Future<List<InventarioTable>> getInventariosDisponibles() {
    return (select(inventarios)..where((tbl) => tbl.cantidadDisponible.isBiggerThanValue(0))).get();
  }

  // Obtener productos con stock bajo en un almacén
  Future<List<InventarioTable>> getProductosStockBajo(String almacenId) {
    // Esto requiere un join con productos para comparar con stockMinimo
    return (select(inventarios)..where(
          (tbl) =>
              tbl.almacenId.equals(almacenId) &
              tbl.cantidadDisponible.isSmallerThanValue(10),
        ))
        .get();
  }

  // Watch inventario (tiempo real)
  Stream<List<InventarioTable>> watchInventarioByAlmacen(String almacenId) {
    return (select(
      inventarios,
    )..where((tbl) => tbl.almacenId.equals(almacenId))).watch();
  }

  // Actualizar stock
  Future<bool> updateStock(
    String inventarioId,
    int nuevaCantidad, {
    int? cantidadReservada,
  }) async {
    final disponible = cantidadReservada != null
        ? nuevaCantidad - cantidadReservada
        : nuevaCantidad;

    final result =
        await (update(
          inventarios,
        )..where((tbl) => tbl.id.equals(inventarioId))).write(
          InventariosCompanion(
            cantidadActual: Value(nuevaCantidad),
            cantidadReservada: Value(cantidadReservada ?? 0),
            cantidadDisponible: Value(disponible),
            ultimaActualizacion: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),
        );
    return result > 0;
  }

  // Insertar inventario
  Future<int> insertInventario(InventarioTable inventario) {
    return into(inventarios).insert(
      InventariosCompanion.insert(
        id: inventario.id,
        productoId: inventario.productoId,
        almacenId: inventario.almacenId,
        tiendaId: inventario.tiendaId,
        cantidadActual: Value(inventario.cantidadActual),
        cantidadReservada: Value(inventario.cantidadReservada),
        cantidadDisponible: Value(inventario.cantidadDisponible),
        syncId: Value(inventario.syncId),
      ),
    );
  }

  // Incrementar stock
  Future<void> incrementarStock(String inventarioId, int cantidad) async {
    final inventario = await (select(
      inventarios,
    )..where((tbl) => tbl.id.equals(inventarioId))).getSingleOrNull();

    if (inventario != null) {
      await updateStock(
        inventarioId,
        inventario.cantidadActual + cantidad,
        cantidadReservada: inventario.cantidadReservada,
      );
    }
  }

  // Decrementar stock
  Future<void> decrementarStock(String inventarioId, int cantidad) async {
    final inventario = await (select(
      inventarios,
    )..where((tbl) => tbl.id.equals(inventarioId))).getSingleOrNull();

    if (inventario != null) {
      final nuevaCantidad = inventario.cantidadActual - cantidad;
      if (nuevaCantidad >= 0) {
        await updateStock(
          inventarioId,
          nuevaCantidad,
          cantidadReservada: inventario.cantidadReservada,
        );
      } else {
        throw Exception('Stock insuficiente');
      }
    }
  }

  // Eliminar inventario
  Future<bool> deleteInventario(String id) async {
    final result =
        await (delete(inventarios)..where((tbl) => tbl.id.equals(id))).go();
    return result > 0;
  }
}
