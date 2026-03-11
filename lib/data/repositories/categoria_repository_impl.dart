import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/core/network/network_info.dart';
import 'package:flutter_management_system/core/sync/sync_item.dart';
import 'package:flutter_management_system/core/sync/sync_manager.dart';
import 'package:flutter_management_system/data/datasources/local/database/daos/categoria_dao.dart';
import 'package:flutter_management_system/data/datasources/remote/categoria_remote_datasource.dart';
import 'package:flutter_management_system/data/mappers/categoria_mapper.dart';
import 'package:flutter_management_system/domain/entities/categoria.dart';
import 'package:flutter_management_system/domain/repositories/categoria_repository.dart';

class CategoriaRepositoryImpl extends CategoriaRepository {
  final CategoriaRemoteDataSource remoteDataSource;
  final CategoriaDao categoriaDao;
  final NetworkInfo networkInfo;
  final SyncManager syncManager;

  CategoriaRepositoryImpl({
    required this.remoteDataSource,
    required this.categoriaDao,
    required this.networkInfo,
    required this.syncManager,
  });

  @override
  Future<Either<Failure, Categoria>> createCategoria(
    Categoria categoria,
  ) async {
    try {
      final categoriaTable = categoria.toTable();
      await categoriaDao.insertCategoria(categoriaTable);

      await syncManager.queueChange(
        entityId: categoria.id,
        entityType: SyncEntityType.categoria,
        operation: SyncOperation.create,
        data: categoria.toJson(),
      );

      return Right(categoria);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to create categoria: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCategoria(String id) async {
    try {
      final deleted = await categoriaDao.desactivarCategoria(id);
      if (!deleted) {
        return Left(CacheFailure(message: 'Categoria not found locally'));
      }

      await syncManager.queueChange(
        entityId: id,
        entityType: SyncEntityType.categoria,
        operation: SyncOperation.delete,
        data: {'id': id},
      );

      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to delete categoria: $e'));
    }
  }

  @override
  Future<Either<Failure, Categoria>> getCategoriaById(String id) async {
    try {
      final categoriaTable = await categoriaDao.getCategoriaById(id);
      if (categoriaTable == null) {
        return Left(CacheFailure(message: 'Categoria not found locally'));
      }
      return Right(categoriaTable.toEntity());
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get categoria by id: $e'));
    }
  }

  @override
  Future<Either<Failure, Categoria>> getCategoriaByCodigo(String codigo) async {
    try {
      final categoriaTable = await categoriaDao.getCategoriaByCodigo(codigo);
      if (categoriaTable == null) {
        return Left(CacheFailure(message: 'Categoria not found locally'));
      }
      return Right(categoriaTable.toEntity());
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to get categoria by codigo: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Categoria>>> getCategorias() async {
    try {
      final categoriasTables =
          await categoriaDao.getAllCategoriasIncluyendoInactivas();
      final categorias =
          categoriasTables.map((table) => table.toEntity()).toList();
      return Right(categorias);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get categorias: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Categoria>>> getCategoriasActivas() async {
    try {
      final categoriasTables = await categoriaDao.getAllCategorias();
      final categorias =
          categoriasTables.map((table) => table.toEntity()).toList();
      return Right(categorias);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to get categorias activas: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Categoria>>> getCategoriasRaiz() async {
    try {
      final categoriasTables = await categoriaDao.getCategoriasPrincipales();
      final categorias =
          categoriasTables.map((table) => table.toEntity()).toList();
      return Right(categorias);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get categorias raiz: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Categoria>>> getSubcategorias(
    String categoriaPadreId,
  ) async {
    try {
      final categoriasTables =
          await categoriaDao.getSubcategorias(categoriaPadreId);
      final categorias =
          categoriasTables.map((table) => table.toEntity()).toList();
      return Right(categorias);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get subcategorias: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Categoria>>> getCategoriasRequierenLote() async {
    try {
      final categoriasTables = await categoriaDao.getCategoriasConLote();
      final categorias =
          categoriasTables.map((table) => table.toEntity()).toList();
      return Right(categorias);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to get categorias que requieren lote: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Categoria>>>
      getCategoriasRequierenCertificacion() async {
    try {
      final categoriasTables =
          await categoriaDao.getCategoriasConCertificacion();
      final categorias =
          categoriasTables.map((table) => table.toEntity()).toList();
      return Right(categorias);
    } catch (e) {
      return Left(
        CacheFailure(
          message:
              'Failed to get categorias que requieren certificacion: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Categoria>>> searchCategorias(
    String query,
  ) async {
    try {
      final categoriasTables = await categoriaDao.searchCategorias(query);
      final categorias =
          categoriasTables.map((table) => table.toEntity()).toList();
      return Right(categorias);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to search categorias: $e'));
    }
  }

  @override
  Future<Either<Failure, Categoria>> toggleCategoriaActiva(String id) async {
    try {
      final categoriaTable = await categoriaDao.getCategoriaById(id);
      if (categoriaTable == null) {
        return Left(CacheFailure(message: 'Categoria not found locally'));
      }

      bool updated;
      if (categoriaTable.activo) {
        updated = await categoriaDao.desactivarCategoria(id);
      } else {
        updated = await categoriaDao.activarCategoria(id);
      }

      if (!updated) {
        return Left(
          CacheFailure(message: 'Failed to toggle categoria activa locally'),
        );
      }

      final updatedTable = await categoriaDao.getCategoriaById(id);
      if (updatedTable == null) {
        return Left(CacheFailure(message: 'Categoria not found after update'));
      }

      await syncManager.queueChange(
        entityId: id,
        entityType: SyncEntityType.categoria,
        operation: SyncOperation.update,
        data: updatedTable.toEntity().toJson(),
      );

      return Right(updatedTable.toEntity());
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to toggle categoria activa: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, Categoria>> updateCategoria(
    Categoria categoria,
  ) async {
    try {
      final categoriaTable = categoria.toTable();
      final updated = await categoriaDao.updateCategoria(categoriaTable);
      if (!updated) {
        return Left(CacheFailure(message: 'Categoria not found locally'));
      }

      await syncManager.queueChange(
        entityId: categoria.id,
        entityType: SyncEntityType.categoria,
        operation: SyncOperation.update,
        data: categoria.toJson(),
      );

      return Right(categoria);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to update categoria: $e'));
    }
  }
}
