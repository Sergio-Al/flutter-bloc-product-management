import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/movimiento.dart';

/// Movimiento repository interface
/// Defines the contract for inventory movement operations
abstract class MovimientoRepository {
  /// Get all movements
  Future<Either<Failure, List<Movimiento>>> getMovimientos();

  /// Get movement by ID
  Future<Either<Failure, Movimiento>> getMovimientoById(String id);

  /// Get movement by number
  Future<Either<Failure, Movimiento>> getMovimientoByNumero(
    String numeroMovimiento,
  );

  /// Get movements by product
  Future<Either<Failure, List<Movimiento>>> getMovimientosByProducto(
    String productoId,
  );

  /// Get movements by store (origin or destination)
  Future<Either<Failure, List<Movimiento>>> getMovimientosByTienda(
    String tiendaId,
  );

  /// Get movements by user
  Future<Either<Failure, List<Movimiento>>> getMovimientosByUsuario(
    String usuarioId,
  );

  /// Get movements by type (COMPRA, VENTA, TRANSFERENCIA, etc.)
  Future<Either<Failure, List<Movimiento>>> getMovimientosByTipo(String tipo);

  /// Get movements by status (PENDIENTE, EN_TRANSITO, COMPLETADO, CANCELADO)
  Future<Either<Failure, List<Movimiento>>> getMovimientosByEstado(
    String estado,
  );

  /// Get movements by date range
  Future<Either<Failure, List<Movimiento>>> getMovimientosByFechaRango({
    required DateTime fechaInicio,
    required DateTime fechaFin,
  });

  /// Get pending movements
  Future<Either<Failure, List<Movimiento>>> getMovimientosPendientes();

  /// Get movements in transit
  Future<Either<Failure, List<Movimiento>>> getMovimientosEnTransito();

  /// Get unsynchronized movements
  Future<Either<Failure, List<Movimiento>>> getMovimientosNoSincronizados();

  /// Create a purchase movement (COMPRA)
  Future<Either<Failure, Movimiento>> createCompra({
    required String productoId,
    required String tiendaDestinoId,
    required String proveedorId,
    required int cantidad,
    required double costoUnitario,
    String? loteId,
    String? numeroFactura,
    String? observaciones,
  });

  /// Create a sale movement (VENTA)
  Future<Either<Failure, Movimiento>> createVenta({
    required String productoId,
    required String tiendaOrigenId,
    required int cantidad,
    required double costoUnitario,
    String? loteId,
    String? numeroFactura,
    String? observaciones,
  });

  /// Create a transfer movement (TRANSFERENCIA)
  Future<Either<Failure, Movimiento>> createTransferencia({
    required String productoId,
    required String tiendaOrigenId,
    required String tiendaDestinoId,
    required int cantidad,
    String? loteId,
    String? vehiculoPlaca,
    String? conductor,
    String? numeroGuiaRemision,
    String? observaciones,
  });

  /// Create an adjustment movement (AJUSTE)
  Future<Either<Failure, Movimiento>> createAjuste({
    required String productoId,
    required String tiendaId,
    required int cantidad,
    required String motivo,
    String? observaciones,
  });

  /// Create a return movement (DEVOLUCION)
  Future<Either<Failure, Movimiento>> createDevolucion({
    required String productoId,
    required String tiendaId,
    required int cantidad,
    required String motivo,
    String? numeroFactura,
    String? observaciones,
  });

  /// Create a loss/shrinkage movement (MERMA)
  Future<Either<Failure, Movimiento>> createMerma({
    required String productoId,
    required String tiendaId,
    required int cantidad,
    required String motivo,
    String? observaciones,
  });

  /// Update movement
  Future<Either<Failure, Movimiento>> updateMovimiento(Movimiento movimiento);

  /// Complete movement (change status to COMPLETADO)
  Future<Either<Failure, Movimiento>> completarMovimiento(String id);

  /// Cancel movement (change status to CANCELADO)
  Future<Either<Failure, Movimiento>> cancelarMovimiento({
    required String id,
    required String motivo,
  });

  /// Mark movement as synchronized
  Future<Either<Failure, Movimiento>> marcarComoSincronizado(String id);

  /// Delete movement
  /// ⚠️ WARNING: Movimientos should NOT be deleted as they are audit records.
  /// This method will return an error. Use cancelarMovimiento() instead.
  /// Only kept for interface compatibility.
  @Deprecated('Use cancelarMovimiento() instead. Movimientos are audit records and should not be deleted.')
  Future<Either<Failure, Unit>> deleteMovimiento(String id);
}
