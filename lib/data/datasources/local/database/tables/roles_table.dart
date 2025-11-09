import 'package:drift/drift.dart';

@DataClassName('RolTable')
class Roles extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text().unique()();
  TextColumn get descripcion => text().nullable()();
  TextColumn get permisos => text()(); // JSON string
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
