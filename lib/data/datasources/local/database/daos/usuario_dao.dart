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
}
