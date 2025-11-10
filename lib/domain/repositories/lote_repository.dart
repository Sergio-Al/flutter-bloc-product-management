import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/lote.dart';

/// Lote repository interface
/// Defines the contract for batch/lot management operations
abstract class LoteRepository {
  /// Get all lots
  Future<Either<Failure, List<Lote>>> getLotes();

  /// Get lot by ID
  Future<Either<Failure, Lote>> getLoteById(String id);

  /// Get lot by lot number
  Future<Either<Failure, Lote>> getLoteByNumero(String numeroLote);

  /// Get lots by product
  Future<Either<Failure, List<Lote>>> getLotesByProducto(String productoId);

  /// Get lots by supplier
  Future<Either<Failure, List<Lote>>> getLotesByProveedor(String proveedorId);

  /// Get lots by invoice number
  Future<Either<Failure, List<Lote>>> getLotesByFactura(String numeroFactura);

  /// Get expired lots
  Future<Either<Failure, List<Lote>>> getLotesVencidos();

  /// Get lots near expiration (within 30 days)
  Future<Either<Failure, List<Lote>>> getLotesPorVencer();

  /// Get lots with available stock
  Future<Either<Failure, List<Lote>>> getLotesConStock();

  /// Get empty lots
  Future<Either<Failure, List<Lote>>> getLotesVacios();

  /// Get lots with quality certificate
  Future<Either<Failure, List<Lote>>> getLotesConCertificado();

  /// Search lots by lot number or invoice
  Future<Either<Failure, List<Lote>>> searchLotes(String query);

  /// Create a new lot
  Future<Either<Failure, Lote>> createLote(Lote lote);

  /// Update existing lot
  Future<Either<Failure, Lote>> updateLote(Lote lote);

  /// Update lot quantity
  Future<Either<Failure, Lote>> updateCantidadLote({
    required String loteId,
    required int cantidadNueva,
  });

  /// Delete lot
  Future<Either<Failure, Unit>> deleteLote(String id);
}
