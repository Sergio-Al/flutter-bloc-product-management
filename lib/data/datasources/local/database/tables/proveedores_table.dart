import 'package:drift/drift.dart';

@DataClassName('ProveedorTable')
class Proveedores extends Table {
  TextColumn get id => text()();
  TextColumn get razonSocial => text()();
  TextColumn get nit => text().unique()();
  TextColumn get nombreContacto => text().nullable()();
  TextColumn get telefono => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get direccion => text().nullable()();
  TextColumn get ciudad => text().nullable()();
  TextColumn get tipoMaterial => text().nullable()();
  IntColumn get diasCredito => integer().withDefault(const Constant(0))();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncId => text().nullable()();
  DateTimeColumn get lastSync => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
