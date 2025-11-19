import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/core/network/network_info.dart';
import 'package:flutter_management_system/core/sync/sync_item.dart';
import 'package:flutter_management_system/core/sync/sync_manager.dart';
import 'package:flutter_management_system/data/datasources/local/database/daos/inventario_dao.dart';
import 'package:flutter_management_system/data/datasources/remote/inventario_remote_datasource.dart';
import 'package:flutter_management_system/data/mappers/inventario_mapper.dart';
import 'package:flutter_management_system/domain/entities/inventario.dart';
import 'package:flutter_management_system/domain/repositories/inventario_repository.dart';
import 'package:flutter_management_system/core/utils/logger.dart';

class InventarioRepositoryImpl extends InventarioRepository {
  final InventarioRemoteDataSource remoteDataSource;
  final InventarioDao inventarioDao;
  final NetworkInfo networkInfo;
  final SyncManager syncManager;

  InventarioRepositoryImpl({
    required this.remoteDataSource,
    required this.inventarioDao,
    required this.networkInfo,
    required this.syncManager,
  });

  @override
  Future<Either<Failure, Inventario>> ajustarInventario({
    required String inventarioId,
    required int cantidadNueva,
    required String motivo,
  }) async {
    try {
      // Fetch existing inventario
      final existingInventarioTable = await inventarioDao.getInventarioById(
        inventarioId,
      );
      if (existingInventarioTable == null) {
        return Left(CacheFailure(message: 'Inventario not found locally'));
      }

      // Update stock using DAO method
      final success = await inventarioDao.updateStock(
        inventarioId,
        cantidadNueva,
        cantidadReservada: existingInventarioTable.cantidadReservada,
      );

      if (!success) {
        return Left(CacheFailure(message: 'Failed to update stock'));
      }

      // Get updated inventario
      final updatedInventarioTable = await inventarioDao.getInventarioById(
        inventarioId,
      );
      if (updatedInventarioTable == null) {
        return Left(
          CacheFailure(message: 'Failed to retrieve updated inventario'),
        );
      }

      final updatedInventario = updatedInventarioTable.toEntity();

      // Add to sync queue for remote sync
      await syncManager.queueChange(
        entityId: updatedInventario.id,
        entityType: SyncEntityType.inventario,
        operation: SyncOperation.update,
        data: updatedInventario.toJson(),
      );

      return Right(updatedInventario);
    } catch (e) {
      AppLogger.error('InventarioRepositoryImpl.ajustarInventario', e);
      return Left(CacheFailure(message: 'Failed to ajustar inventario: $e'));
    }
  }

  @override
  Future<Either<Failure, Inventario>> createInventario(
    Inventario inventario,
  ) async {
    try {
      // First save locally
      // Convert entity to Drift InventarioTable object using mapper
      final inventarioTable = inventario.toTable();

      // Save to local database
      await inventarioDao.insertInventario(inventarioTable);

      // Add to sync queue for remote sync
      await syncManager.queueChange(
        entityId: inventario.id,
        entityType: SyncEntityType.inventario,
        operation: SyncOperation.create,
        data: inventario.toJson(),
      );

      return Right(inventario);
    } catch (e) {
      AppLogger.error('InventarioRepositoryImpl.createInventario', e);
      return Left(CacheFailure(message: 'Failed to create inventario: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteInventario(String id) async {
    try {
      // Delete locally
      await inventarioDao.deleteInventario(id);

      // Add to sync queue for remote sync
      await syncManager.queueChange(
        entityId: id,
        entityType: SyncEntityType.inventario,
        operation: SyncOperation.delete,
        data: {'id': id},
      );

      return Right(unit);
    } catch (e) {
      AppLogger.error('InventarioRepositoryImpl.deleteInventario', e);
      return Left(CacheFailure(message: 'Failed to delete inventario: $e'));
    }
  }

  @override
  Future<Either<Failure, Inventario>> getInventarioById(String id) async {
    try {
      final inventarioTable = await inventarioDao.getInventarioById(id);
      if (inventarioTable == null) {
        return Left(CacheFailure(message: 'Inventario not found'));
      }
      final inventario = inventarioTable.toEntity();
      return Right(inventario);
    } catch (e) {
      AppLogger.error('InventarioRepositoryImpl.getInventarioById', e);
      return Left(CacheFailure(message: 'Failed to get inventario: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Inventario>>> getInventarios() async {
    try {
      final inventarioTables = await inventarioDao.getAllInventarios();
      final inventarios =
          inventarioTables.map((table) => table.toEntity()).toList();
      return Right(inventarios);
    } catch (e) {
      AppLogger.error('InventarioRepositoryImpl.getInventarios', e);
      return Left(CacheFailure(message: 'Failed to get inventarios: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Inventario>>> getInventariosByAlmacen(
    String almacenId,
  ) async {
    try {
      final inventarioTables =
          await inventarioDao.getInventarioByAlmacen(almacenId);
      final inventarios =
          inventarioTables.map((table) => table.toEntity()).toList();
      return Right(inventarios);
    } catch (e) {
      AppLogger.error('InventarioRepositoryImpl.getInventariosByAlmacen', e);
      return Left(
        CacheFailure(message: 'Failed to get inventarios by almacen: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Inventario>>> getInventariosByLote(
    String loteId,
  ) async {
    try {
      final inventarioTables = await inventarioDao.getInventarioByLote(loteId);
      final inventarios =
          inventarioTables.map((table) => table.toEntity()).toList();
      return Right(inventarios);
    } catch (e) {
      AppLogger.error('InventarioRepositoryImpl.getInventariosByLote', e);
      return Left(
        CacheFailure(message: 'Failed to get inventarios by lote: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Inventario>>> getInventariosByProducto(
    String productoId,
  ) async {
    try {
      final inventarioTables =
          await inventarioDao.getInventarioByProducto(productoId);
      final inventarios =
          inventarioTables.map((table) => table.toEntity()).toList();
      return Right(inventarios);
    } catch (e) {
      AppLogger.error('InventarioRepositoryImpl.getInventariosByProducto', e);
      return Left(
        CacheFailure(message: 'Failed to get inventarios by producto: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Inventario>>> getInventariosByTienda(
    String tiendaId,
  ) async {
    try {
      final inventarioTables =
          await inventarioDao.getInventarioByTienda(tiendaId);
      final inventarios =
          inventarioTables.map((table) => table.toEntity()).toList();
      return Right(inventarios);
    } catch (e) {
      AppLogger.error('InventarioRepositoryImpl.getInventariosByTienda', e);
      return Left(
        CacheFailure(message: 'Failed to get inventarios by tienda: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Inventario>>> getInventariosDisponibles() async {
    try {
      final inventarioTables =
          await inventarioDao.getInventariosDisponibles();
      final inventarios =
          inventarioTables.map((table) => table.toEntity()).toList();
      return Right(inventarios);
    } catch (e) {
      AppLogger.error('InventarioRepositoryImpl.getInventariosDisponibles', e);
      return Left(
        CacheFailure(message: 'Failed to get inventarios disponibles: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Inventario>>> getInventariosStockBajo() async {
    try {
      // Get all almacenes and check stock bajo for each
      final inventarioTables = await inventarioDao.getAllInventarios();
      // Filter those with low stock (cantidadActual < 10)
      final stockBajo = inventarioTables
          .where((inv) => inv.cantidadActual < 10)
          .toList();
      final inventarios = stockBajo.map((table) => table.toEntity()).toList();
      return Right(inventarios);
    } catch (e) {
      AppLogger.error('InventarioRepositoryImpl.getInventariosStockBajo', e);
      return Left(
        CacheFailure(message: 'Failed to get inventarios stock bajo: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, double>> getValorTotalInventario(
    String tiendaId,
  ) async {
    try {
      final inventarioTables =
          await inventarioDao.getInventarioByTienda(tiendaId);
      final valorTotal = inventarioTables.fold<double>(
        0.0,
        (sum, inv) => sum + inv.valorTotal,
      );
      return Right(valorTotal);
    } catch (e) {
      AppLogger.error('InventarioRepositoryImpl.getValorTotalInventario', e);
      return Left(
        CacheFailure(message: 'Failed to get valor total inventario: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, Inventario>> liberarStock({
    required String inventarioId,
    required int cantidad,
  }) async {
    try {
      final existingInventarioTable = await inventarioDao.getInventarioById(
        inventarioId,
      );
      if (existingInventarioTable == null) {
        return Left(CacheFailure(message: 'Inventario not found'));
      }

      final nuevaCantidadReservada =
          existingInventarioTable.cantidadReservada - cantidad;

      if (nuevaCantidadReservada < 0) {
        return Left(CacheFailure(message: 'No hay suficiente stock reservado'));
      }

      final success = await inventarioDao.updateStock(
        inventarioId,
        existingInventarioTable.cantidadActual,
        cantidadReservada: nuevaCantidadReservada,
      );

      if (!success) {
        return Left(CacheFailure(message: 'Failed to liberar stock'));
      }

      final updatedInventarioTable = await inventarioDao.getInventarioById(
        inventarioId,
      );
      final updatedInventario = updatedInventarioTable!.toEntity();

      await syncManager.queueChange(
        entityId: updatedInventario.id,
        entityType: SyncEntityType.inventario,
        operation: SyncOperation.update,
        data: updatedInventario.toJson(),
      );

      return Right(updatedInventario);
    } catch (e) {
      AppLogger.error('InventarioRepositoryImpl.liberarStock', e);
      return Left(CacheFailure(message: 'Failed to liberar stock: $e'));
    }
  }

  @override
  Future<Either<Failure, Inventario>> reservarStock({
    required String inventarioId,
    required int cantidad,
  }) async {
    try {
      final existingInventarioTable = await inventarioDao.getInventarioById(
        inventarioId,
      );
      if (existingInventarioTable == null) {
        return Left(CacheFailure(message: 'Inventario not found'));
      }

      final nuevaCantidadReservada =
          existingInventarioTable.cantidadReservada + cantidad;

      if (nuevaCantidadReservada > existingInventarioTable.cantidadActual) {
        return Left(CacheFailure(message: 'Stock insuficiente para reservar'));
      }

      final success = await inventarioDao.updateStock(
        inventarioId,
        existingInventarioTable.cantidadActual,
        cantidadReservada: nuevaCantidadReservada,
      );

      if (!success) {
        return Left(CacheFailure(message: 'Failed to reserve stock'));
      }

      final updatedInventarioTable = await inventarioDao.getInventarioById(
        inventarioId,
      );
      final updatedInventario = updatedInventarioTable!.toEntity();

      await syncManager.queueChange(
        entityId: updatedInventario.id,
        entityType: SyncEntityType.inventario,
        operation: SyncOperation.update,
        data: updatedInventario.toJson(),
      );

      return Right(updatedInventario);
    } catch (e) {
      AppLogger.error('InventarioRepositoryImpl.reservarStock', e);
      return Left(CacheFailure(message: 'Failed to reserve stock: $e'));
    }
  }

  @override
  Future<Either<Failure, Inventario>> updateInventario(
    Inventario inventario,
  ) async {
    try {
      final success = await inventarioDao.updateStock(
        inventario.id,
        inventario.cantidadActual,
        cantidadReservada: inventario.cantidadReservada,
      );

      if (!success) {
        return Left(CacheFailure(message: 'Failed to update inventario'));
      }

      await syncManager.queueChange(
        entityId: inventario.id,
        entityType: SyncEntityType.inventario,
        operation: SyncOperation.update,
        data: inventario.toJson(),
      );

      return Right(inventario);
    } catch (e) {
      AppLogger.error('InventarioRepositoryImpl.updateInventario', e);
      return Left(CacheFailure(message: 'Failed to update inventario: $e'));
    }
  }

  @override
  Future<Either<Failure, Inventario>> updateStock({
    required String inventarioId,
    required int cantidad,
  }) async {
    try {
      final existingInventarioTable = await inventarioDao.getInventarioById(
        inventarioId,
      );
      if (existingInventarioTable == null) {
        return Left(CacheFailure(message: 'Inventario not found'));
      }

      final success = await inventarioDao.updateStock(
        inventarioId,
        cantidad,
        cantidadReservada: existingInventarioTable.cantidadReservada,
      );

      if (!success) {
        return Left(CacheFailure(message: 'Failed to update stock'));
      }

      final updatedInventarioTable = await inventarioDao.getInventarioById(
        inventarioId,
      );
      final updatedInventario = updatedInventarioTable!.toEntity();

      await syncManager.queueChange(
        entityId: updatedInventario.id,
        entityType: SyncEntityType.inventario,
        operation: SyncOperation.update,
        data: updatedInventario.toJson(),
      );

      return Right(updatedInventario);
    } catch (e) {
      AppLogger.error('InventarioRepositoryImpl.updateStock', e);
      return Left(CacheFailure(message: 'Failed to update stock: $e'));
    }
  }
}
