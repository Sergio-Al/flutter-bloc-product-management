import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/lotes_table.dart';
import '../tables/productos_table.dart';
import '../tables/proveedores_table.dart';

part 'lote_dao.g.dart';

@DriftAccessor(tables: [Lotes, Productos, Proveedores])
class LoteDao extends DatabaseAccessor<AppDatabase> with _$LoteDaoMixin {
  LoteDao(AppDatabase db) : super(db);

  // Obtener todos los lotes
  Future<List<LoteTable>> getAllLotes() {
    return (select(lotes)..orderBy([(t) => OrderingTerm.desc(t.fechaFabricacion)])).get();
  }

  // Obtener lotes por producto
  Future<List<LoteTable>> getLotesByProducto(String productoId) {
    return (select(lotes)
          ..where((tbl) => tbl.productoId.equals(productoId))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaFabricacion)]))
        .get();
  }

  // Obtener lotes activos (con stock disponible)
  Future<List<LoteTable>> getLotesActivos() {
    return (select(lotes)
          ..where((tbl) => tbl.cantidadActual.isBiggerThanValue(0))
          ..orderBy([(t) => OrderingTerm.asc(t.fechaVencimiento)]))
        .get();
  }

  // Obtener lotes por vencer (próximos 30 días)
  Future<List<LoteTable>> getLotesPorVencer() {
    final now = DateTime.now();
    final treintaDias = now.add(const Duration(days: 30));
    
    return (select(lotes)
          ..where((tbl) =>
              tbl.fechaVencimiento.isNotNull() &
              tbl.fechaVencimiento.isBiggerOrEqualValue(now) &
              tbl.fechaVencimiento.isSmallerOrEqualValue(treintaDias) &
              tbl.cantidadActual.isBiggerThanValue(0))
          ..orderBy([(t) => OrderingTerm.asc(t.fechaVencimiento)]))
        .get();
  }

  // Obtener lotes vacios (sin stock disponible)
  Future<List<LoteTable>> getLotesVacios() {
    return (select(lotes)
          ..where((tbl) => tbl.cantidadActual.equals(0))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaFabricacion)]))
        .get();
  }

  // Buscar lotes por consulta
  Future<List<LoteTable>> searchLotes(String query) {
    final likeQuery = '%$query%';
    return (select(lotes)
          ..where((tbl) =>
              tbl.numeroLote.like(likeQuery) |
              tbl.numeroFactura.like(likeQuery) |
              tbl.observaciones.like(likeQuery)))
        .get();
  }

  // Obtener lote por factura
  Future<List<LoteTable>> getLotesByFactura(
    String numeroFactura,
  ) {
    return (select(lotes)
          ..where((tbl) => tbl.numeroFactura.equals(numeroFactura))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaFabricacion)]))
        .get();
  }

  // Obtener lotes con certificado de calidad
  Future<List<LoteTable>> getLotesConCertificado() {
    return (select(lotes)
          ..where((tbl) => tbl.certificadoCalidadUrl.isNotNull() &
              tbl.certificadoCalidadUrl.isNotValue(''))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaFabricacion)]))
        .get();
  }

  // Obtener lotes con stock disponible
  Future<List<LoteTable>> getLotesConStock() {
    return (select(lotes)
          ..where((tbl) => tbl.cantidadActual.isBiggerThanValue(0))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaFabricacion)]))
        .get();
  }

  // Obtener lotes vencidos
  Future<List<LoteTable>> getLotesVencidos() {
    final now = DateTime.now();
    
    return (select(lotes)
          ..where((tbl) =>
              tbl.fechaVencimiento.isNotNull() &
              tbl.fechaVencimiento.isSmallerThanValue(now) &
              tbl.cantidadActual.isBiggerThanValue(0))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaVencimiento)]))
        .get();
  }

  // Obtener lote por número
  Future<LoteTable?> getLoteByNumero(String numeroLote) {
    return (select(lotes)..where((tbl) => tbl.numeroLote.equals(numeroLote))).getSingleOrNull();
  }

  // Obtener lote por ID
  Future<LoteTable?> getLoteById(String id) {
    return (select(lotes)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // Obtener lotes por proveedor
  Future<List<LoteTable>> getLotesByProveedor(String proveedorId) {
    return (select(lotes)
          ..where((tbl) => tbl.proveedorId.equals(proveedorId))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaFabricacion)]))
        .get();
  }

  // Watch lotes (tiempo real)
  Stream<List<LoteTable>> watchLotes() {
    return (select(lotes)..orderBy([(t) => OrderingTerm.desc(t.fechaFabricacion)])).watch();
  }

  // Watch lotes por producto
  Stream<List<LoteTable>> watchLotesByProducto(String productoId) {
    return (select(lotes)
          ..where((tbl) => tbl.productoId.equals(productoId))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaFabricacion)]))
        .watch();
  }

  // Insertar lote
  Future<int> insertLote(LoteTable lote) async {

    // get all productos and proveedores to verify foreign keys
    final allProductos = await select(productos).get();
    final allProveedores = await select(proveedores).get();

    print('Verifying foreign keys for lote insertion:');
    print('Total productos in local DB: ${allProductos.length}');
    print('Total proveedores in local DB: ${allProveedores.length}');

    // Verify that producto exists in local database
    final producto = await (select(productos)..where((t) => t.id.equals(lote.productoId))).getSingleOrNull();
    if (producto == null) {
      throw Exception('Producto with id ${lote.productoId} does not exist in local database. Please sync productos first.');
    }

    // Verify that proveedor exists if provided
    if (lote.proveedorId != null) {
      final proveedor = await (select(proveedores)..where((t) => t.id.equals(lote.proveedorId!))).getSingleOrNull();
      if (proveedor == null) {
        throw Exception('Proveedor with id ${lote.proveedorId} does not exist in local database. Please sync proveedores first.');
      }
    }

    return into(lotes).insert(
      LotesCompanion.insert(
        id: lote.id,
        numeroLote: lote.numeroLote,
        productoId: lote.productoId,
        proveedorId: Value(lote.proveedorId),
        fechaFabricacion: Value(lote.fechaFabricacion),
        fechaVencimiento: Value(lote.fechaVencimiento),
        numeroFactura: Value(lote.numeroFactura),
        cantidadInicial: Value(lote.cantidadInicial),
        cantidadActual: Value(lote.cantidadActual),
        certificadoCalidadUrl: Value(lote.certificadoCalidadUrl),
        observaciones: Value(lote.observaciones),
        syncId: Value(lote.syncId),
      ),
    );
  }

  // Actualizar cantidad de lote
  Future<bool> updateCantidadLote(String id, int nuevaCantidad) async {
    final result = await (update(lotes)..where((tbl) => tbl.id.equals(id)))
        .write(LotesCompanion(
      cantidadActual: Value(nuevaCantidad),
      updatedAt: Value(DateTime.now()),
    ));
    return result > 0;
  }

  // Decrementar stock de lote
  Future<void> decrementarStockLote(String id, int cantidad) async {
    final lote = await (select(lotes)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

    if (lote != null) {
      final nuevaCantidad = lote.cantidadActual - cantidad;
      if (nuevaCantidad >= 0) {
        await updateCantidadLote(id, nuevaCantidad);
      } else {
        throw Exception('Stock de lote insuficiente');
      }
    }
  }

  // Obtener lotes no sincronizados
  Future<List<LoteTable>> getLotesNoSincronizados() {
    return (select(lotes)..where((tbl) => tbl.lastSync.isNull())).get();
  }

  // Marcar como sincronizado
  Future<bool> marcarComoSincronizado(String id) async {
    final result = await (update(lotes)..where((tbl) => tbl.id.equals(id)))
        .write(LotesCompanion(
      lastSync: Value(DateTime.now()),
    ));
    return result > 0;
  }

  // Actualizar lote completo
  Future<bool> updateLote(LoteTable lote) async {
    final result = await (update(lotes)..where((tbl) => tbl.id.equals(lote.id)))
        .write(LotesCompanion(
      numeroLote: Value(lote.numeroLote),
      productoId: Value(lote.productoId),
      proveedorId: Value(lote.proveedorId),
      fechaFabricacion: Value(lote.fechaFabricacion),
      fechaVencimiento: Value(lote.fechaVencimiento),
      numeroFactura: Value(lote.numeroFactura),
      cantidadInicial: Value(lote.cantidadInicial),
      cantidadActual: Value(lote.cantidadActual),
      certificadoCalidadUrl: Value(lote.certificadoCalidadUrl),
      observaciones: Value(lote.observaciones),
      updatedAt: Value(DateTime.now()),
    ));
    return result > 0;
  }

  // Eliminar lote (hard delete - usar con cuidado)
  // NOTA: Esto puede romper referencias en inventarios/movimientos
  // Considerar usar soft delete en su lugar
  Future<bool> deleteLote(String id) async {
    final result = await (delete(lotes)..where((tbl) => tbl.id.equals(id))).go();
    return result > 0;
  }

  // Soft delete - marca lote como inactivo sin eliminarlo
  // RECOMENDADO: Usar esto en lugar de deleteLote()
  // Requiere agregar campo 'activo' a la tabla lotes
  // Future<bool> desactivarLote(String id) async {
  //   final result = await (update(lotes)..where((tbl) => tbl.id.equals(id)))
  //       .write(LotesCompanion(
  //     activo: const Value(false),
  //     updatedAt: Value(DateTime.now()),
  //   ));
  //   return result > 0;
  // }
}
