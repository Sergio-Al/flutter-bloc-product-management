import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/core/network/network_info.dart';
import 'package:flutter_management_system/core/sync/sync_item.dart';
import 'package:flutter_management_system/core/sync/sync_manager.dart';
import 'package:flutter_management_system/data/datasources/local/database/daos/proveedor_dao.dart';
import 'package:flutter_management_system/data/datasources/remote/proveedor_remote_datasource.dart';
import 'package:flutter_management_system/data/mappers/proveedor_mapper.dart';
import 'package:flutter_management_system/domain/entities/proveedor.dart';
import 'package:flutter_management_system/domain/repositories/proveedor_repository.dart';

class ProveedorRepositoryImpl extends ProveedorRepository {
  final ProveedorRemoteDataSource remoteDataSource;
  final ProveedorDao proveedorDao;
  final NetworkInfo networkInfo;
  final SyncManager syncManager;

  ProveedorRepositoryImpl({
    required this.remoteDataSource,
    required this.proveedorDao,
    required this.networkInfo,
    required this.syncManager,
  });

  @override
  Future<Either<Failure, Proveedor>> createProveedor(
    Proveedor proveedor,
  ) async {
    try {
      // First save locally
      // Convert entity to Drift ProveedorTable object using mapper
      final proveedorTable = proveedor.toTable();

      // Save to local database
      await proveedorDao.insertProveedor(proveedorTable);

      // Add to sync queue for remote sync
      await syncManager.queueChange(
        entityId: proveedor.id,
        entityType: SyncEntityType.proveedor,
        operation: SyncOperation.create,
        data: proveedor.toJson(),
      );

      return Right(proveedor);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to create proveedor: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProveedor(String id) async {
    try {
      // First mark as deleted locally
      final deleted = await proveedorDao.deleteProveedor(id);
      if (!deleted) {
        return Left(CacheFailure(message: 'Proveedor not found locally'));
      }

      // Add to sync queue for remote sync
      await syncManager.queueChange(
        entityId: id,
        entityType: SyncEntityType.proveedor,
        operation: SyncOperation.delete,
        data: {'id': id},
      );

      return Right(unit);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to delete proveedor: $e'));
    }
  }

  @override
  Future<Either<Failure, Proveedor>> getProveedorById(String id) async {
    try {
      // First try to get from local database
      final proveedorTable = await proveedorDao.getProveedorById(id);
      if (proveedorTable != null) {
        return Right(proveedorTable.toEntity());
      } else {
        return Left(CacheFailure(message: 'Proveedor not found locally'));
      }
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get proveedor: $e'));
    }
  }

  @override
  Future<Either<Failure, Proveedor>> getProveedorByNit(String nit) async {
    try {
      // First try to get from local database
      final proveedorTable = await proveedorDao.getProveedorByNit(nit);
      if (proveedorTable != null) {
        return Right(proveedorTable.toEntity());
      } else {
        return Left(CacheFailure(message: 'Proveedor not found locally'));
      }
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get proveedor: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Proveedor>>> getProveedores() async {
    try {
      // First try to get from local database
      final proveedorTables = await proveedorDao.getAllProveedores();
      final proveedores = proveedorTables
          .map((table) => table.toEntity())
          .toList();
      return Right(proveedores);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get proveedores: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Proveedor>>> getProveedoresActivos() async {
    try {
      // First try to get from local database
      final proveedorTables = await proveedorDao.getAllProveedoresActivos();
      final proveedores = proveedorTables
          .map((table) => table.toEntity())
          .toList();
      return Right(proveedores);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to get proveedores activos: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Proveedor>>> getProveedoresByCiudad(
    String ciudad,
  ) async {
    try {
      // First try to get from local database
      final proveedorTables = await proveedorDao.getProveedoresByCiudad(ciudad);
      final proveedores = proveedorTables
          .map((table) => table.toEntity())
          .toList();
      return Right(proveedores);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to get proveedores by ciudad: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Proveedor>>> getProveedoresByTipoMaterial(
    String tipoMaterial,
  ) async {
    try {
      // First try to get from local database
      final proveedorTables = await proveedorDao.getProveedoresByTipoMaterial(
        tipoMaterial,
      );
      final proveedores = proveedorTables
          .map((table) => table.toEntity())
          .toList();
      return Right(proveedores);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to get proveedores by tipoMaterial: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Proveedor>>> getProveedoresConCredito() async {
    try {
      // First try to get from local database
      final proveedorTables = await proveedorDao.getProveedoresConCredito();
      final proveedores = proveedorTables
          .map((table) => table.toEntity())
          .toList();
      return Right(proveedores);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to get proveedores con credito: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Proveedor>>> searchProveedores(
    String query,
  ) async {
    try {
      // First try to get from local database
      final proveedorTables = await proveedorDao.searchProveedores(query);
      final proveedores = proveedorTables
          .map((table) => table.toEntity())
          .toList();
      return Right(proveedores);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to search proveedores: $e'));
    }
  }

  @override
  Future<Either<Failure, Proveedor>> toggleProveedorActivo(String id) async {
    try {
      // First get the proveedor locally
      final proveedorTable = await proveedorDao.getProveedorById(id);
      if (proveedorTable == null) {
        return Left(CacheFailure(message: 'Proveedor not found locally'));
      }

      // Toggle activo status
      final updatedTable = proveedorTable.copyWith(
        activo: !proveedorTable.activo,
      );

      // Update in local database
      await proveedorDao.updateProveedor(updatedTable);

      // Add to sync queue for remote sync
      await syncManager.queueChange(
        entityId: id,
        entityType: SyncEntityType.proveedor,
        operation: SyncOperation.update,
        data: updatedTable.toEntity().toJson(),
      );

      return Right(updatedTable.toEntity());
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to toggle proveedor activo: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, Proveedor>> updateProveedor(
    Proveedor proveedor,
  ) async {
    try {
      // First update locally
      final proveedorTable = proveedor.toTable();

      final updated = await proveedorDao.updateProveedor(proveedorTable);
      if (!updated) {
        return Left(CacheFailure(message: 'Proveedor not found locally'));
      }

      // Add to sync queue for remote sync
      await syncManager.queueChange(
        entityId: proveedor.id,
        entityType: SyncEntityType.proveedor,
        operation: SyncOperation.update,
        data: proveedor.toJson(),
      );

      return Right(proveedor);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to update proveedor: $e'));
    }
  }
}
