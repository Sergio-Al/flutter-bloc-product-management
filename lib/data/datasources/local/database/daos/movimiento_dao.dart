import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/movimientos_table.dart';
import '../tables/productos_table.dart';

part 'movimiento_dao.g.dart';

@DriftAccessor(tables: [Movimientos, Productos])
class MovimientoDao extends DatabaseAccessor<AppDatabase> with _$MovimientoDaoMixin {
  MovimientoDao(AppDatabase db) : super(db);

  // ⚠️ NOTA IMPORTANTE: NO HAY MÉTODO deleteMovimiento()
  // Los movimientos son registros de auditoría y NO deben eliminarse.
  // - Requeridos para cumplimiento legal (autoridades fiscales)
  // - Necesarios para integridad de inventario
  // - Críticos para registros contables
  // Usar updateEstadoMovimiento() para cambiar a 'CANCELADO' en su lugar.

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

  // Obtener movimientos por usuario
  Future<List<MovimientoTable>> getMovimientosByUsuario(String usuarioId) {
    return (select(movimientos)
          ..where((tbl) => tbl.usuarioId.equals(usuarioId))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaMovimiento)]))
        .get();
  }

  // Obtener movimientos por producto
  Future<List<MovimientoTable>> getMovimientosByProducto(String productoId) {
    return (select(movimientos)
          ..where((tbl) => tbl.productoId.equals(productoId))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaMovimiento)]))
        .get();
  }

  // Obtener movimientos por id
  Future<MovimientoTable?> getMovimientoById(String id) {
    return (select(movimientos)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // Obtener movimientos por tienda
  Future<List<MovimientoTable>> getMovimientosByTienda(String tiendaId) {
    return (select(movimientos)
          ..where((tbl) =>
              tbl.tiendaOrigenId.equals(tiendaId) | tbl.tiendaDestinoId.equals(tiendaId))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaMovimiento)]))
        .get();
  }

  // Obtener movimientos por estado
  Future<List<MovimientoTable>> getMovimientosByEstado(String estado) {
    return (select(movimientos)
          ..where((tbl) => tbl.estado.equals(estado))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaMovimiento)]))
        .get();
  }

  // Obtener movimientos por numero de movimiento
  Future<MovimientoTable?> getMovimientoByNumero(String numeroMovimiento) {
    return (select(movimientos)
          ..where((tbl) => tbl.numeroMovimiento.equals(numeroMovimiento)))
        .getSingleOrNull();
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
      tipo: movimiento.tipo,
      cantidad: movimiento.cantidad,
      usuarioId: movimiento.usuarioId,
      estado: movimiento.estado,
      inventarioId: Value(movimiento.inventarioId),
      loteId: Value(movimiento.loteId),
      tiendaOrigenId: Value(movimiento.tiendaOrigenId),
      tiendaDestinoId: Value(movimiento.tiendaDestinoId),
      proveedorId: Value(movimiento.proveedorId),
      motivo: Value(movimiento.motivo),
      costoUnitario: Value(movimiento.costoUnitario),
      costoTotal: Value(movimiento.costoTotal),
      pesoTotalKg: Value(movimiento.pesoTotalKg),
      numeroFactura: Value(movimiento.numeroFactura),
      numeroGuiaRemision: Value(movimiento.numeroGuiaRemision),
      vehiculoPlaca: Value(movimiento.vehiculoPlaca),
      conductor: Value(movimiento.conductor),
      observaciones: Value(movimiento.observaciones),
      syncId: Value(movimiento.syncId),
    ));
  }

  // Actualizar movimiento completo
  // ⚠️ SOLO debe usarse para movimientos en estado PENDIENTE
  // Los movimientos completados/en tránsito/cancelados NO deben modificarse
  Future<bool> updateMovimiento(MovimientoTable movimiento) async {
    // Validación: solo permitir edición si está PENDIENTE
    final existing = await getMovimientoById(movimiento.id);
    if (existing == null) {
      throw Exception('Movimiento no encontrado');
    }
    
    if (existing.estado != 'PENDIENTE') {
      throw Exception(
        'Solo los movimientos PENDIENTES pueden editarse. Estado actual: ${existing.estado}',
      );
    }

    final result = await (update(movimientos)..where((tbl) => tbl.id.equals(movimiento.id)))
        .write(MovimientosCompanion(
      numeroMovimiento: Value(movimiento.numeroMovimiento),
      productoId: Value(movimiento.productoId),
      inventarioId: Value(movimiento.inventarioId),
      loteId: Value(movimiento.loteId),
      tiendaOrigenId: Value(movimiento.tiendaOrigenId),
      tiendaDestinoId: Value(movimiento.tiendaDestinoId),
      proveedorId: Value(movimiento.proveedorId),
      tipo: Value(movimiento.tipo),
      motivo: Value(movimiento.motivo),
      cantidad: Value(movimiento.cantidad),
      costoUnitario: Value(movimiento.costoUnitario),
      costoTotal: Value(movimiento.costoTotal),
      pesoTotalKg: Value(movimiento.pesoTotalKg),
      usuarioId: Value(movimiento.usuarioId),
      estado: Value(movimiento.estado),
      fechaMovimiento: Value(movimiento.fechaMovimiento),
      numeroFactura: Value(movimiento.numeroFactura),
      numeroGuiaRemision: Value(movimiento.numeroGuiaRemision),
      vehiculoPlaca: Value(movimiento.vehiculoPlaca),
      conductor: Value(movimiento.conductor),
      observaciones: Value(movimiento.observaciones),
      updatedAt: Value(DateTime.now()),
    ));
    return result > 0;
  }

  // Actualizar estado de movimiento
  // Usar este método para cambios de estado del workflow (PENDIENTE → EN_TRANSITO → COMPLETADO)
  Future<bool> updateEstadoMovimiento(String id, String nuevoEstado) async {
    final result = await (update(movimientos)..where((tbl) => tbl.id.equals(id)))
        .write(MovimientosCompanion(
      estado: Value(nuevoEstado),
      updatedAt: Value(DateTime.now()),
    ));
    return result > 0;
  }

  // Actualizar observaciones (usado para agregar motivo de cancelación)
  Future<bool> updateObservaciones(String id, String observaciones) async {
    final result = await (update(movimientos)..where((tbl) => tbl.id.equals(id)))
        .write(MovimientosCompanion(
      observaciones: Value(observaciones),
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
