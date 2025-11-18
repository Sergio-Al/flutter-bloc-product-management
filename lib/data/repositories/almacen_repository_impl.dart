import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/core/network/network_info.dart';
import 'package:flutter_management_system/core/sync/sync_item.dart';
import 'package:flutter_management_system/core/sync/sync_manager.dart';
import 'package:flutter_management_system/core/utils/logger.dart';
import 'package:flutter_management_system/data/datasources/local/database/daos/almacen_dao.dart';
import 'package:flutter_management_system/data/datasources/remote/almacen_remote_datasource.dart';
import 'package:flutter_management_system/data/mappers/almacen_mapper.dart';
import 'package:flutter_management_system/domain/entities/almacen.dart';
import 'package:flutter_management_system/domain/repositories/almacen_repository.dart';

class AlmacenRepositoryImpl extends AlmacenRepository {
  final AlmacenRemoteDataSource remoteDataSource;
  final AlmacenDao almacenDao;
  final NetworkInfo networkInfo;
  final SyncManager syncManager;

  AlmacenRepositoryImpl({
    required this.remoteDataSource,
    required this.almacenDao,
    required this.networkInfo,
    required this.syncManager,
  });

  @override
  Future<Either<Failure, Almacen>> createAlmacen(Almacen almacen) async {
    try {
      // First save locally
      final tempSyncId = syncManager.generateTempSyncId();

      AppLogger.info('Creating almacen locally: ${almacen.nombre}');

      // Convert entity to Drift AlmacenTable object using mapper
      final almacenTable = almacen.toTable();

      // Save to local database
      await almacenDao.insertAlmacen(almacenTable);

      AppLogger.info('Almacen created locally with tempSyncId: $tempSyncId');

      // Add to sync queue for remote sync
      await syncManager.queueChange(
        entityId: almacen.id,
        entityType: SyncEntityType.almacen,
        operation: SyncOperation.create,
        data: almacen.toJson(),
      );

      return Right(almacen);
    } catch (e) {
      AppLogger.error('Error creating almacen: $e');
      return Left(CacheFailure(message: 'Failed to create almacen: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAlmacen(String id) async {
    try {
      // First mark as deleted locally
      final deleted = await almacenDao.deleteAlmacen(id);
      if (!deleted) {
        return Left(CacheFailure(message: 'Almacen not found locally'));
      }

      // Add to sync queue for remote deletion
      await syncManager.queueChange(
        entityId: id,
        entityType: SyncEntityType.almacen,
        operation: SyncOperation.delete,
        data: {'id': id},
      );

      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to delete almacen: $e'));
    }
  }

  @override
  Future<Either<Failure, Almacen>> getAlmacenByCodigo(String codigo) async {
    try {
      // Fetch from local database
      final almacenTable = await almacenDao.getAlmacenByCodigo(codigo);
      if (almacenTable == null) {
        return Left(CacheFailure(message: 'Almacen not found locally'));
      }
      // Convert to domain entity using mapper
      final almacen = almacenTable.toEntity();
      return Right(almacen);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get almacen by codigo: $e'));
    }
  }

  @override
  Future<Either<Failure, Almacen>> getAlmacenById(String id) async {
    try {
      // Fetch from local database
      final almacenTable = await almacenDao.getAlmacenById(id);
      if (almacenTable == null) {
        return Left(CacheFailure(message: 'Almacen not found locally'));
      }
      // Convert to domain entity using mapper
      final almacen = almacenTable.toEntity();
      return Right(almacen);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get almacen by id: $e'));
    }
  }

  @override
  Future<Either<Failure, Almacen>> getAlmacenPrincipal(String tiendaId) async {
    try {
      // Fetch from local database
      final almacenTable = await almacenDao.getAlmacenPrincipal(tiendaId);
      if (almacenTable == null) {
        return Left(CacheFailure(message: 'Almacen principal not found locally'));
      }
      // Convert to domain entity using mapper
      final almacen = almacenTable.toEntity();
      return Right(almacen);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get almacen principal: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Almacen>>> getAlmacenes() async {
    try {
      // Fetch from local database
      final almacenTables = await almacenDao.getAllAlmacenes();
      // Convert to domain entities using mapper
      final almacenes = almacenTables.map((table) => table.toEntity()).toList();
      return Right(almacenes);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get almacenes: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Almacen>>> getAlmacenesActivos() async {
    try {
      // Fetch from local database
      final almacenTables = await almacenDao.getAlmacenesActivos();
      // Convert to domain entities using mapper
      final almacenes = almacenTables.map((table) => table.toEntity()).toList();
      return Right(almacenes);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get active almacenes: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Almacen>>> getAlmacenesByTienda(
    String tiendaId,
  ) async {
    try {
      // Fetch from local database
      final almacenTables = await almacenDao.getAlmacenesByTienda(tiendaId);
      // Convert to domain entities using mapper
      final almacenes = almacenTables.map((table) => table.toEntity()).toList();
      return Right(almacenes);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to get almacenes by tienda: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Almacen>>> getAlmacenesByTipo(String tipo) async {
    try {
      // Fetch from local database
      final almacenTables = await almacenDao.getAlmacenesByTipo(tipo);
      // Convert to domain entities using mapper
      final almacenes = almacenTables.map((table) => table.toEntity()).toList();
      return Right(almacenes);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get almacenes by tipo: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Almacen>>> searchAlmacenes(String query) async {
    try {
      // Fetch from local database
      final almacenTables = await almacenDao.searchAlmacenes(query);
      // Convert to domain entities using mapper
      final almacenes = almacenTables.map((table) => table.toEntity()).toList();
      return Right(almacenes);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to search almacenes: $e'));
    }
  }

  @override
  Future<Either<Failure, Almacen>> toggleAlmacenActivo(String id) async {
    try {
      // Fetch almacen locally
      final almacenTable = await almacenDao.getAlmacenById(id);
      if (almacenTable == null) {
        return Left(CacheFailure(message: 'Almacen not found locally'));
      }

      // Toggle activo status
      final updatedAlmacenTable = almacenTable.copyWith(
        activo: !almacenTable.activo,
      );
      final updated = await almacenDao.updateAlmacen(updatedAlmacenTable);
      if (!updated) {
        return Left(CacheFailure(message: 'Failed to update almacen locally'));
      }
      return Right(updatedAlmacenTable.toEntity());
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to toggle almacen activo: $e'));
    }
  }

  @override
  Future<Either<Failure, Almacen>> updateAlmacen(Almacen almacen) async {
    try {
      // First update locally
      final almacenTable = almacen.toTable();

      AppLogger.info('Updating almacen locally: ${almacen.id}');
      final updated = await almacenDao.updateAlmacen(almacenTable);
      if (!updated) {
        return Left(CacheFailure(message: 'Almacen not found locally'));
      }

      // Add to sync queue for remote update
      await syncManager.queueChange(
        entityId: almacen.id,
        entityType: SyncEntityType.almacen,
        operation: SyncOperation.update,
        data: almacen.toJson(),
      );
      return Right(almacen);
    } catch (e) {
      AppLogger.error('Error updating almacen: $e');
      return Left(CacheFailure(message: 'Failed to update almacen: $e'));
    }
  }
}
