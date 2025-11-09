import 'package:drift/drift.dart';
import 'package:flutter_management_system/data/datasources/local/database/tables/categorias_table.dart';
import 'package:flutter_management_system/data/datasources/local/database/tables/proveedores_table.dart';
import 'package:flutter_management_system/data/datasources/local/database/tables/unidades_medida_table.dart';

@DataClassName('ProductoTable')
class Productos extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get codigo => text().unique()();
  TextColumn get descripcion => text().nullable()();
  TextColumn get categoriaId => text().references(Categorias, #id)();
  TextColumn get unidadMedidaId => text().references(UnidadesMedida, #id)();
  TextColumn get proveedorPrincipalId => text().nullable().references(Proveedores, #id)();
  RealColumn get precioCompra => real().withDefault(const Constant(0.0))();
  RealColumn get precioVenta => real().withDefault(const Constant(0.0))();
  RealColumn get pesoUnitarioKg => real().nullable()();
  RealColumn get volumenUnitarioM3 => real().nullable()();
  IntColumn get stockMinimo => integer().withDefault(const Constant(0))();
  IntColumn get stockMaximo => integer().withDefault(const Constant(0))();
  TextColumn get marca => text().nullable()();
  TextColumn get gradoCalidad => text().nullable()();
  TextColumn get normaTecnica => text().nullable()();
  BoolColumn get requiereAlmacenCubierto => boolean().withDefault(const Constant(false))();
  BoolColumn get materialPeligroso => boolean().withDefault(const Constant(false))();
  TextColumn get imagenUrl => text().nullable()();
  TextColumn get fichaTecnicaUrl => text().nullable()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncId => text().nullable()();
  DateTimeColumn get lastSync => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
