

import 'package:equatable/equatable.dart';
import 'package:flutter_management_system/domain/entities/producto.dart';

abstract class ProductoEvent extends Equatable {
  const ProductoEvent();

  @override
  List<Object?> get props => [];
}

// ==================== CRUD Operations ====================

/// Load all products from repository (local first, then sync)
class LoadProductos extends ProductoEvent {
  const LoadProductos();
}

/// Load only active products
class LoadProductosActivos extends ProductoEvent {
  const LoadProductosActivos();
}

/// Load products that require special storage
class LoadProductosAlmacenamientoEspecial extends ProductoEvent {
  const LoadProductosAlmacenamientoEspecial();
}

/// Load dangerous materials
class LoadProductosPeligrosos extends ProductoEvent {
  const LoadProductosPeligrosos();
}

/// Load products with low stock
class LoadProductosStockBajo extends ProductoEvent {
  const LoadProductosStockBajo();
}

/// Load product by ID
class LoadProductoById extends ProductoEvent {
  final String id;

  const LoadProductoById({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Load product by codigo (barcode/SKU)
class LoadProductoByCodigo extends ProductoEvent {
  final String codigo;

  const LoadProductoByCodigo({required this.codigo});

  @override
  List<Object?> get props => [codigo];
}

/// Load products by category
class LoadProductosByCategoria extends ProductoEvent {
  final String categoriaId;

  const LoadProductosByCategoria({required this.categoriaId});

  @override
  List<Object?> get props => [categoriaId];
}

/// Load products by supplier
class LoadProductosByProveedor extends ProductoEvent {
  final String proveedorId;

  const LoadProductosByProveedor({required this.proveedorId});

  @override
  List<Object?> get props => [proveedorId];
}

/// Create new product
class CreateProducto extends ProductoEvent {
  final Producto producto;

  const CreateProducto({required this.producto});

  @override
  List<Object?> get props => [producto];
}

/// Update existing product
class UpdateProducto extends ProductoEvent {
  final Producto producto;

  const UpdateProducto({required this.producto});

  @override
  List<Object?> get props => [producto];
}

/// Delete product (soft delete)
class DeleteProducto extends ProductoEvent {
  final String id;

  const DeleteProducto({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Toggle product active status
class ToggleProductoActivo extends ProductoEvent {
  final String id;

  const ToggleProductoActivo({required this.id});

  @override
  List<Object?> get props => [id];
}

// ==================== Search & Filter Operations ====================

/// Search products by query (name, code, description)
class SearchProductos extends ProductoEvent {
  final String query;

  const SearchProductos({required this.query});

  @override
  List<Object?> get props => [query];
}

/// Clear search results
class ClearProductoSearch extends ProductoEvent {
  const ClearProductoSearch();
}

/// Filter products by criteria
class FilterProductos extends ProductoEvent {
  final bool? activo;
  final bool? materialPeligroso;
  final bool? requiereAlmacenCubierto;
  final String? categoriaId;
  final String? proveedorId;
  final double? precioMinimo;
  final double? precioMaximo;

  const FilterProductos({
    this.activo,
    this.materialPeligroso,
    this.requiereAlmacenCubierto,
    this.categoriaId,
    this.proveedorId,
    this.precioMinimo,
    this.precioMaximo,
  });

  @override
  List<Object?> get props => [
        activo,
        materialPeligroso,
        requiereAlmacenCubierto,
        categoriaId,
        proveedorId,
        precioMinimo,
        precioMaximo,
      ];
}

/// Clear all filters
class ClearProductoFilters extends ProductoEvent {
  const ClearProductoFilters();
}

/// Sort products
class SortProductos extends ProductoEvent {
  final ProductoSortField sortField;
  final bool ascending;

  const SortProductos({
    required this.sortField,
    this.ascending = true,
  });

  @override
  List<Object?> get props => [sortField, ascending];
}

enum ProductoSortField {
  nombre,
  codigo,
  precioCompra,
  precioVenta,
  stockMinimo,
  stockMaximo,
  createdAt,
  updatedAt,
}

// ==================== Offline-First & Sync Operations ====================

/// Refresh products from server
class RefreshProductos extends ProductoEvent {
  const RefreshProductos();
}

/// Sync pending changes to server
class SyncProductos extends ProductoEvent {
  const SyncProductos();
}

/// Sync specific product
class SyncProducto extends ProductoEvent {
  final String id;

  const SyncProducto({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Check network connectivity
class CheckProductoConnection extends ProductoEvent {
  const CheckProductoConnection();
}

/// Queue operation for offline sync
class QueueProductoOperation extends ProductoEvent {
  final ProductoOperation operation;
  final Producto producto;

  const QueueProductoOperation({
    required this.operation,
    required this.producto,
  });

  @override
  List<Object?> get props => [operation, producto];
}

enum ProductoOperation {
  create,
  update,
  delete,
}

/// Cancel sync operation
class CancelProductoSync extends ProductoEvent {
  const CancelProductoSync();
}

/// Pause sync
class PauseProductoSync extends ProductoEvent {
  const PauseProductoSync();
}

/// Resume sync
class ResumeProductoSync extends ProductoEvent {
  const ResumeProductoSync();
}

/// Retry failed sync
class RetryProductoSync extends ProductoEvent {
  const RetryProductoSync();
}

// ==================== Conflict Resolution ====================

/// Resolve conflict by choosing local version
class ResolveProductoConflictLocal extends ProductoEvent {
  final String productoId;

  const ResolveProductoConflictLocal({required this.productoId});

  @override
  List<Object?> get props => [productoId];
}

/// Resolve conflict by choosing remote version
class ResolveProductoConflictRemote extends ProductoEvent {
  final String productoId;

  const ResolveProductoConflictRemote({required this.productoId});

  @override
  List<Object?> get props => [productoId];
}

/// Resolve conflict with custom merge
class ResolveProductoConflictMerge extends ProductoEvent {
  final Producto mergedProducto;

  const ResolveProductoConflictMerge({required this.mergedProducto});

  @override
  List<Object?> get props => [mergedProducto];
}

// ==================== Cache Management ====================

/// Clear local cache
class ClearProductoCache extends ProductoEvent {
  const ClearProductoCache();
}

/// Reset product state
class ResetProductoState extends ProductoEvent {
  const ResetProductoState();
}
