import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/unidades_medida_table.dart';

part 'unidad_medida_dao.g.dart';

@DriftAccessor(tables: [UnidadesMedida])
class UnidadMedidaDao extends DatabaseAccessor<AppDatabase> with _$UnidadMedidaDaoMixin {
  UnidadMedidaDao(AppDatabase db) : super(db);

  // Obtener todas las unidades de medida
  Future<List<UnidadMedidaTable>> getAllUnidades() {
    return (select(unidadesMedida)
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.nombre)]))
        .get();
  }

  // Watch unidades (tiempo real)
  Stream<List<UnidadMedidaTable>> watchUnidades() {
    return (select(unidadesMedida)
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.nombre)]))
        .watch();
  }

  // Obtener unidad por ID
  Future<UnidadMedidaTable?> getUnidadById(String id) {
    return (select(unidadesMedida)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // Obtener unidad por abreviatura
  Future<UnidadMedidaTable?> getUnidadByAbreviatura(String abreviatura) {
    return (select(unidadesMedida)..where((tbl) => tbl.abreviatura.equals(abreviatura))).getSingleOrNull();
  }

  // Insertar o actualizar unidad
  Future<int> insertOrUpdateUnidad(UnidadMedidaTable unidad) {
    return into(unidadesMedida).insertOnConflictUpdate(unidad);
  }

  // Insertar múltiples unidades (para sync)
  Future<void> insertMultipleUnidades(List<UnidadMedidaTable> unidades) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(unidadesMedida, unidades);
    });
  }

  // Actualizar unidad
  Future<bool> updateUnidad(UnidadMedidaTable unidad) async {
    return update(unidadesMedida).replace(unidad);
  }

  // Eliminar unidad
  Future<bool> deleteUnidad(String id) async {
    final result = await (delete(unidadesMedida)..where((tbl) => tbl.id.equals(id))).go();
    return result > 0;
  }

  // Contar unidades
  Future<int> countUnidades() async {
    final count = countAll();
    final query = selectOnly(unidadesMedida)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  // Buscar unidades por nombre o abreviatura
  Future<List<UnidadMedidaTable>> searchUnidades(String searchTerm) {
    return (select(unidadesMedida)
          ..where((tbl) =>
              tbl.nombre.like('%$searchTerm%') | tbl.abreviatura.like('%$searchTerm%'))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.nombre)]))
        .get();
  }
}
