import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/usuarios_table.dart';

part 'usuario_dao.g.dart';

@DriftAccessor(tables: [Usuarios])
class UsuarioDao extends DatabaseAccessor<AppDatabase> with _$UsuarioDaoMixin {
  UsuarioDao(AppDatabase db) : super(db);

  Future<UsuarioTable?> getUsuarioByEmail(String email) {
    return (select(usuarios)..where((tbl) => tbl.email.equals(email))).getSingleOrNull();
  }

  Future<UsuarioTable?> getUsuarioById(String id) {
    return (select(usuarios)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<List<UsuarioTable>> getAllUsuarios() {
    return (select(usuarios)
          ..where((tbl) => tbl.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.nombreCompleto)]))
        .get();
  }

  Future<List<UsuarioTable>> getUsuariosActivos() {
    return (select(usuarios)
          ..where((tbl) => tbl.activo.equals(true) & tbl.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.nombreCompleto)]))
        .get();
  }

  Future<List<UsuarioTable>> getUsuariosByTienda(String tiendaId) {
    return (select(usuarios)
          ..where((tbl) =>
              tbl.tiendaId.equals(tiendaId) & tbl.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.nombreCompleto)]))
        .get();
  }

  Future<List<UsuarioTable>> getUsuariosByRol(String rolId) {
    return (select(usuarios)
          ..where(
              (tbl) => tbl.rolId.equals(rolId) & tbl.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.nombreCompleto)]))
        .get();
  }

  Future<List<UsuarioTable>> searchUsuarios(String query) {
    final searchTerm = '%${query.toLowerCase()}%';
    return (select(usuarios)
          ..where((tbl) =>
              (tbl.nombreCompleto.lower().like(searchTerm) |
                  tbl.email.lower().like(searchTerm)) &
              tbl.deletedAt.isNull()))
        .get();
  }

  Future<int> insertUsuario(UsuarioTable usuario) {
    return into(usuarios).insert(UsuariosCompanion.insert(
      id: usuario.id,
      email: usuario.email,
      nombreCompleto: usuario.nombreCompleto,
      rolId: usuario.rolId,
      tiendaId: Value(usuario.tiendaId),
      telefono: Value(usuario.telefono),
    ));
  }

  Future<bool> updateUsuario(UsuarioTable usuario) async {
    final result = await (update(usuarios)
          ..where((tbl) => tbl.id.equals(usuario.id)))
        .write(UsuariosCompanion(
      email: Value(usuario.email),
      nombreCompleto: Value(usuario.nombreCompleto),
      telefono: Value(usuario.telefono),
      tiendaId: Value(usuario.tiendaId),
      rolId: Value(usuario.rolId),
      activo: Value(usuario.activo),
      updatedAt: Value(DateTime.now()),
    ));
    return result > 0;
  }

  Future<bool> deleteUsuario(String id) async {
    final result = await (update(usuarios)..where((tbl) => tbl.id.equals(id)))
        .write(UsuariosCompanion(
      deletedAt: Value(DateTime.now()),
      activo: const Value(false),
      updatedAt: Value(DateTime.now()),
    ));
    return result > 0;
  }

  Future<bool> toggleUsuarioActivo(String id, {required bool activo}) async {
    final result = await (update(usuarios)..where((tbl) => tbl.id.equals(id)))
        .write(UsuariosCompanion(
      activo: Value(activo),
      updatedAt: Value(DateTime.now()),
    ));
    return result > 0;
  }

  /// Insert or update usuario (for syncing authenticated user to local DB)
  Future<void> upsertUsuario(UsuarioTable usuario) async {
    await into(usuarios).insertOnConflictUpdate(UsuariosCompanion.insert(
      id: usuario.id,
      email: usuario.email,
      nombreCompleto: usuario.nombreCompleto,
      rolId: usuario.rolId,
      tiendaId: Value(usuario.tiendaId),
      telefono: Value(usuario.telefono),
      activo: Value(usuario.activo),
      syncId: Value(usuario.syncId),
    ));
  }
}

