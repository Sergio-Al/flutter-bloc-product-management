

import 'package:equatable/equatable.dart';
import 'package:flutter_management_system/domain/entities/producto.dart';

abstract class ProductoState extends Equatable {
  const ProductoState();

  @override
  List<Object?> get props => [];
}

/// Initial state - no products loaded yet
class ProductoInitial extends ProductoState {
  const ProductoInitial();
}

class ProductoLoading extends ProductoState {
  const ProductoLoading();
}

class ProductoLoaded extends ProductoState {
  final List<Producto> productos;

  const ProductoLoaded({required this.productos});

  @override
  List<Object?> get props => [productos];
}

class ProductoError extends ProductoState {
  final String message;

  const ProductoError({required this.message});

  @override
  List<Object?> get props => [message];
}


class ProductoOperationSuccess extends ProductoState {
  final String message;

  const ProductoOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}


class ProductoOperationFailure extends ProductoState {
  final String message;

  const ProductoOperationFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProductoSyncInProgress extends ProductoState {
  const ProductoSyncInProgress();
}

class ProductoSyncSuccess extends ProductoState {
  const ProductoSyncSuccess();
}

class ProductoSyncFailure extends ProductoState {
  final String message;

  const ProductoSyncFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// class ProductoConflictDetected extends ProductoState {
//   final List<ProductoConflict> conflicts;

//   const ProductoConflictDetected({required this.conflicts});

//   @override
//   List<Object?> get props => [conflicts];
// }

class ProductoConflictResolved extends ProductoState {
  const ProductoConflictResolved();
}

class ProductoNoConnection extends ProductoState {
  const ProductoNoConnection();
}

class ProductoEmpty extends ProductoState {
  const ProductoEmpty();
}

class ProductoUpdating extends ProductoState {
  const ProductoUpdating();
}

class ProductoDeleting extends ProductoState {
  const ProductoDeleting();
}

class ProductoCreating extends ProductoState {
  const ProductoCreating();
}

class ProductoCreated extends ProductoState {
  final Producto producto;

  const ProductoCreated({required this.producto});

  @override
  List<Object?> get props => [producto];
}

class ProductoUpdated extends ProductoState {
  final Producto producto;

  const ProductoUpdated({required this.producto});

  @override
  List<Object?> get props => [producto];
}

class ProductoDetailLoaded extends ProductoState {
  final Producto producto;

  const ProductoDetailLoaded({required this.producto});

  @override
  List<Object?> get props => [producto];
}

class ProductoSearchResults extends ProductoState {
  final List<Producto> resultados;

  const ProductoSearchResults({required this.resultados});

  @override
  List<Object?> get props => [resultados];
}

class ProductoFilterApplied extends ProductoState {
  final List<Producto> productos;

  const ProductoFilterApplied({required this.productos});

  @override
  List<Object?> get props => [productos];
}

class ProductoSortApplied extends ProductoState {
  final List<Producto> productos;

  const ProductoSortApplied({required this.productos});

  @override
  List<Object?> get props => [productos];
}

class ProductoRefreshing extends ProductoState {
  const ProductoRefreshing();
}

class ProductoRefreshed extends ProductoState {
  final List<Producto> productos;

  const ProductoRefreshed({required this.productos});

  @override
  List<Object?> get props => [productos];
}

class ProductoRefreshFailure extends ProductoState {
  final String message;

  const ProductoRefreshFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProductoOffline extends ProductoState {
  const ProductoOffline();
}

class ProductoOnline extends ProductoState {
  const ProductoOnline();
}

class ProductoSyncQueued extends ProductoState {
  const ProductoSyncQueued();
}

class ProductoSyncCancelled extends ProductoState {
  const ProductoSyncCancelled();
}

class ProductoSyncPaused extends ProductoState {
  const ProductoSyncPaused();
}


class ProductoSyncResumed extends ProductoState {
  const ProductoSyncResumed();
}

class ProductoSyncStatusUpdated extends ProductoState {
  final String status;

  const ProductoSyncStatusUpdated({required this.status});

  @override
  List<Object?> get props => [status];
}

