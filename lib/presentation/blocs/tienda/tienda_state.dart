import 'package:equatable/equatable.dart';
import 'package:flutter_management_system/domain/entities/tienda.dart';

abstract class TiendaState extends Equatable {
  const TiendaState();

  @override
  List<Object> get props => [];
}

// Initial state - no tiendas loaded yet
class TiendaInitial extends TiendaState {
  const TiendaInitial();
}

class TiendaLoading extends TiendaState {
  const TiendaLoading();
}

class TiendaLoaded extends TiendaState {
  final List<dynamic> tiendas; // Replace dynamic with your Tienda entity

  const TiendaLoaded({required this.tiendas});

  @override
  List<Object> get props => [tiendas];
}

class TiendaError extends TiendaState {
  final String message;

  const TiendaError({required this.message});

  @override
  List<Object> get props => [message];
}

class TiendaOperationSuccess extends TiendaState {
  final String message;

  const TiendaOperationSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class TiendaOperationFailure extends TiendaState {
  final String message;

  const TiendaOperationFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class TiendaSyncInProgress extends TiendaState {
  const TiendaSyncInProgress();
}

class TiendaSyncSuccess extends TiendaState {
  const TiendaSyncSuccess();
}

class TiendaSyncFailure extends TiendaState {
  final String message;

  const TiendaSyncFailure({required this.message});

  @override
  List<Object> get props => [message];
}

// class TiendaConflictDetected extends TiendaState {
//   final List<TiendaConflict> conflicts;

//   const TiendaConflictDetected({required this.conflicts});

//   @override
//   List<Object> get props => [conflicts];
// }

class TiendaConflictResolved extends TiendaState {
  const TiendaConflictResolved();
}

class TiendaNoConnection extends TiendaState {
  const TiendaNoConnection();
}

class TiendaEmpty extends TiendaState {
  const TiendaEmpty();
}

class TiendaUpdating extends TiendaState {
  const TiendaUpdating();
}

class TiendaDeleting extends TiendaState {
  const TiendaDeleting();
}

class TiendaCreating extends TiendaState {
  const TiendaCreating();
}

class TiendaCreated extends TiendaState {
  final Tienda tienda;

  const TiendaCreated({required this.tienda});

  @override
  List<Object> get props => [tienda];
}

class TiendaUpdated extends TiendaState {
  final Tienda tienda;

  const TiendaUpdated({required this.tienda});

  @override
  List<Object> get props => [tienda];
}

class TiendaDeleted extends TiendaState {
  final String tiendaId;

  const TiendaDeleted({required this.tiendaId});

  @override
  List<Object> get props => [tiendaId];
} 

class TiendaDetailLoaded extends TiendaState {
  final Tienda tienda;

  const TiendaDetailLoaded({required this.tienda});

  @override
  List<Object> get props => [tienda];
}
