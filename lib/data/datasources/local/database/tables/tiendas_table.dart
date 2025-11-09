import 'package:drift/drift.dart';

@DataClassName('TiendaTable')
class Tiendas extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get codigo => text().unique()();
  TextColumn get direccion => text()();
  TextColumn get ciudad => text()();
  TextColumn get departamento => text()();
  TextColumn get telefono => text().nullable()();
  TextColumn get horarioAtencion => text().nullable()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncId => text().nullable()();
  DateTimeColumn get lastSync => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
