import 'package:drift/drift.dart';
import 'package:flutter_management_system/data/datasources/local/database/tables/inventarios_table.dart';
import 'package:flutter_management_system/data/datasources/local/database/tables/lotes_table.dart';
import 'package:flutter_management_system/data/datasources/local/database/tables/productos_table.dart';
import 'package:flutter_management_system/data/datasources/local/database/tables/proveedores_table.dart';
import 'package:flutter_management_system/data/datasources/local/database/tables/tiendas_table.dart';
import 'package:flutter_management_system/data/datasources/local/database/tables/usuarios_table.dart';

@DataClassName('MovimientoTable')
class Movimientos extends Table {
  TextColumn get id => text()();
  TextColumn get numeroMovimiento => text().unique()();
  TextColumn get productoId => text().references(Productos, #id)();
  TextColumn get inventarioId => text().references(Inventarios, #id)();
  TextColumn get loteId => text().nullable().references(Lotes, #id)();
  TextColumn get tiendaOrigenId => text().nullable().references(Tiendas, #id)();
  TextColumn get tiendaDestinoId => text().nullable().references(Tiendas, #id)();
  TextColumn get proveedorId => text().nullable().references(Proveedores, #id)();
  TextColumn get tipo => text()(); // COMPRA, VENTA, TRANSFERENCIA, AJUSTE, DEVOLUCION, MERMA
  TextColumn get motivo => text().nullable()();
  IntColumn get cantidad => integer()();
  RealColumn get costoUnitario => real().withDefault(const Constant(0.0))();
  RealColumn get costoTotal => real().withDefault(const Constant(0.0))();
  RealColumn get pesoTotalKg => real().nullable()();
  TextColumn get usuarioId => text().references(Usuarios, #id)();
  TextColumn get estado => text()(); // PENDIENTE, EN_TRANSITO, COMPLETADO, CANCELADO
  DateTimeColumn get fechaMovimiento => dateTime().withDefault(currentDateAndTime)();
  TextColumn get numeroFactura => text().nullable()();
  TextColumn get numeroGuiaRemision => text().nullable()();
  TextColumn get vehiculoPlaca => text().nullable()();
  TextColumn get conductor => text().nullable()();
  TextColumn get observaciones => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get syncId => text().nullable()();
  DateTimeColumn get lastSync => dateTime().nullable()();
  BoolColumn get sincronizado => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
