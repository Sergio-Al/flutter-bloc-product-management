import 'package:equatable/equatable.dart';
import '../../../domain/entities/movimiento.dart';

abstract class MovimientoState extends Equatable {
  const MovimientoState();

  @override
  List<Object?> get props => [];
}

class MovimientoInitial extends MovimientoState {
  const MovimientoInitial();
}

class MovimientoLoading extends MovimientoState {
  const MovimientoLoading();
}

class MovimientosLoaded extends MovimientoState {
  final List<Movimiento> movimientos;
  const MovimientosLoaded(this.movimientos);

  @override
  List<Object?> get props => [movimientos];
}

class MovimientoLoaded extends MovimientoState {
  final Movimiento movimiento;
  const MovimientoLoaded(this.movimiento);

  @override
  List<Object?> get props => [movimiento];
}

class MovimientoCreated extends MovimientoState {
  final Movimiento movimiento;
  final String? message;
  const MovimientoCreated(this.movimiento, [this.message]);

  @override
  List<Object?> get props => [movimiento, message];
}

class MovimientoOperationSuccess extends MovimientoState {
  final String? message;
  const MovimientoOperationSuccess([this.message]);

  @override
  List<Object?> get props => [message];
}

class MovimientoError extends MovimientoState {
  final String message;
  const MovimientoError(this.message);

  @override
  List<Object?> get props => [message];
}
