import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/roles_table.dart';

part 'rol_dao.g.dart';

@DriftAccessor(tables: [Roles])
class RolDao extends DatabaseAccessor<AppDatabase> with _$RolDaoMixin {
  RolDao(AppDatabase db) : super(db);

  // Obtener todos los roles
  Future<List<RolTable>> getAllRoles() {
    return (select(roles)
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.nombre)]))
        .get();
  }

  // Watch roles (tiempo real)
  Stream<List<RolTable>> watchRoles() {
    return (select(roles)
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.nombre)]))
        .watch();
  }

  // Obtener rol por ID
  Future<RolTable?> getRolById(String id) {
    return (select(roles)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // Obtener rol por nombre
  Future<RolTable?> getRolByNombre(String nombre) {
    return (select(roles)..where((tbl) => tbl.nombre.equals(nombre))).getSingleOrNull();
  }

  // Insertar o actualizar rol
  Future<int> insertOrUpdateRol(RolTable rol) {
    return into(roles).insertOnConflictUpdate(rol);
  }

  // Insertar múltiples roles (para sync)
  Future<void> insertMultipleRoles(List<RolTable> rolesList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(roles, rolesList);
    });
  }

  // Actualizar rol
  Future<bool> updateRol(RolTable rol) async {
    return update(roles).replace(rol);
  }

  // Eliminar rol
  Future<bool> deleteRol(String id) async {
    final result = await (delete(roles)..where((tbl) => tbl.id.equals(id))).go();
    return result > 0;
  }

  // Contar roles
  Future<int> countRoles() async {
    final count = countAll();
    final query = selectOnly(roles)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  // Verificar si un rol tiene ciertos permisos
  Future<bool> rolTienePermiso(String rolId, String permiso) async {
    final rol = await getRolById(rolId);
    if (rol == null) return false;
    return rol.permisos.contains(permiso);
  }
}
