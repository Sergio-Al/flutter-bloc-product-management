import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/core/network/network_info.dart';
import 'package:flutter_management_system/core/sync/sync_item.dart';
import 'package:flutter_management_system/core/sync/sync_manager.dart';
import 'package:flutter_management_system/data/datasources/local/database/daos/usuario_dao.dart';
import 'package:flutter_management_system/data/mappers/usuario_mapper.dart';
import 'package:flutter_management_system/domain/entities/usuario.dart';
import 'package:flutter_management_system/domain/repositories/usuario_repository.dart';

class UsuarioRepositoryImpl extends UsuarioRepository {
  final UsuarioDao usuarioDao;
  final NetworkInfo networkInfo;
  final SyncManager syncManager;

  UsuarioRepositoryImpl({
    required this.usuarioDao,
    required this.networkInfo,
    required this.syncManager,
  });

  @override
  Future<Either<Failure, Usuario>> createUsuario(Usuario usuario) async {
    try {
      final usuarioTable = usuario.toTable();
      await usuarioDao.insertUsuario(usuarioTable);

      await syncManager.queueChange(
        entityId: usuario.id,
        entityType: SyncEntityType.usuario,
        operation: SyncOperation.create,
        data: usuario.toJson(),
      );

      return Right(usuario);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to create usuario: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUsuario(String id) async {
    try {
      final deleted = await usuarioDao.deleteUsuario(id);
      if (!deleted) {
        return Left(CacheFailure(message: 'Usuario not found locally'));
      }

      await syncManager.queueChange(
        entityId: id,
        entityType: SyncEntityType.usuario,
        operation: SyncOperation.delete,
        data: {'id': id},
      );

      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to delete usuario: $e'));
    }
  }

  @override
  Future<Either<Failure, Usuario>> getUsuarioById(String id) async {
    try {
      final usuarioTable = await usuarioDao.getUsuarioById(id);
      if (usuarioTable == null) {
        return Left(CacheFailure(message: 'Usuario not found locally'));
      }
      return Right(usuarioTable.toEntity());
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get usuario by id: $e'));
    }
  }

  @override
  Future<Either<Failure, Usuario>> getUsuarioByEmail(String email) async {
    try {
      final usuarioTable = await usuarioDao.getUsuarioByEmail(email);
      if (usuarioTable == null) {
        return Left(CacheFailure(message: 'Usuario not found locally'));
      }
      return Right(usuarioTable.toEntity());
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get usuario by email: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Usuario>>> getUsuarios() async {
    try {
      final usuariosTables = await usuarioDao.getAllUsuarios();
      final usuarios = usuariosTables.map((table) => table.toEntity()).toList();
      return Right(usuarios);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get usuarios: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Usuario>>> getUsuariosActivos() async {
    try {
      final usuariosTables = await usuarioDao.getUsuariosActivos();
      final usuarios = usuariosTables.map((table) => table.toEntity()).toList();
      return Right(usuarios);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get usuarios activos: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Usuario>>> getUsuariosByTienda(
    String tiendaId,
  ) async {
    try {
      final usuariosTables = await usuarioDao.getUsuariosByTienda(tiendaId);
      final usuarios = usuariosTables.map((table) => table.toEntity()).toList();
      return Right(usuarios);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to get usuarios by tienda: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Usuario>>> getUsuariosByRol(String rolId) async {
    try {
      final usuariosTables = await usuarioDao.getUsuariosByRol(rolId);
      final usuarios = usuariosTables.map((table) => table.toEntity()).toList();
      return Right(usuarios);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get usuarios by rol: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Usuario>>> searchUsuarios(String query) async {
    try {
      final usuariosTables = await usuarioDao.searchUsuarios(query);
      final usuarios = usuariosTables.map((table) => table.toEntity()).toList();
      return Right(usuarios);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to search usuarios: $e'));
    }
  }

  @override
  Future<Either<Failure, Usuario>> toggleUsuarioActivo(String id) async {
    try {
      final usuarioTable = await usuarioDao.getUsuarioById(id);
      if (usuarioTable == null) {
        return Left(CacheFailure(message: 'Usuario not found locally'));
      }

      final newActivo = !usuarioTable.activo;
      final updated = await usuarioDao.toggleUsuarioActivo(
        id,
        activo: newActivo,
      );

      if (!updated) {
        return Left(
          CacheFailure(message: 'Failed to toggle usuario activo locally'),
        );
      }

      final updatedTable = await usuarioDao.getUsuarioById(id);
      if (updatedTable == null) {
        return Left(CacheFailure(message: 'Usuario not found after update'));
      }

      await syncManager.queueChange(
        entityId: id,
        entityType: SyncEntityType.usuario,
        operation: SyncOperation.update,
        data: updatedTable.toEntity().toJson(),
      );

      return Right(updatedTable.toEntity());
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to toggle usuario activo: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, Usuario>> updateUsuario(Usuario usuario) async {
    try {
      final usuarioTable = usuario.toTable();
      final updated = await usuarioDao.updateUsuario(usuarioTable);
      if (!updated) {
        return Left(CacheFailure(message: 'Usuario not found locally'));
      }

      await syncManager.queueChange(
        entityId: usuario.id,
        entityType: SyncEntityType.usuario,
        operation: SyncOperation.update,
        data: usuario.toJson(),
      );

      return Right(usuario);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to update usuario: $e'));
    }
  }
}
