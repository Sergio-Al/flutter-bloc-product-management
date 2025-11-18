import 'package:equatable/equatable.dart';
import '../../../domain/entities/proveedor.dart';

abstract class ProveedorEvent extends Equatable {
  const ProveedorEvent();

  @override
  List<Object?> get props => [];
}

// ==================== Read Operations ====================

/// Load all proveedores
class LoadProveedores extends ProveedorEvent {
  const LoadProveedores();
}

/// Load only active proveedores
class LoadProveedoresActivos extends ProveedorEvent {
  const LoadProveedoresActivos();
}

/// Load proveedor by ID
class LoadProveedorById extends ProveedorEvent {
  final String id;
  const LoadProveedorById(this.id);
  
  @override
  List<Object?> get props => [id];
}

/// Search proveedores by query (nombre, razonSocial, nit)
class SearchProveedores extends ProveedorEvent {
  final String query;
  const SearchProveedores(this.query);
  
  @override
  List<Object?> get props => [query];
}

// ==================== Filter Operations ====================

/// Load proveedores by ciudad
class LoadProveedoresByCiudad extends ProveedorEvent {
  final String ciudad;
  const LoadProveedoresByCiudad(this.ciudad);
  
  @override
  List<Object?> get props => [ciudad];
}

/// Load proveedores by tipo de material
class LoadProveedoresByTipoMaterial extends ProveedorEvent {
  final String tipoMaterial;
  const LoadProveedoresByTipoMaterial(this.tipoMaterial);
  
  @override
  List<Object?> get props => [tipoMaterial];
}

/// Load proveedores con crédito (diasCredito > 0)
class LoadProveedoresConCredito extends ProveedorEvent {
  const LoadProveedoresConCredito();
}

// ==================== Write Operations ====================

/// Create a new proveedor
class CreateProveedor extends ProveedorEvent {
  final Proveedor proveedor;
  const CreateProveedor(this.proveedor);
  
  @override
  List<Object?> get props => [proveedor];
}

/// Update an existing proveedor
class UpdateProveedor extends ProveedorEvent {
  final Proveedor proveedor;
  const UpdateProveedor(this.proveedor);
  
  @override
  List<Object?> get props => [proveedor];
}

/// Delete a proveedor (soft delete)
class DeleteProveedor extends ProveedorEvent {
  final String id;
  const DeleteProveedor(this.id);
  
  @override
  List<Object?> get props => [id];
}

/// Toggle proveedor active status
class ToggleProveedorActivo extends ProveedorEvent {
  final String id;
  const ToggleProveedorActivo(this.id);
  
  @override
  List<Object?> get props => [id];
}
