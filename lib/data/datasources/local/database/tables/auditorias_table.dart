import 'package:drift/drift.dart';
import 'package:flutter_management_system/data/datasources/local/database/tables/usuarios_table.dart';

@DataClassName('AuditoriaTable')
class Auditorias extends Table {
  TextColumn get id => text()();
  TextColumn get usuarioId => text().references(Usuarios, #id)();
  TextColumn get tablaAfectada => text()();
  TextColumn get accion => text()(); // INSERT, UPDATE, DELETE
  TextColumn get datosAnteriores => text().nullable()(); // JSON
  TextColumn get datosNuevos => text().nullable()(); // JSON
  TextColumn get ipAddress => text().nullable()();
  TextColumn get dispositivo => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
