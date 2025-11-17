

import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/core/network/network_info.dart';
import 'package:flutter_management_system/core/sync/sync_item.dart';
import 'package:flutter_management_system/core/sync/sync_manager.dart';
import 'package:flutter_management_system/core/utils/logger.dart';
import 'package:flutter_management_system/data/datasources/local/database/app_database.dart';
import 'package:flutter_management_system/data/datasources/local/database/daos/almacen_dao.dart';
import 'package:flutter_management_system/data/datasources/remote/almacen_remote_datasource.dart';
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
  Future<Either<Failure, Almacen>> createAlmacen(Almacen almacen) async{
    try{
      // First save locally
      final tempSyncId = syncManager.generateTempSyncId();

      AppLogger.info('Creating almacen locally: ${almacen.nombre}');

      // Convert entity to Drift AlmacenTable object
      final almacenTable = AlmacenTable(
        id: almacen.id,
        nombre: almacen.nombre,
        codigo: almacen.codigo,
        tiendaId: almacen.tiendaId,
        activo: almacen.activo,
        createdAt: almacen.createdAt,
        updatedAt: almacen.updatedAt, 
        ubicacion: almacen.ubicacion, 
        tipo: almacen.tipo,
      );

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
  Future<Either<Failure, Unit>> deleteAlmacen(String id) {
    // TODO: implement deleteAlmacen
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Almacen>> getAlmacenByCodigo(String codigo) {
    // TODO: implement getAlmacenByCodigo
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Almacen>> getAlmacenById(String id) {
    // TODO: implement getAlmacenById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Almacen>> getAlmacenPrincipal(String tiendaId) {
    // TODO: implement getAlmacenPrincipal
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Almacen>>> getAlmacenes() {
    // TODO: implement getAlmacenes
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Almacen>>> getAlmacenesActivos() {
    // TODO: implement getAlmacenesActivos
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Almacen>>> getAlmacenesByTienda(String tiendaId) {
    // TODO: implement getAlmacenesByTienda
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Almacen>>> getAlmacenesByTipo(String tipo) {
    // TODO: implement getAlmacenesByTipo
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Almacen>>> searchAlmacenes(String query) {
    // TODO: implement searchAlmacenes
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Almacen>> toggleAlmacenActivo(String id) {
    // TODO: implement toggleAlmacenActivo
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Almacen>> updateAlmacen(Almacen almacen) {
    // TODO: implement updateAlmacen
    throw UnimplementedError();
  }

  
}
