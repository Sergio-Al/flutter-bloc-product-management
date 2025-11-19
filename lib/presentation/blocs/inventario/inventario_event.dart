import 'package:equatable/equatable.dart';
import '../../../domain/entities/inventario.dart';

abstract class InventarioEvent extends Equatable {
  const InventarioEvent();

  @override
  List<Object?> get props => [];
}

// Read operations
class LoadInventarios extends InventarioEvent {
  const LoadInventarios();
}

class LoadInventarioById extends InventarioEvent {
  final String id;
  const LoadInventarioById(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadInventariosByProducto extends InventarioEvent {
  final String productoId;
  const LoadInventariosByProducto(this.productoId);

  @override
  List<Object?> get props => [productoId];
}

class LoadInventariosByAlmacen extends InventarioEvent {
  final String almacenId;
  const LoadInventariosByAlmacen(this.almacenId);

  @override
  List<Object?> get props => [almacenId];
}

class LoadInventariosByLote extends InventarioEvent {
  final String loteId;
  const LoadInventariosByLote(this.loteId);

  @override
  List<Object?> get props => [loteId];
}

class LoadInventariosByTienda extends InventarioEvent {
  final String tiendaId;
  const LoadInventariosByTienda(this.tiendaId);

  @override
  List<Object?> get props => [tiendaId];
}

class LoadInventariosDisponibles extends InventarioEvent {
  const LoadInventariosDisponibles();
}

class LoadInventariosStockBajo extends InventarioEvent {
  const LoadInventariosStockBajo();
}

// Write operations
class CreateInventario extends InventarioEvent {
  final Inventario inventario;
  const CreateInventario(this.inventario);

  @override
  List<Object?> get props => [inventario];
}

class UpdateInventario extends InventarioEvent {
  final Inventario inventario;
  const UpdateInventario(this.inventario);

  @override
  List<Object?> get props => [inventario];
}

class UpdateStockInventario extends InventarioEvent {
  final String inventarioId;
  final int cantidad;
  const UpdateStockInventario({required this.inventarioId, required this.cantidad});

  @override
  List<Object?> get props => [inventarioId, cantidad];
}

class ReservarStockInventario extends InventarioEvent {
  final String inventarioId;
  final int cantidad;
  const ReservarStockInventario({required this.inventarioId, required this.cantidad});

  @override
  List<Object?> get props => [inventarioId, cantidad];
}

class LiberarStockInventario extends InventarioEvent {
  final String inventarioId;
  final int cantidad;
  const LiberarStockInventario({required this.inventarioId, required this.cantidad});

  @override
  List<Object?> get props => [inventarioId, cantidad];
}

class AjustarInventarioEvent extends InventarioEvent {
  final String inventarioId;
  final int nuevaCantidad;
  final String motivo;
  const AjustarInventarioEvent({required this.inventarioId, required this.nuevaCantidad, required this.motivo});

  @override
  List<Object?> get props => [inventarioId, nuevaCantidad, motivo];
}

class DeleteInventario extends InventarioEvent {
  final String id;
  const DeleteInventario(this.id);

  @override
  List<Object?> get props => [id];
}
