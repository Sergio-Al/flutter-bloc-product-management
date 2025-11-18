import 'package:equatable/equatable.dart';
import 'package:flutter_management_system/domain/entities/tienda.dart';

abstract class TiendaEvent extends Equatable {
  const TiendaEvent();

  @override
  List<Object?> get props => [];
}

// ==================== CRUD Operations ====================

/// Load all tiendas from repository
class LoadTiendas extends TiendaEvent {
  const LoadTiendas();
}

// Load only active tiendas
class LoadTiendasActivas extends TiendaEvent {
  const LoadTiendasActivas();
}

// Load tienda by ID
class LoadTiendaById extends TiendaEvent {
  final String id;
  const LoadTiendaById({required this.id});
  @override
  List<Object?> get props => [id];
}

// Load tienda by codigo
class LoadTiendaByCodigo extends TiendaEvent {
  final String codigo;
  const LoadTiendaByCodigo({required this.codigo});
  @override
  List<Object?> get props => [codigo];
}

// Load Tiendas by Ciudad
class LoadTiendasByCiudad extends TiendaEvent {
  final String ciudad;
  const LoadTiendasByCiudad({required this.ciudad});
  @override
  List<Object?> get props => [ciudad];
}

// Load Tiendas by Departamento
class LoadTiendasByDepartamento extends TiendaEvent {
  final String departamento;
  const LoadTiendasByDepartamento({required this.departamento});
  @override
  List<Object?> get props => [departamento];
}

/// Create a new tienda
class CreateTienda extends TiendaEvent {
  final Tienda tiendaData;
  const CreateTienda({required this.tiendaData});
  @override
  List<Object?> get props => [tiendaData];
}

/// Update an existing tienda
class UpdateTienda extends TiendaEvent {
  final String id;
  final Tienda tiendaData;
  const UpdateTienda({required this.id, required this.tiendaData});
  @override
  List<Object?> get props => [id, tiendaData];
}

/// Delete a tienda
class DeleteTienda extends TiendaEvent {
  final String id;
  const DeleteTienda({required this.id});
  @override
  List<Object?> get props => [id];
}

// Toggle tienda active status
class ToggleTiendaActivo extends TiendaEvent {
  final String id;
  const ToggleTiendaActivo({required this.id});
  @override
  List<Object?> get props => [id];
}

// ==================== Search Operations ====================

/// Search tiendas by query
class SearchTiendas extends TiendaEvent {
  final String query;
  const SearchTiendas({required this.query});

  @override
  List<Object?> get props => [query];
}

/// Clear search results
class ClearTiendaSearch extends TiendaEvent {
  const ClearTiendaSearch();
}

// ==================== Sync Operations ====================

/// Refresh tiendas from remote source
class RefreshTiendas extends TiendaEvent {
  const RefreshTiendas();
}

/// Sync pending tienda changes to remote source
class SyncTiendas extends TiendaEvent {
  const SyncTiendas();
}

/// Check network connectivity for tiendas
class CheckTiendaNetworkConnectivity extends TiendaEvent {
  const CheckTiendaNetworkConnectivity();
}

// ==================== Cache Management ====================
/// Clear tienda cache
class ClearTiendaCache extends TiendaEvent {
  const ClearTiendaCache();
}

/// Reset tienda state
/// Useful for clearing errors or resetting to initial state
/// after certain operations
/// .g., after a failed create/update/delete attempt
class ResetTiendaState extends TiendaEvent {
  const ResetTiendaState();
}

