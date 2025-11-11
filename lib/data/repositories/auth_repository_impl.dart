import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/usuario_model.dart';

/// Implementation of AuthRepository
/// Follows offline-first pattern with local caching
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDatasource;
  final AuthLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Usuario>> login({
    required String email,
    required String password,
  }) async {
    // Check network connectivity
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      // Authenticate with Supabase
      await remoteDatasource.login(email: email, password: password);

      // Fetch user data from usuarios table
      final userProfile = await remoteDatasource.getUserProfile();
      final usuarioModel = UsuarioModel.fromJson(userProfile);

      // Cache user data locally
      await localDatasource.cacheUser(usuarioModel);

      // Convert model to entity
      return Right(usuarioModel.toEntity());
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error during login: $e'));
    }
  }

  @override
  Future<Either<Failure, Usuario>> register({
    required String email,
    required String password,
    required String nombreCompleto,
    String? telefono,
  }) async {
    // Registration requires network
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      // Register with Supabase Auth
      final authResponse = await remoteDatasource.register(
        email: email,
        password: password,
        nombreCompleto: nombreCompleto,
      );

      // Esperar un momento para que el trigger se ejecute
      await Future.delayed(const Duration(milliseconds: 500));

      // Obtener el perfil completo de la base de datos
      final userProfile = await remoteDatasource.getUserProfile();
      final usuarioModel = UsuarioModel.fromJson(userProfile);

      await localDatasource.cacheUser(usuarioModel);
      return Right(usuarioModel.toEntity());
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Unexpected error during registration: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      // Clear local cache first (always succeeds)
      await localDatasource.clearCache();

      // Try to logout from server if online
      if (await networkInfo.isConnected) {
        try {
          await remoteDatasource.logout();
        } catch (e) {
          // Even if server logout fails, we already cleared local cache
          // So we can still return success
        }
      }

      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error during logout: $e'));
    }
  }

  @override
  Future<Either<Failure, Usuario>> getCurrentUser() async {
    try {
      // Try to get from cache first (offline-first)
      if (await localDatasource.hasCachedUser()) {
        final cachedUser = await localDatasource.getCachedUser();
        return Right(cachedUser.toEntity());
      }

      // If not cached, fetch from server (requires network)
      if (!await networkInfo.isConnected) {
        return Left(
          NetworkFailure(message: 'No cached user and no internet connection'),
        );
      }

      final userProfile = await remoteDatasource.getUserProfile();
      final usuarioModel = UsuarioModel.fromJson(userProfile);

      // Cache for next time
      await localDatasource.cacheUser(usuarioModel);

      return Right(usuarioModel.toEntity());
    } on CacheException {
      // No cached user, try from server
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'No internet connection'));
      }

      try {
        final userProfile = await remoteDatasource.getUserProfile();
        final usuarioModel = UsuarioModel.fromJson(userProfile);
        await localDatasource.cacheUser(usuarioModel);
        return Right(usuarioModel.toEntity());
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Unexpected error getting current user: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> refreshToken() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      await remoteDatasource.refreshToken();
      return const Right(unit);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Unexpected error refreshing token: $e'),
      );
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      // Check if we have a cached user first (fast, offline)
      if (await localDatasource.hasCachedUser()) {
        return true;
      }

      // If online, check with server
      if (await networkInfo.isConnected) {
        return await remoteDatasource.isAuthenticated();
      }

      // Offline and no cache = not authenticated
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword(String email) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      await remoteDatasource.resetPassword(email);
      return const Right(unit);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Unexpected error resetting password: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      await remoteDatasource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(unit);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Unexpected error updating password: $e'),
      );
    }
  }
}
