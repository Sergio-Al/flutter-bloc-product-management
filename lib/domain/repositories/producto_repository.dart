import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/producto.dart';

/// Producto repository interface
/// Defines the contract for product management operations
abstract class ProductoRepository {
  /// Get all products
  Future<Either<Failure, List<Producto>>> getProductos();

  /// Get product by ID
  Future<Either<Failure, Producto>> getProductoById(String id);

  /// Get product by code (SKU)
  Future<Either<Failure, Producto>> getProductoByCodigo(String codigo);

  /// Get products by category
  Future<Either<Failure, List<Producto>>> getProductosByCategoria(
    String categoriaId,
  );

  /// Get products by supplier
  Future<Either<Failure, List<Producto>>> getProductosByProveedor(
    String proveedorId,
  );

  /// Get active products only
  Future<Either<Failure, List<Producto>>> getProductosActivos();

  /// Get products with low stock
  Future<Either<Failure, List<Producto>>> getProductosStockBajo();

  /// Search products by name, code, or description
  Future<Either<Failure, List<Producto>>> searchProductos(String query);

  /// Create a new product
  Future<Either<Failure, Producto>> createProducto(Producto producto);

  /// Update existing product
  Future<Either<Failure, Producto>> updateProducto(Producto producto);

  /// Delete product (soft delete)
  Future<Either<Failure, Unit>> deleteProducto(String id);

  /// Activate/deactivate product
  Future<Either<Failure, Producto>> toggleProductoActivo(String id);

  /// Get products requiring special storage
  Future<Either<Failure, List<Producto>>> getProductosAlmacenamientoEspecial();

  /// Get hazardous materials
  Future<Either<Failure, List<Producto>>> getProductosPeligrosos();
}
