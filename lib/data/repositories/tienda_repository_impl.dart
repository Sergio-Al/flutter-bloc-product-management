import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/core/network/network_info.dart';
import 'package:flutter_management_system/core/sync/sync_item.dart';
import 'package:flutter_management_system/core/sync/sync_manager.dart';
import 'package:flutter_management_system/core/utils/logger.dart';
import 'package:flutter_management_system/data/datasources/local/database/daos/tienda_dao.dart';
import 'package:flutter_management_system/data/datasources/remote/tienda_remote_datasource.dart';
import 'package:flutter_management_system/data/mappers/tienda_mapper.dart';
import 'package:flutter_management_system/domain/entities/tienda.dart';
import 'package:flutter_management_system/domain/repositories/tienda_repository.dart';

class TiendaRepositoryImpl extends TiendaRepository {
  final TiendaRemoteDataSource remoteDataSource;
  final TiendaDao tiendaDao;
  final NetworkInfo networkInfo;
  final SyncManager syncManager;

  TiendaRepositoryImpl({
    required this.remoteDataSource,
    required this.tiendaDao,
    required this.networkInfo,
    required this.syncManager,
  });

  @override
  Future<Either<Failure, Tienda>> createTienda(Tienda tienda) async {
    try {
      // First save locally
      // Convert entity to Drift TiendaTable object using mapper
      final tiendaTable = tienda.toTable();

      // Save to local database
      await tiendaDao.insertTienda(tiendaTable);

      // Add to sync queue for remote sync
      await syncManager.queueChange(
        entityId: tienda.id,
        entityType: SyncEntityType.tienda,
        operation: SyncOperation.create,
        data: tienda.toJson(),
      );

      return Right(tienda);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to create tienda: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTienda(String id) async {
    try {
      // First mark as deleted locally
      final deleted = await tiendaDao.deleteTienda(id);
      if (!deleted) {
        return Left(CacheFailure(message: 'Tienda not found locally'));
      }

      // Add to sync queue for remote sync
      await syncManager.queueChange(
        entityId: id,
        entityType: SyncEntityType.tienda,
        operation: SyncOperation.delete,
        data: {'id': id},
      );

      return Right(unit);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to delete tienda: $e'));
    }
  }

  @override
  Future<Either<Failure, Tienda>> getTiendaByCodigo(String codigo) async {
    try {
      // First try to get from local database
      final tiendaTable = await tiendaDao.getTiendaByCodigo(codigo);
      if (tiendaTable != null) {
        final tienda = tiendaTable.toEntity();
        return Right(tienda);
      } else {
        return Left(CacheFailure(message: 'Tienda not found locally'));
      }
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get tienda by codigo: $e'));
    }
  }

  @override
  Future<Either<Failure, Tienda>> getTiendaById(String id) async {
    try {
      // First try to get from local database
      final tiendaTable = await tiendaDao.getTiendaById(id);
      if (tiendaTable != null) {
        final tienda = tiendaTable.toEntity();

        AppLogger.info('Fetched tienda locally: ${tienda}');
        return Right(tienda);
      } else {
        return Left(CacheFailure(message: 'Tienda not found locally'));
      }
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get tienda by id: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Tienda>>> getTiendas() async {
    try {
      // Get all tiendas from local database
      final tiendaTables = await tiendaDao.getAllTiendas();
      final tiendas = tiendaTables.map((table) => table.toEntity()).toList();
      return Right(tiendas);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get tiendas: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Tienda>>> getTiendasActivas() async {
    try {
      // Get active tiendas from local database
      final tiendaTables = await tiendaDao.getTiendasActivas();
      final tiendas = tiendaTables.map((table) => table.toEntity()).toList();
      return Right(tiendas);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get active tiendas: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Tienda>>> getTiendasByCiudad(
    String ciudad,
  ) async {
    try {
      // Get tiendas by ciudad from local database
      final tiendaTables = await tiendaDao.getTiendasByCiudad(ciudad);
      final tiendas = tiendaTables.map((table) => table.toEntity()).toList();
      return Right(tiendas);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get tiendas by ciudad: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Tienda>>> getTiendasByDepartamento(
    String departamento,
  ) async {
    try {
      // Get tiendas by departamento from local database
      final tiendaTables = await tiendaDao.getTiendasByDepartamento(
        departamento,
      );
      final tiendas = tiendaTables.map((table) => table.toEntity()).toList();
      return Right(tiendas);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to get tiendas by departamento: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Tienda>>> searchTiendas(String query) async {
    try {
      // Search tiendas from local database
      final tiendaTables = await tiendaDao.searchTiendas(query);
      final tiendas = tiendaTables.map((table) => table.toEntity()).toList();
      return Right(tiendas);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to search tiendas: $e'));
    }
  }

  @override
  Future<Either<Failure, Tienda>> toggleTiendaActiva(String id) async {
    try {
      // First get the tienda locally
      final tiendaTable = await tiendaDao.getTiendaById(id);
      if (tiendaTable == null) {
        return Left(CacheFailure(message: 'Tienda not found locally'));
      }

      // Toggle activo status
      final updatedTiendaTable = tiendaTable.copyWith(
        activo: !tiendaTable.activo,
      );

      // Update locally
      final updated = await tiendaDao.updateTienda(updatedTiendaTable);
      if (!updated) {
        return Left(CacheFailure(message: 'Failed to update tienda locally'));
      }

      final updatedTienda = updatedTiendaTable.toEntity();

      // Add to sync queue for remote sync
      await syncManager.queueChange(
        entityId: id,
        entityType: SyncEntityType.tienda,
        operation: SyncOperation.update,
        data: updatedTienda.toJson(),
      );

      return Right(updatedTienda);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to toggle tienda activa: $e'));
    }
  }

  @override
  Future<Either<Failure, Tienda>> updateTienda(Tienda tienda) async {
    try {
      // First update locally
      final tiendaTable = tienda.toTable();

      final updated = await tiendaDao.updateTienda(tiendaTable);
      if (!updated) {
        return Left(CacheFailure(message: 'Tienda not found locally'));
      }

      // Add to sync queue for remote update
      await syncManager.queueChange(
        entityId: tienda.id,
        entityType: SyncEntityType.tienda,
        operation: SyncOperation.update,
        data: tienda.toJson(),
      );

      return Right(tienda);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to update tienda: $e'));
    }
  }
}
