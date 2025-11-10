import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/almacen.dart';

/// Almacen repository interface
/// Defines the contract for warehouse management operations
abstract class AlmacenRepository {
  /// Get all warehouses
  Future<Either<Failure, List<Almacen>>> getAlmacenes();

  /// Get warehouse by ID
  Future<Either<Failure, Almacen>> getAlmacenById(String id);

  /// Get warehouse by code
  Future<Either<Failure, Almacen>> getAlmacenByCodigo(String codigo);

  /// Get warehouses by store
  Future<Either<Failure, List<Almacen>>> getAlmacenesByTienda(String tiendaId);

  /// Get warehouses by type (Principal, Obra, Transito)
  Future<Either<Failure, List<Almacen>>> getAlmacenesByTipo(String tipo);

  /// Get active warehouses only
  Future<Either<Failure, List<Almacen>>> getAlmacenesActivos();

  /// Get main warehouse for a store
  Future<Either<Failure, Almacen>> getAlmacenPrincipal(String tiendaId);

  /// Search warehouses by name or code
  Future<Either<Failure, List<Almacen>>> searchAlmacenes(String query);

  /// Create a new warehouse
  Future<Either<Failure, Almacen>> createAlmacen(Almacen almacen);

  /// Update existing warehouse
  Future<Either<Failure, Almacen>> updateAlmacen(Almacen almacen);

  /// Delete warehouse (soft delete)
  Future<Either<Failure, Unit>> deleteAlmacen(String id);

  /// Activate/deactivate warehouse
  Future<Either<Failure, Almacen>> toggleAlmacenActivo(String id);
}
