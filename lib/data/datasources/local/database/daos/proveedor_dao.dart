import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/proveedores_table.dart';

part 'proveedor_dao.g.dart';

@DriftAccessor(tables: [Proveedores])
class ProveedorDao extends DatabaseAccessor<AppDatabase> with _$ProveedorDaoMixin {
  ProveedorDao(AppDatabase db) : super(db);

  // Obtener todos los proveedores activos
  Future<List<ProveedorTable>> getAllProveedores() {
    return (select(proveedores)
          ..where((tbl) => tbl.activo.equals(true) & tbl.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.razonSocial)]))
        .get();
  }

  // Watch proveedores (tiempo real)
  Stream<List<ProveedorTable>> watchProveedores() {
    return (select(proveedores)
          ..where((tbl) => tbl.activo.equals(true) & tbl.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.razonSocial)]))
        .watch();
  }

  // Obtener proveedor por ID
  Future<ProveedorTable?> getProveedorById(String id) {
    return (select(proveedores)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // Obtener proveedor por NIT
  Future<ProveedorTable?> getProveedorByNit(String nit) {
    return (select(proveedores)..where((tbl) => tbl.nit.equals(nit))).getSingleOrNull();
  }

  // Buscar proveedores
  Future<List<ProveedorTable>> searchProveedores(String query) {
    final searchTerm = '%${query.toLowerCase()}%';
    return (select(proveedores)
          ..where((tbl) =>
              (tbl.razonSocial.lower().like(searchTerm) |
                  tbl.nit.lower().like(searchTerm) |
                  tbl.nombreContacto.lower().like(searchTerm)) &
              tbl.activo.equals(true) &
              tbl.deletedAt.isNull()))
        .get();
  }

  // Obtener proveedores por tipo de material
  Future<List<ProveedorTable>> getProveedoresByTipoMaterial(String tipoMaterial) {
    return (select(proveedores)
          ..where((tbl) =>
              tbl.tipoMaterial.equals(tipoMaterial) &
              tbl.activo.equals(true) &
              tbl.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.razonSocial)]))
        .get();
  }

  // Obtener proveedores por ciudad
  Future<List<ProveedorTable>> getProveedoresByCiudad(String ciudad) {
    return (select(proveedores)
          ..where((tbl) =>
              tbl.ciudad.equals(ciudad) & tbl.activo.equals(true) & tbl.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.razonSocial)]))
        .get();
  }

  // Obtener proveedores con crédito
  Future<List<ProveedorTable>> getProveedoresConCredito() {
    return (select(proveedores)
          ..where((tbl) =>
              tbl.diasCredito.isBiggerThanValue(0) &
              tbl.activo.equals(true) &
              tbl.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.diasCredito)]))
        .get();
  }

  // Insertar proveedor
  Future<int> insertProveedor(ProveedorTable proveedor) {
    return into(proveedores).insert(
      ProveedoresCompanion.insert(
        id: proveedor.id,
        razonSocial: proveedor.razonSocial,
        nit: proveedor.nit,
        nombreContacto: Value(proveedor.nombreContacto),
        telefono: Value(proveedor.telefono),
        email: Value(proveedor.email),
        direccion: Value(proveedor.direccion),
        ciudad: Value(proveedor.ciudad),
        tipoMaterial: Value(proveedor.tipoMaterial),
        diasCredito: Value(proveedor.diasCredito),
        syncId: Value(proveedor.syncId),
      ),
    );
  }

  // Actualizar proveedor
  Future<bool> updateProveedor(ProveedorTable proveedor) async {
    final result = await (update(proveedores)..where((tbl) => tbl.id.equals(proveedor.id)))
        .write(ProveedoresCompanion(
      razonSocial: Value(proveedor.razonSocial),
      nombreContacto: Value(proveedor.nombreContacto),
      telefono: Value(proveedor.telefono),
      email: Value(proveedor.email),
      direccion: Value(proveedor.direccion),
      ciudad: Value(proveedor.ciudad),
      tipoMaterial: Value(proveedor.tipoMaterial),
      diasCredito: Value(proveedor.diasCredito),
      updatedAt: Value(DateTime.now()),
    ));
    return result > 0;
  }

  // Soft delete
  Future<bool> deleteProveedor(String id) async {
    final result = await (update(proveedores)..where((tbl) => tbl.id.equals(id)))
        .write(ProveedoresCompanion(
      activo: const Value(false),
      deletedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
    return result > 0;
  }

  // Obtener proveedores no sincronizados
  Future<List<ProveedorTable>> getProveedoresNoSincronizados() {
    return (select(proveedores)..where((tbl) => tbl.lastSync.isNull())).get();
  }

  // Marcar como sincronizado
  Future<bool> marcarComoSincronizado(String id) async {
    final result = await (update(proveedores)..where((tbl) => tbl.id.equals(id)))
        .write(ProveedoresCompanion(
      lastSync: Value(DateTime.now()),
    ));
    return result > 0;
  }
}
