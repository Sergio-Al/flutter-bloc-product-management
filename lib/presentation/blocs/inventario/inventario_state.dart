import 'package:equatable/equatable.dart';
import '../../../domain/entities/inventario.dart';

abstract class InventarioState extends Equatable {
  const InventarioState();

  @override
  List<Object?> get props => [];
}

class InventarioInitial extends InventarioState {
  const InventarioInitial();
}

class InventarioLoading extends InventarioState {
  const InventarioLoading();
}

class InventariosLoaded extends InventarioState {
  final List<Inventario> inventarios;
  const InventariosLoaded(this.inventarios);

  @override
  List<Object?> get props => [inventarios];
}

class InventarioLoaded extends InventarioState {
  final Inventario inventario;
  const InventarioLoaded(this.inventario);

  @override
  List<Object?> get props => [inventario];
}

class InventarioOperationSuccess extends InventarioState {
  final String? message;
  const InventarioOperationSuccess([this.message]);

  @override
  List<Object?> get props => [message];
}

class InventarioError extends InventarioState {
  final String message;
  const InventarioError(this.message);

  @override
  List<Object?> get props => [message];
}
