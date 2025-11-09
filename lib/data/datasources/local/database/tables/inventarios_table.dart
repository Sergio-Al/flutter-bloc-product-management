import 'package:drift/drift.dart';
import 'package:flutter_management_system/data/datasources/local/database/tables/almacenes_table.dart';
import 'package:flutter_management_system/data/datasources/local/database/tables/lotes_table.dart';
import 'package:flutter_management_system/data/datasources/local/database/tables/productos_table.dart';
import 'package:flutter_management_system/data/datasources/local/database/tables/tiendas_table.dart';

@DataClassName('InventarioTable')
class Inventarios extends Table {
  TextColumn get id => text()();
  TextColumn get productoId => text().references(Productos, #id)();
  TextColumn get almacenId => text().references(Almacenes, #id)();
  TextColumn get tiendaId => text().references(Tiendas, #id)();
  TextColumn get loteId => text().nullable().references(Lotes, #id)();
  IntColumn get cantidadActual => integer().withDefault(const Constant(0))();
  IntColumn get cantidadReservada => integer().withDefault(const Constant(0))();
  IntColumn get cantidadDisponible => integer().withDefault(const Constant(0))();
  RealColumn get valorTotal => real().withDefault(const Constant(0.0))();
  TextColumn get ubicacionFisica => text().nullable()();
  DateTimeColumn get ultimaActualizacion => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get syncId => text().nullable()();
  DateTimeColumn get lastSync => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
