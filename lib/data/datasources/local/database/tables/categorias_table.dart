import 'package:drift/drift.dart';

@DataClassName('CategoriaTable')
class Categorias extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get codigo => text().unique()();
  TextColumn get descripcion => text().nullable()();
  TextColumn get categoriaPadreId => text().nullable().references(Categorias, #id)();
  BoolColumn get requiereLote => boolean().withDefault(const Constant(false))();
  BoolColumn get requiereCertificacion => boolean().withDefault(const Constant(false))();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get syncId => text().nullable()();
  DateTimeColumn get lastSync => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
