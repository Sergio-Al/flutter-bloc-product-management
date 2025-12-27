import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/utils/logger.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/local/database/daos/rol_dao.dart';
import '../datasources/local/database/daos/tienda_dao.dart';
import '../datasources/local/database/daos/usuario_dao.dart';
import '../datasources/local/database/app_database.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/usuario_model.dart';

/// Implementation of AuthRepository
/// Follows offline-first pattern with local caching
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDatasource;
  final AuthLocalDatasource localDatasource;
  final NetworkInfo networkInfo;
  final UsuarioDao usuarioDao;
  final RolDao rolDao;
  final TiendaDao tiendaDao;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
    required this.usuarioDao,
    required this.rolDao,
    required this.tiendaDao,
  });

  @override
  Future<Either<Failure, Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    // Check network connectivity
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      // Authenticate with NestJS backend
      final response = await remoteDatasource.login(
        email: email,
        password: password,
      );

      print('requires mfa $response');

      // Check if MFA is required
      if (response['requires_mfa'] == true) {
        AppLogger.info('MFA required for user: $email');
        // Return response with requires_mfa and temp_token
        return Right(response);
      }

      // Login successful without MFA
      final accessToken = response['access_token'] as String;
      final refreshToken = response['refresh_token'] as String?;
      
      // Store access token
      await localDatasource.cacheToken(accessToken);
      remoteDatasource.setAccessToken(accessToken);
      
      // Store refresh token if available
      if (refreshToken != null) {
        await localDatasource.cacheRefreshToken(refreshToken);
        remoteDatasource.setRefreshToken(refreshToken);
      }
      
      // Fetch complete user profile
      // final userProfile = await remoteDatasource.getUserProfile();
      final userProfile = response['user'] as Map<String, dynamic>;
      final usuarioModel = UsuarioModel.fromJson(userProfile);

      AppLogger.info('User logged in: ${usuarioModel.id}');

      // Cache user data locally (SharedPreferences)
      await localDatasource.cacheUser(usuarioModel);

      // Also sync user to local database to prevent foreign key errors
      await _syncUserToDatabase(usuarioModel);

      // Return response with user data
      return Right({
        'user': userProfile,
        'access_token': accessToken,
      });
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
      // Register with NestJS backend
      // Note: NestJS backend requires tiendaId and rolId
      // You'll need to add these parameters to the register method signature
      // For now, using default/placeholder values
      final response = await remoteDatasource.register(
        email: email,
        password: password,
        nombreCompleto: nombreCompleto,
        telefono: telefono ?? '',
        tiendaId: '2a1b9c90-9d42-46d3-8dc7-b347ba306c5b', // TODO: Pass actual tiendaId from UI
        rolId: '2763e85c-5013-44dd-93ca-3154243fe738', // TODO: Pass actual rolId from UI
      );

      // Wait a moment for backend processing
      // await Future.delayed(const Duration(milliseconds: 500));

      AppLogger.info('User registered: ${response}');
      
      // Extract user data and token from response
      final userProfile = response['user'] as Map<String, dynamic>;
      final accessToken = response['access_token'] as String;
      final refreshToken = response['refresh_token'] as String?;
      final usuarioModel = UsuarioModel.fromJson(userProfile);

      AppLogger.info('User registered and logged in: ${usuarioModel.id}');

      // Cache user data locally (SharedPreferences)
      await localDatasource.cacheUser(usuarioModel);

      AppLogger.info('Cached user locally: ${usuarioModel.id}');
      
      // Store access token
      await localDatasource.cacheToken(accessToken);
      remoteDatasource.setAccessToken(accessToken);
      
      AppLogger.info('Stored access token for user: ${usuarioModel.id}');
      // Store refresh token if available
      if (refreshToken != null) {
        await localDatasource.cacheRefreshToken(refreshToken);
        remoteDatasource.setRefreshToken(refreshToken);
      }
      
      AppLogger.info('Stored refresh token for user: ${usuarioModel.id}');
      // Also sync user to local database
      await _syncUserToDatabase(usuarioModel);
      
      return Right(usuarioModel.toEntity());
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on ValidationException catch (e) {
      // Password policy violation or other validation errors
      return Left(ValidationFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('Error en register', e);
      return Left(
        ServerFailure(message: 'Unexpected error during registration: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      // Try to logout from server if online (invalidates refresh token)
      if (await networkInfo.isConnected) {
        try {
          await remoteDatasource.logout();
        } catch (e) {
          // Even if server logout fails, we still clear local cache
          AppLogger.warning('Server logout failed, clearing local cache anyway: $e');
        }
      }

      // Clear all local auth data
      await localDatasource.clearAllAuthData();

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
      // Restore tokens from cache if available
      final cachedToken = await localDatasource.getCachedToken();
      if (cachedToken != null) {
        remoteDatasource.setAccessToken(cachedToken);
      }
      
      final cachedRefreshToken = await localDatasource.getCachedRefreshToken();
      if (cachedRefreshToken != null) {
        remoteDatasource.setRefreshToken(cachedRefreshToken);
      }
      
      // Try to get from cache first (offline-first)
      if (await localDatasource.hasCachedUser()) {
        final cachedUser = await localDatasource.getCachedUser();
        
        // Ensure user exists in local database (in case it was cleared)
        await _syncUserToDatabase(cachedUser);
        
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
      
      // Sync to local database
      await _syncUserToDatabase(usuarioModel);

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
        
        // Sync to local database
        await _syncUserToDatabase(usuarioModel);
        
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
      // Restore refresh token from cache if not in memory
      final cachedRefreshToken = await localDatasource.getCachedRefreshToken();
      if (cachedRefreshToken != null) {
        remoteDatasource.setRefreshToken(cachedRefreshToken);
      }
      
      // Call refresh endpoint
      final response = await remoteDatasource.refreshAccessToken();
      
      // Store new tokens
      final newAccessToken = response['access_token'] as String;
      final newRefreshToken = response['refresh_token'] as String?;
      
      await localDatasource.cacheToken(newAccessToken);
      remoteDatasource.setAccessToken(newAccessToken);
      
      if (newRefreshToken != null) {
        await localDatasource.cacheRefreshToken(newRefreshToken);
        remoteDatasource.setRefreshToken(newRefreshToken);
      }
      
      AppLogger.info('Token refreshed successfully');
      return const Right(unit);
    } on AuthenticationException catch (e) {
      // Refresh token expired - clear all auth data
      await localDatasource.clearAllAuthData();
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
        return remoteDatasource.isAuthenticated();
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
      // TODO: Implement password reset endpoint in NestJS backend
      // For now, return a not implemented failure
      return Left(
        ServerFailure(message: 'Password reset not implemented in backend yet'),
      );
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
      // TODO: Implement password update endpoint in NestJS backend
      // For now, return a not implemented failure
      return Left(
        ServerFailure(message: 'Password update not implemented in backend yet'),
      );
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

  /// Sync authenticated user to local database to prevent foreign key errors
  /// This ensures the user record exists in the local usuarios table
  /// First ensures that the role and tienda (if applicable) exist in local DB
  Future<void> _syncUserToDatabase(UsuarioModel user) async {
    try {
      // First, ensure the role exists in local database (FK constraint)
      if (user.rolId.isNotEmpty) {
        final existingRole = await rolDao.getRolById(user.rolId);
        if (existingRole == null) {
          // Create a placeholder role record with the rolNombre from the user
          final roleName = user.rolNombre ?? 'Unknown';
          await rolDao.insertOrUpdateRol(RolTable(
            id: user.rolId,
            nombre: roleName,
            permisos: '[]', // Will be updated on next full sync
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ));
          AppLogger.info('Created placeholder role: ${user.rolId} ($roleName)');
        }
      }

      // Ensure the tienda exists if user has one (FK constraint)
      if (user.tiendaId != null && user.tiendaId!.isNotEmpty) {
        final existingTienda = await tiendaDao.getTiendaById(user.tiendaId!);
        if (existingTienda == null) {
          // Create a placeholder tienda record
          final tiendaName = user.tiendaNombre ?? 'Unknown Store';
          await tiendaDao.insertTienda(TiendaTable(
            id: user.tiendaId!,
            nombre: tiendaName,
            codigo: 'PLACEHOLDER-${user.tiendaId!.substring(0, 8)}',
            direccion: '',
            ciudad: '',
            departamento: '',
            activo: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ));
          AppLogger.info('Created placeholder tienda: ${user.tiendaId} ($tiendaName)');
        }
      }

      // Now safe to insert/update the user
      await usuarioDao.upsertUsuario(user.toTable());
      AppLogger.info('User synced to local database: ${user.id}');
    } catch (e) {
      AppLogger.error(
        'Failed to sync user to database',
        'User: ${user.id}, Error: $e',
      );
      // Don't throw - this is a non-critical operation
      // The user is still cached in SharedPreferences
    }
  }
  
  @override
  Future<Either<Failure, Map<String, dynamic>>> verifyMfaLogin({
    required String token,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      AppLogger.info('Verifying MFA login with token: $token');
      final response = await remoteDatasource.verifyMfaLogin(token: token);

      AppLogger.info('MFA verified, processing login response $response');
      final accessToken = response['access_token'] as String;
      final refreshToken = response['refresh_token'] as String?;
      
      // Store access token
      await localDatasource.cacheToken(accessToken);
      remoteDatasource.setAccessToken(accessToken);
      
      // Store refresh token if available
      if (refreshToken != null) {
        await localDatasource.cacheRefreshToken(refreshToken);
        remoteDatasource.setRefreshToken(refreshToken);
      }
      
      // Fetch complete user profile
      // final userProfile = await remoteDatasource.getUserProfile();
      final userProfile = response['user'] as Map<String, dynamic>;
      final usuarioModel = UsuarioModel.fromJson(userProfile);

      AppLogger.info('User logged in with MFA: ${usuarioModel.id}');

      // Cache user data locally
      await localDatasource.cacheUser(usuarioModel);

      // Sync to local database
      await _syncUserToDatabase(usuarioModel);

      // Return response with user data
      return Right({
        'user': userProfile,
        'access_token': accessToken,
      });
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Unexpected error verifying MFA: $e'),
      );
    }
  }
}
