

import 'package:equatable/equatable.dart';
import 'package:flutter_management_system/domain/entities/almacen.dart';

abstract class AlmacenState extends Equatable {
  const AlmacenState();

  @override
  List<Object?> get props => [];
}

/// Initial state - no almacenes loaded yet
/// Represents the initial state of the Almacen BLoC before any action has been taken
class AlmacenInitial extends AlmacenState {
  const AlmacenInitial();
}

class AlmacenLoading extends AlmacenState {
  const AlmacenLoading();
}

class AlmacenLoaded extends AlmacenState {
  final List<Almacen> almacenes;

  const AlmacenLoaded({required this.almacenes});

  @override
  List<Object?> get props => [almacenes];
}

class AlmacenError extends AlmacenState {
  final String message;

  const AlmacenError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AlmacenOperationSuccess extends AlmacenState {
  final String message;

  const AlmacenOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class AlmacenOperationFailure extends AlmacenState {
  final String message;

  const AlmacenOperationFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class AlmacenSyncInProgress extends AlmacenState {
  const AlmacenSyncInProgress();
}

class AlmacenSyncSuccess extends AlmacenState {
  final String message;

  const AlmacenSyncSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class AlmacenSyncFailure extends AlmacenState {
  final String message;

  const AlmacenSyncFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// class AlmacenConflictDetected extends AlmacenState {
//   final List<AlmacenConflict> conflicts;

//   const AlmacenConflictDetected({required this.conflicts});

//   @override
//   List<Object?> get props => [conflicts];
// }

class AlmacenConflictResolved extends AlmacenState {
  const AlmacenConflictResolved();
}

class AlmacenNoConnection extends AlmacenState {
  const AlmacenNoConnection();
}

class AlmacenEmpty extends AlmacenState {
  const AlmacenEmpty();
}

class AlmacenUpdating extends AlmacenState {
  const AlmacenUpdating();
}

class AlmacenDeleting extends AlmacenState {
  const AlmacenDeleting();
}

class AlmacenCreating extends AlmacenState {
  const AlmacenCreating();
}

class AlmacenCreated extends AlmacenState {
  final Almacen almacen;

  const AlmacenCreated({required this.almacen});

  @override
  List<Object?> get props => [almacen];
}

class AlmacenUpdated extends AlmacenState {
  final Almacen almacen;

  const AlmacenUpdated({required this.almacen});

  @override
  List<Object?> get props => [almacen];
}

class AlmacenDeleted extends AlmacenState {
  final String almacenId;

  const AlmacenDeleted({required this.almacenId});

  @override
  List<Object?> get props => [almacenId];
}

class AlmacenDetailLoaded extends AlmacenState {
  final Almacen almacen;

  const AlmacenDetailLoaded({required this.almacen});

  @override
  List<Object?> get props => [almacen];
}





