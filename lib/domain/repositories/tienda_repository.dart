import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/tienda.dart';

/// Tienda repository interface
/// Defines the contract for store/branch management operations
abstract class TiendaRepository {
  /// Get all stores
  Future<Either<Failure, List<Tienda>>> getTiendas();

  /// Get store by ID
  Future<Either<Failure, Tienda>> getTiendaById(String id);

  /// Get store by code
  Future<Either<Failure, Tienda>> getTiendaByCodigo(String codigo);

  /// Get active stores only
  Future<Either<Failure, List<Tienda>>> getTiendasActivas();

  /// Get stores by city
  Future<Either<Failure, List<Tienda>>> getTiendasByCiudad(String ciudad);

  /// Get stores by department
  Future<Either<Failure, List<Tienda>>> getTiendasByDepartamento(
    String departamento,
  );

  /// Search stores by name or code
  Future<Either<Failure, List<Tienda>>> searchTiendas(String query);

  /// Create a new store
  Future<Either<Failure, Tienda>> createTienda(Tienda tienda);

  /// Update existing store
  Future<Either<Failure, Tienda>> updateTienda(Tienda tienda);

  /// Delete store (soft delete)
  Future<Either<Failure, Unit>> deleteTienda(String id);

  /// Activate/deactivate store
  Future<Either<Failure, Tienda>> toggleTiendaActiva(String id);
}
