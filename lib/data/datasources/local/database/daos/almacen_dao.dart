import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/almacenes_table.dart';
import '../tables/tiendas_table.dart';

part 'almacen_dao.g.dart';

@DriftAccessor(tables: [Almacenes, Tiendas])
class AlmacenDao extends DatabaseAccessor<AppDatabase> with _$AlmacenDaoMixin {
  AlmacenDao(AppDatabase db) : super(db);

  // Obtener todos los almacenes
  Future<List<AlmacenTable>> getAllAlmacenes() {
    return (select(almacenes)
          ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
        .get();
  }

  // Obtener todos los almacenes activos
  Future<List<AlmacenTable>> getAlmacenesActivos() {
    return (select(almacenes)
          ..where((tbl) => tbl.activo.equals(true) & tbl.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
        .get();
  }

  // Obtener el almacén principal por tienda
  Future<AlmacenTable?> getAlmacenPrincipal(String tiendaId) {
    return (select(almacenes)
          ..where((tbl) =>
              tbl.tiendaId.equals(tiendaId) &
              tbl.tipo.equals('Principal') &
              tbl.activo.equals(true) &
              tbl.deletedAt.isNull()))
        .getSingleOrNull();
  }

  // Obtener almacenes por tienda
  Future<List<AlmacenTable>> getAlmacenesByTienda(String tiendaId) {
    return (select(almacenes)
          ..where((tbl) =>
              tbl.tiendaId.equals(tiendaId) & tbl.activo.equals(true) & tbl.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
        .get();
  }

  // Watch almacenes por tienda (tiempo real)
  Stream<List<AlmacenTable>> watchAlmacenesByTienda(String tiendaId) {
    return (select(almacenes)
          ..where((tbl) =>
              tbl.tiendaId.equals(tiendaId) & tbl.activo.equals(true) & tbl.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
        .watch();
  }

  // Obtener almacén por ID
  Future<AlmacenTable?> getAlmacenById(String id) {
    return (select(almacenes)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // Obtener almacén por código
  Future<AlmacenTable?> getAlmacenByCodigo(String codigo) {
    return (select(almacenes)..where((tbl) => tbl.codigo.equals(codigo))).getSingleOrNull();
  }

  // Obtener almacenes por tipo
  Future<List<AlmacenTable>> getAlmacenesByTipo(String tipo) {
    return (select(almacenes)
          ..where((tbl) =>
              tbl.tipo.equals(tipo) & tbl.activo.equals(true) & tbl.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
        .get();
  }

  // Buscar almacenes
  Future<List<AlmacenTable>> searchAlmacenes(String query) {
    final searchTerm = '%${query.toLowerCase()}%';
    return (select(almacenes)
          ..where((tbl) =>
              (tbl.nombre.lower().like(searchTerm) |
                  tbl.codigo.lower().like(searchTerm) |
                  tbl.ubicacion.lower().like(searchTerm)) &
              tbl.activo.equals(true) &
              tbl.deletedAt.isNull()))
        .get();
  }

  // Insertar almacén
  Future<int> insertAlmacen(AlmacenTable almacen) {
    return into(almacenes).insert(
      AlmacenesCompanion.insert(
        id: almacen.id,
        nombre: almacen.nombre,
        codigo: almacen.codigo,
        tiendaId: almacen.tiendaId,
        ubicacion: almacen.ubicacion,
        tipo: almacen.tipo,
        capacidadM3: Value(almacen.capacidadM3),
        areaM2: Value(almacen.areaM2),
        syncId: Value(almacen.syncId),
      ),
    );
  }

  // Actualizar almacén
  Future<bool> updateAlmacen(AlmacenTable almacen) async {
    final result = await (update(almacenes)..where((tbl) => tbl.id.equals(almacen.id)))
        .write(AlmacenesCompanion(
      nombre: Value(almacen.nombre),
      ubicacion: Value(almacen.ubicacion),
      tipo: Value(almacen.tipo),
      capacidadM3: Value(almacen.capacidadM3),
      areaM2: Value(almacen.areaM2),
      updatedAt: Value(DateTime.now()),
    ));
    return result > 0;
  }

  // Soft delete
  Future<bool> deleteAlmacen(String id) async {
    final result = await (update(almacenes)..where((tbl) => tbl.id.equals(id)))
        .write(AlmacenesCompanion(
      activo: const Value(false),
      deletedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
    return result > 0;
  }

  // Obtener almacenes no sincronizados
  Future<List<AlmacenTable>> getAlmacenesNoSincronizados() {
    return (select(almacenes)..where((tbl) => tbl.lastSync.isNull())).get();
  }

  // Marcar como sincronizado
  Future<bool> marcarComoSincronizado(String id) async {
    final result = await (update(almacenes)..where((tbl) => tbl.id.equals(id)))
        .write(AlmacenesCompanion(
      lastSync: Value(DateTime.now()),
    ));
    return result > 0;
  }





}
