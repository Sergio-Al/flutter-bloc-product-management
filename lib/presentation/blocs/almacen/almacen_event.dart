import 'package:equatable/equatable.dart';
import 'package:flutter_management_system/domain/entities/almacen.dart';

abstract class AlmacenEvent extends Equatable {
  const AlmacenEvent();

  @override
  List<Object?> get props => [];
}

// ==================== CRUD Operations ====================

/// Load all almacenes from repository
class LoadAlmacenes extends AlmacenEvent {
  const LoadAlmacenes();
}

/// Load only active almacenes
class LoadAlmacenesActivos extends AlmacenEvent {
  const LoadAlmacenesActivos();
}

/// Load almacenes by tienda
class LoadAlmacenesByTienda extends AlmacenEvent {
  final String tiendaId;

  const LoadAlmacenesByTienda({required this.tiendaId});

  @override
  List<Object?> get props => [tiendaId];
}

/// Load almacenes by tipo (Principal, Obra, Transito)
class LoadAlmacenesByTipo extends AlmacenEvent {
  final String tipo;

  const LoadAlmacenesByTipo({required this.tipo});

  @override
  List<Object?> get props => [tipo];
}

/// Load almacen by ID
class LoadAlmacenById extends AlmacenEvent {
  final String id;

  const LoadAlmacenById({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Load almacen by codigo
class LoadAlmacenByCodigo extends AlmacenEvent {
  final String codigo;

  const LoadAlmacenByCodigo({required this.codigo});

  @override
  List<Object?> get props => [codigo];
}

/// Load principal almacen for a tienda
class LoadAlmacenPrincipal extends AlmacenEvent {
  final String tiendaId;

  const LoadAlmacenPrincipal({required this.tiendaId});

  @override
  List<Object?> get props => [tiendaId];
}

/// Create new almacen
class CreateAlmacen extends AlmacenEvent {
  final Almacen almacen;

  const CreateAlmacen({required this.almacen});

  @override
  List<Object?> get props => [almacen];
}

/// Update existing almacen
class UpdateAlmacen extends AlmacenEvent {
  final Almacen almacen;

  const UpdateAlmacen({required this.almacen});

  @override
  List<Object?> get props => [almacen];
}

/// Delete almacen (soft delete)
class DeleteAlmacen extends AlmacenEvent {
  final String id;

  const DeleteAlmacen({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Toggle almacen active status
class ToggleAlmacenActivo extends AlmacenEvent {
  final String id;

  const ToggleAlmacenActivo({required this.id});

  @override
  List<Object?> get props => [id];
}

// ==================== Search Operations ====================

/// Search almacenes by query (name, code, location)
class SearchAlmacenes extends AlmacenEvent {
  final String query;

  const SearchAlmacenes({required this.query});

  @override
  List<Object?> get props => [query];
}

/// Clear search results
class ClearAlmacenSearch extends AlmacenEvent {
  const ClearAlmacenSearch();
}

// ==================== Sync Operations ====================

/// Refresh almacenes from server
class RefreshAlmacenes extends AlmacenEvent {
  const RefreshAlmacenes();
}

/// Sync pending changes to server
class SyncAlmacenes extends AlmacenEvent {
  const SyncAlmacenes();
}

/// Check network connectivity
class CheckAlmacenConnection extends AlmacenEvent {
  const CheckAlmacenConnection();
}

// ==================== Cache Management ====================

/// Clear local cache
class ClearAlmacenCache extends AlmacenEvent {
  const ClearAlmacenCache();
}

/// Reset almacen state
class ResetAlmacenState extends AlmacenEvent {
  const ResetAlmacenState();
}
