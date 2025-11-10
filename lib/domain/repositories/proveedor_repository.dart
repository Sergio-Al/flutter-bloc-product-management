import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/proveedor.dart';

/// Proveedor repository interface
/// Defines the contract for supplier management operations
abstract class ProveedorRepository {
  /// Get all suppliers
  Future<Either<Failure, List<Proveedor>>> getProveedores();

  /// Get supplier by ID
  Future<Either<Failure, Proveedor>> getProveedorById(String id);

  /// Get supplier by NIT (tax ID)
  Future<Either<Failure, Proveedor>> getProveedorByNit(String nit);

  /// Get active suppliers only
  Future<Either<Failure, List<Proveedor>>> getProveedoresActivos();

  /// Get suppliers by material type
  Future<Either<Failure, List<Proveedor>>> getProveedoresByTipoMaterial(
    String tipoMaterial,
  );

  /// Get suppliers by city
  Future<Either<Failure, List<Proveedor>>> getProveedoresByCiudad(
    String ciudad,
  );

  /// Get suppliers that offer credit
  Future<Either<Failure, List<Proveedor>>> getProveedoresConCredito();

  /// Search suppliers by name or NIT
  Future<Either<Failure, List<Proveedor>>> searchProveedores(String query);

  /// Create a new supplier
  Future<Either<Failure, Proveedor>> createProveedor(Proveedor proveedor);

  /// Update existing supplier
  Future<Either<Failure, Proveedor>> updateProveedor(Proveedor proveedor);

  /// Delete supplier (soft delete)
  Future<Either<Failure, Unit>> deleteProveedor(String id);

  /// Activate/deactivate supplier
  Future<Either<Failure, Proveedor>> toggleProveedorActivo(String id);
}
