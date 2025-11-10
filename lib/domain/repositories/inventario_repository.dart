import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/inventario.dart';

/// Inventario repository interface
/// Defines the contract for inventory management operations
abstract class InventarioRepository {
  /// Get all inventory records
  Future<Either<Failure, List<Inventario>>> getInventarios();

  /// Get inventory by ID
  Future<Either<Failure, Inventario>> getInventarioById(String id);

  /// Get inventory by product
  Future<Either<Failure, List<Inventario>>> getInventariosByProducto(
    String productoId,
  );

  /// Get inventory by warehouse
  Future<Either<Failure, List<Inventario>>> getInventariosByAlmacen(
    String almacenId,
  );

  /// Get inventory by store
  Future<Either<Failure, List<Inventario>>> getInventariosByTienda(
    String tiendaId,
  );

  /// Get inventory by lot/batch
  Future<Either<Failure, List<Inventario>>> getInventariosByLote(
    String loteId,
  );

  /// Get inventory with low stock
  Future<Either<Failure, List<Inventario>>> getInventariosStockBajo();

  /// Get inventory with available stock
  Future<Either<Failure, List<Inventario>>> getInventariosDisponibles();

  /// Create inventory record
  Future<Either<Failure, Inventario>> createInventario(Inventario inventario);

  /// Update inventory record
  Future<Either<Failure, Inventario>> updateInventario(Inventario inventario);

  /// Update stock quantity
  Future<Either<Failure, Inventario>> updateStock({
    required String inventarioId,
    required int cantidad,
  });

  /// Reserve stock for orders
  Future<Either<Failure, Inventario>> reservarStock({
    required String inventarioId,
    required int cantidad,
  });

  /// Release reserved stock
  Future<Either<Failure, Inventario>> liberarStock({
    required String inventarioId,
    required int cantidad,
  });

  /// Adjust inventory (manual correction)
  Future<Either<Failure, Inventario>> ajustarInventario({
    required String inventarioId,
    required int cantidadNueva,
    required String motivo,
  });

  /// Get total inventory value by store
  Future<Either<Failure, double>> getValorTotalInventario(String tiendaId);

  /// Delete inventory record
  Future<Either<Failure, Unit>> deleteInventario(String id);
}
