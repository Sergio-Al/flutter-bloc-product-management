import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/movimientos_table.dart';
import '../tables/productos_table.dart';

part 'movimiento_dao.g.dart';

@DriftAccessor(tables: [Movimientos, Productos])
class MovimientoDao extends DatabaseAccessor<AppDatabase> with _$MovimientoDaoMixin {
  MovimientoDao(AppDatabase db) : super(db);

  // Obtener todos los movimientos
  Future<List<MovimientoTable>> getAllMovimientos() {
    return (select(movimientos)..orderBy([(t) => OrderingTerm.desc(t.fechaMovimiento)])).get();
  }

  // Obtener movimientos por tipo
  Future<List<MovimientoTable>> getMovimientosByTipo(String tipo) {
    return (select(movimientos)
          ..where((tbl) => tbl.tipo.equals(tipo))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaMovimiento)]))
        .get();
  }

  // Obtener movimientos por tienda
  Future<List<MovimientoTable>> getMovimientosByTienda(String tiendaId) {
    return (select(movimientos)
          ..where((tbl) =>
              tbl.tiendaOrigenId.equals(tiendaId) | tbl.tiendaDestinoId.equals(tiendaId))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaMovimiento)]))
        .get();
  }

  // Obtener movimientos pendientes de sincronización
  Future<List<MovimientoTable>> getMovimientosNoSincronizados() {
    return (select(movimientos)..where((tbl) => tbl.sincronizado.equals(false))).get();
  }

  // Obtener movimientos por rango de fechas
  Future<List<MovimientoTable>> getMovimientosByFechaRange(
    DateTime inicio,
    DateTime fin,
  ) {
    return (select(movimientos)
          ..where((tbl) =>
              tbl.fechaMovimiento.isBiggerOrEqualValue(inicio) &
              tbl.fechaMovimiento.isSmallerOrEqualValue(fin))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaMovimiento)]))
        .get();
  }

  // Insertar movimiento
  Future<int> insertMovimiento(MovimientoTable movimiento) {
    return into(movimientos).insert(MovimientosCompanion.insert(
      id: movimiento.id,
      numeroMovimiento: movimiento.numeroMovimiento,
      productoId: movimiento.productoId,
      inventarioId: movimiento.inventarioId,
      tipo: movimiento.tipo,
      cantidad: movimiento.cantidad,
      usuarioId: movimiento.usuarioId,
      estado: movimiento.estado,
      tiendaOrigenId: Value(movimiento.tiendaOrigenId),
      tiendaDestinoId: Value(movimiento.tiendaDestinoId),
      costoUnitario: Value(movimiento.costoUnitario),
      costoTotal: Value(movimiento.costoTotal),
      syncId: Value(movimiento.syncId),
    ));
  }

  // Actualizar estado de movimiento
  Future<bool> updateEstadoMovimiento(String id, String nuevoEstado) async {
    final result = await (update(movimientos)..where((tbl) => tbl.id.equals(id)))
        .write(MovimientosCompanion(
      estado: Value(nuevoEstado),
      updatedAt: Value(DateTime.now()),
    ));
    return result > 0;
  }

  // Marcar como sincronizado
  Future<bool> marcarComoSincronizado(String id) async {
    final result = await (update(movimientos)..where((tbl) => tbl.id.equals(id)))
        .write(MovimientosCompanion(
      sincronizado: const Value(true),
      lastSync: Value(DateTime.now()),
    ));
    return result > 0;
  }

  // Watch movimientos (tiempo real)
  Stream<List<MovimientoTable>> watchMovimientos() {
    return (select(movimientos)..orderBy([(t) => OrderingTerm.desc(t.fechaMovimiento)]))
        .watch();
  }
}
