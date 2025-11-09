import 'package:drift/drift.dart';

@DataClassName('UnidadMedidaTable')
class UnidadesMedida extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text().unique()();
  TextColumn get abreviatura => text()();
  TextColumn get tipo => text()(); // Peso, Volumen, Longitud, Unidad, Area
  RealColumn get factorConversion => real().withDefault(const Constant(1.0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
