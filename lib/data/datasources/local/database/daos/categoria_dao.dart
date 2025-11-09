import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/categorias_table.dart';

part 'categoria_dao.g.dart';

@DriftAccessor(tables: [Categorias])
class CategoriaDao extends DatabaseAccessor<AppDatabase> with _$CategoriaDaoMixin {
  CategoriaDao(AppDatabase db) : super(db);

  // Obtener todas las categorías activas
  Future<List<CategoriaTable>> getAllCategorias() {
    return (select(categorias)
          ..where((tbl) => tbl.activo.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
        .get();
  }

  // Obtener categorías principales (sin padre)
  Future<List<CategoriaTable>> getCategoriasPrincipales() {
    return (select(categorias)
          ..where((tbl) => tbl.categoriaPadreId.isNull() & tbl.activo.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
        .get();
  }

  // Obtener subcategorías de una categoría
  Future<List<CategoriaTable>> getSubcategorias(String categoriaPadreId) {
    return (select(categorias)
          ..where((tbl) =>
              tbl.categoriaPadreId.equals(categoriaPadreId) & tbl.activo.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
        .get();
  }

  // Obtener categoría por ID
  Future<CategoriaTable?> getCategoriaById(String id) {
    return (select(categorias)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // Obtener categoría por código
  Future<CategoriaTable?> getCategoriaByCodigo(String codigo) {
    return (select(categorias)..where((tbl) => tbl.codigo.equals(codigo))).getSingleOrNull();
  }

  // Buscar categorías
  Future<List<CategoriaTable>> searchCategorias(String query) {
    final searchTerm = '%${query.toLowerCase()}%';
    return (select(categorias)
          ..where((tbl) =>
              (tbl.nombre.lower().like(searchTerm) | tbl.codigo.lower().like(searchTerm)) &
              tbl.activo.equals(true)))
        .get();
  }

  // Obtener categorías que requieren lote
  Future<List<CategoriaTable>> getCategoriasConLote() {
    return (select(categorias)
          ..where((tbl) => tbl.requiereLote.equals(true) & tbl.activo.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
        .get();
  }

  // Obtener categorías que requieren certificación
  Future<List<CategoriaTable>> getCategoriasConCertificacion() {
    return (select(categorias)
          ..where((tbl) => tbl.requiereCertificacion.equals(true) & tbl.activo.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
        .get();
  }

  // Watch categorías (tiempo real)
  Stream<List<CategoriaTable>> watchCategorias() {
    return (select(categorias)
          ..where((tbl) => tbl.activo.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
        .watch();
  }

  // Watch categorías principales
  Stream<List<CategoriaTable>> watchCategoriasPrincipales() {
    return (select(categorias)
          ..where((tbl) => tbl.categoriaPadreId.isNull() & tbl.activo.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
        .watch();
  }

  // Insertar categoría
  Future<int> insertCategoria(CategoriaTable categoria) {
    return into(categorias).insert(
      CategoriasCompanion.insert(
        id: categoria.id,
        nombre: categoria.nombre,
        codigo: categoria.codigo,
        descripcion: Value(categoria.descripcion),
        categoriaPadreId: Value(categoria.categoriaPadreId),
        requiereLote: Value(categoria.requiereLote),
        requiereCertificacion: Value(categoria.requiereCertificacion),
        syncId: Value(categoria.syncId),
      ),
    );
  }

  // Actualizar categoría
  Future<bool> updateCategoria(CategoriaTable categoria) async {
    final result = await (update(categorias)..where((tbl) => tbl.id.equals(categoria.id)))
        .write(CategoriasCompanion(
      nombre: Value(categoria.nombre),
      descripcion: Value(categoria.descripcion),
      categoriaPadreId: Value(categoria.categoriaPadreId),
      requiereLote: Value(categoria.requiereLote),
      requiereCertificacion: Value(categoria.requiereCertificacion),
      updatedAt: Value(DateTime.now()),
    ));
    return result > 0;
  }

  // Desactivar categoría
  Future<bool> desactivarCategoria(String id) async {
    final result = await (update(categorias)..where((tbl) => tbl.id.equals(id)))
        .write(CategoriasCompanion(
      activo: const Value(false),
      updatedAt: Value(DateTime.now()),
    ));
    return result > 0;
  }

  // Activar categoría
  Future<bool> activarCategoria(String id) async {
    final result = await (update(categorias)..where((tbl) => tbl.id.equals(id)))
        .write(CategoriasCompanion(
      activo: const Value(true),
      updatedAt: Value(DateTime.now()),
    ));
    return result > 0;
  }

  // Obtener categorías no sincronizadas
  Future<List<CategoriaTable>> getCategoriasNoSincronizadas() {
    return (select(categorias)..where((tbl) => tbl.lastSync.isNull())).get();
  }

  // Marcar como sincronizada
  Future<bool> marcarComoSincronizada(String id) async {
    final result = await (update(categorias)..where((tbl) => tbl.id.equals(id)))
        .write(CategoriasCompanion(
      lastSync: Value(DateTime.now()),
    ));
    return result > 0;
  }

  // Verificar si tiene subcategorías
  Future<bool> tieneSubcategorias(String categoriaId) async {
    final count = await (selectOnly(categorias)
          ..addColumns([categorias.id.count()])
          ..where(categorias.categoriaPadreId.equals(categoriaId)))
        .getSingle();

    return (count.read(categorias.id.count()) ?? 0) > 0;
  }


  // Obtener árbol de categorías (categoría con sus hijos)
  Future<Map<CategoriaTable, List<CategoriaTable>>> getArbolCategorias() async {
    final principales = await getCategoriasPrincipales();
    final Map<CategoriaTable, List<CategoriaTable>> arbol = {};

    for (final categoria in principales) {
      final subcategorias = await getSubcategorias(categoria.id);
      arbol[categoria] = subcategorias;
    }

    return arbol;
  }
}
