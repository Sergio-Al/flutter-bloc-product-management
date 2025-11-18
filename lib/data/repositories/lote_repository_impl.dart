import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/core/network/network_info.dart';
import 'package:flutter_management_system/core/sync/sync_item.dart';
import 'package:flutter_management_system/data/datasources/remote/lote_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/local/database/daos/lote_dao.dart';
import 'package:flutter_management_system/data/mappers/lote_mapper.dart';
import 'package:flutter_management_system/data/models/lote_model.dart';
import 'package:flutter_management_system/domain/entities/lote.dart';
import 'package:flutter_management_system/domain/repositories/lote_repository.dart';
import 'package:flutter_management_system/core/sync/sync_manager.dart';

class LoteRepositoryImpl extends LoteRepository {
  final LoteRemoteDataSource remoteDataSource;
  final LoteDao loteDao;
  final NetworkInfo networkInfo;
  final SyncManager syncManager;

  LoteRepositoryImpl({
    required this.remoteDataSource,
    required this.loteDao,
    required this.networkInfo,
    required this.syncManager,
  });

  @override
  Future<Either<Failure, Lote>> createLote(Lote lote) async {
    try {
      // First save locally
      // Convert entity to Drift LoteTable object using mapper
      final loteTable = lote.toTable();

      // Save to local database
      await loteDao.insertLote(loteTable);

      // Add to sync queue for remote sync
      await syncManager.queueChange(
        entityId: lote.id,
        entityType: SyncEntityType.lote,
        operation: SyncOperation.create,
        data: lote.toJson(),
      );

      return Right(lote);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to create lote: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteLote(String id) async {
    try {
      // First mark as deleted locally
      final deleted = await loteDao.deleteLote(id); // it deletes in a hard way
      if (!deleted) {
        return Left(CacheFailure(message: 'Lote not found locally'));
      }

      // Add to sync queue for remote sync
      await syncManager.queueChange(
        entityId: id,
        entityType: SyncEntityType.lote,
        operation: SyncOperation.delete,
        data: {'id': id},
      );

      return Right(unit);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to delete lote: $e'));
    }
  }

  @override
  Future<Either<Failure, Lote>> getLoteById(String id) async {
    try {
      final loteTable = await loteDao.getLoteById(id);
      if (loteTable == null) {
        return Left(CacheFailure(message: 'Lote not found locally'));
      }
      final lote = loteTable.toEntity();
      return Right(lote);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get lote by id: $e'));
    }
  }

  @override
  Future<Either<Failure, Lote>> getLoteByNumero(String numeroLote) async {
    try {
      final loteTable = await loteDao.getLoteByNumero(numeroLote);
      if (loteTable == null) {
        return Left(CacheFailure(message: 'Lote not found locally'));
      }
      final lote = loteTable.toEntity();
      return Right(lote);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get lote by numero: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Lote>>> getLotes() async {
    try {
      final loteTables = await loteDao.getAllLotes();
      final lotes = loteTables.map((table) => table.toEntity()).toList();
      return Right(lotes);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get lotes: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Lote>>> getLotesByFactura(
    String numeroFactura,
  ) async {
    try {
      final loteTables = await loteDao.getLotesByFactura(numeroFactura);
      final lotes = loteTables.map((table) => table.toEntity()).toList();
      return Right(lotes);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get lotes by factura: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Lote>>> getLotesByProducto(
    String productoId,
  ) async {
    try {
      final loteTables = await loteDao.getLotesByProducto(productoId);
      final lotes = loteTables.map((table) => table.toEntity()).toList();
      return Right(lotes);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get lotes by producto: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Lote>>> getLotesByProveedor(
    String proveedorId,
  ) async {
    try {
      final loteTables = await loteDao.getLotesByProveedor(proveedorId);
      final lotes = loteTables.map((table) => table.toEntity()).toList();
      return Right(lotes);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to get lotes by proveedor: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Lote>>> getLotesConCertificado() async {
    try {
      final loteTables = await loteDao.getLotesConCertificado();
      final lotes = loteTables.map((table) => table.toEntity()).toList();
      return Right(lotes);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to get lotes con certificado: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Lote>>> getLotesConStock() async {
    try {
      final loteTables = await loteDao.getLotesConStock();
      final lotes = loteTables.map((table) => table.toEntity()).toList();
      return Right(lotes);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get lotes con stock: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Lote>>> getLotesPorVencer() async {
    try {
      final loteTables = await loteDao.getLotesPorVencer();
      final lotes = loteTables.map((table) => table.toEntity()).toList();
      return Right(lotes);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get lotes por vencer: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Lote>>> getLotesVacios() async {
    try {
      final loteTables = await loteDao.getLotesVacios();
      final lotes = loteTables.map((table) => table.toEntity()).toList();
      return Right(lotes);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get lotes vacios: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Lote>>> getLotesVencidos() async {
    try {
      final loteTables = await loteDao.getLotesVencidos();
      final lotes = loteTables.map((table) => table.toEntity()).toList();
      return Right(lotes);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get lotes vencidos: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Lote>>> searchLotes(String query) async {
    try {
      final loteTables = await loteDao.searchLotes(query);
      final lotes = loteTables.map((table) => table.toEntity()).toList();
      return Right(lotes);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to search lotes: $e'));
    }
  }

  @override
  Future<Either<Failure, Lote>> updateCantidadLote({
    required String loteId,
    required int cantidadNueva,
  }) async {
    try {
      // Update locally
      final updated = await loteDao.updateCantidadLote(loteId, cantidadNueva);
      if (!updated) {
        return Left(CacheFailure(message: 'Lote not found locally'));
      }

      // Add to sync queue for remote sync
      await syncManager.queueChange(
        entityId: loteId,
        entityType: SyncEntityType.lote,
        operation: SyncOperation.update,
        data: {'id': loteId, 'cantidad_actual': cantidadNueva},
      );

      // Retrieve updated lote
      final loteTable = await loteDao.getLoteById(loteId);
      if (loteTable == null) {
        return Left(CacheFailure(message: 'Lote not found after update'));
      }
      final lote = loteTable.toEntity();

      return Right(lote);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to update cantidad lote: $e'));
    }
  }

  @override
  Future<Either<Failure, Lote>> updateLote(Lote lote) async {
    try {
      // First update locally
      final loteTable = lote.toTable();

      final updated = await loteDao.updateLote(loteTable);
      if (!updated) {
        return Left(CacheFailure(message: 'Lote not found locally'));
      }

      // Add to sync queue for remote update
      await syncManager.queueChange(
        entityId: lote.id,
        entityType: SyncEntityType.lote,
        operation: SyncOperation.update,
        data: lote.toJson(),
      );

      return Right(lote);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to update lote: $e'));
    }
  }
}
