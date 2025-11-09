import 'package:drift/drift.dart';
import 'package:flutter_management_system/data/datasources/local/database/tables/tiendas_table.dart';

@DataClassName('AlmacenTable')
class Almacenes extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get codigo => text().unique()();
  TextColumn get tiendaId => text().references(Tiendas, #id)();
  TextColumn get ubicacion => text()();
  TextColumn get tipo => text()(); // Principal, Obra, Transito
  RealColumn get capacidadM3 => real().nullable()();
  RealColumn get areaM2 => real().nullable()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncId => text().nullable()();
  DateTimeColumn get lastSync => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
