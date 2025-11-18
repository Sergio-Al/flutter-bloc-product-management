import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/tiendas_table.dart';

part 'tienda_dao.g.dart';

@DriftAccessor(tables: [Tiendas])
class TiendaDao extends DatabaseAccessor<AppDatabase> with _$TiendaDaoMixin {
  TiendaDao(AppDatabase db) : super(db);

  // Obtener todas las tiendas 
  Future<List<TiendaTable>> getAllTiendas() {
    return (select(tiendas)
          ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
        .get();
  }

  // Obtener todas las tiendas activas
  Future<List<TiendaTable>> getTiendasActivas() {
    return (select(tiendas)
          ..where((tbl) => tbl.activo.equals(true) & tbl.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
        .get();
  }

  // Watch tiendas (tiempo real)
  Stream<List<TiendaTable>> watchTiendas() {
    return (select(tiendas)
          ..where((tbl) => tbl.activo.equals(true) & tbl.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
        .watch();
  }

  // Obtener tienda por ID
  Future<TiendaTable?> getTiendaById(String id) {
    return (select(tiendas)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // Obtener tienda por código
  Future<TiendaTable?> getTiendaByCodigo(String codigo) {
    return (select(tiendas)..where((tbl) => tbl.codigo.equals(codigo))).getSingleOrNull();
  }

  // Buscar tiendas por nombre o ciudad
  Future<List<TiendaTable>> searchTiendas(String query) {
    final searchTerm = '%${query.toLowerCase()}%';
    return (select(tiendas)
          ..where((tbl) =>
              (tbl.nombre.lower().like(searchTerm) |
                  tbl.ciudad.lower().like(searchTerm) |
                  tbl.codigo.lower().like(searchTerm)) &
              tbl.activo.equals(true) &
              tbl.deletedAt.isNull()))
        .get();
  }

  // Obtener tiendas por ciudad
  Future<List<TiendaTable>> getTiendasByCiudad(String ciudad) {
    return (select(tiendas)
          ..where((tbl) =>
              tbl.ciudad.equals(ciudad) & tbl.activo.equals(true) & tbl.deletedAt.isNull()))
        .get();
  }

  // Obtener tiendas por departamento
  Future<List<TiendaTable>> getTiendasByDepartamento(String departamento) {
    return (select(tiendas)
          ..where((tbl) =>
              tbl.departamento.equals(departamento) &
              tbl.activo.equals(true) &
              tbl.deletedAt.isNull()))
        .get();
  }

  // Insertar tienda
  Future<int> insertTienda(TiendaTable tienda) {
    return into(tiendas).insert(
      TiendasCompanion.insert(
        id: tienda.id,
        nombre: tienda.nombre,
        codigo: tienda.codigo,
        direccion: tienda.direccion,
        ciudad: tienda.ciudad,
        departamento: tienda.departamento,
        telefono: Value(tienda.telefono),
        horarioAtencion: Value(tienda.horarioAtencion),
        syncId: Value(tienda.syncId),
      ),
    );
  }

  // Actualizar tienda
  Future<bool> updateTienda(TiendaTable tienda) async {
    final result = await (update(tiendas)..where((tbl) => tbl.id.equals(tienda.id)))
        .write(TiendasCompanion(
      nombre: Value(tienda.nombre),
      direccion: Value(tienda.direccion),
      ciudad: Value(tienda.ciudad),
      departamento: Value(tienda.departamento),
      telefono: Value(tienda.telefono),
      horarioAtencion: Value(tienda.horarioAtencion),
      updatedAt: Value(DateTime.now()),
    ));
    return result > 0;
  }

  // Soft delete
  Future<bool> deleteTienda(String id) async {
    final result = await (update(tiendas)..where((tbl) => tbl.id.equals(id)))
        .write(TiendasCompanion(
      activo: const Value(false),
      deletedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
    return result > 0;
  }

  // Activar/Desactivar tienda
  Future<bool> toggleActivoTienda(String id, bool activo) async {
    final result = await (update(tiendas)..where((tbl) => tbl.id.equals(id)))
        .write(TiendasCompanion(
      activo: Value(activo),
      updatedAt: Value(DateTime.now()),
    ));
    return result > 0;
  }

  // Obtener tiendas no sincronizadas
  Future<List<TiendaTable>> getTiendasNoSincronizadas() {
    return (select(tiendas)..where((tbl) => tbl.lastSync.isNull())).get();
  }

  // Marcar como sincronizada
  Future<bool> marcarComoSincronizada(String id) async {
    final result = await (update(tiendas)..where((tbl) => tbl.id.equals(id)))
        .write(TiendasCompanion(
      lastSync: Value(DateTime.now()),
    ));
    return result > 0;
  }
}
