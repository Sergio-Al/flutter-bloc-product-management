import 'package:drift/drift.dart';
import 'package:flutter_management_system/data/datasources/local/database/tables/productos_table.dart';
import 'package:flutter_management_system/data/datasources/local/database/tables/proveedores_table.dart';

@DataClassName('LoteTable')
class Lotes extends Table {
  TextColumn get id => text()();
  TextColumn get numeroLote => text().unique()();
  TextColumn get productoId => text().references(Productos, #id)();
  DateTimeColumn get fechaFabricacion => dateTime().nullable()();
  DateTimeColumn get fechaVencimiento => dateTime().nullable()();
  TextColumn get proveedorId => text().nullable().references(Proveedores, #id)();
  TextColumn get numeroFactura => text().nullable()();
  IntColumn get cantidadInicial => integer().withDefault(const Constant(0))();
  IntColumn get cantidadActual => integer().withDefault(const Constant(0))();
  TextColumn get certificadoCalidadUrl => text().nullable()();
  TextColumn get observaciones => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get syncId => text().nullable()();
  DateTimeColumn get lastSync => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
