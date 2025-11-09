import 'package:drift/drift.dart';
import 'package:flutter_management_system/data/datasources/local/database/tables/roles_table.dart';
import 'package:flutter_management_system/data/datasources/local/database/tables/tiendas_table.dart';

@DataClassName('UsuarioTable')
class Usuarios extends Table {
  TextColumn get id => text()();
  TextColumn get email => text().unique()();
  TextColumn get nombreCompleto => text()();
  TextColumn get telefono => text().nullable()();
  TextColumn get tiendaId => text().nullable().references(Tiendas, #id)();
  TextColumn get rolId => text().references(Roles, #id)();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncId => text().nullable()(); // ID local antes de sync
  DateTimeColumn get lastSync => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
