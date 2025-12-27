import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/usuario.dart';

/// Authentication repository interface
/// Defines the contract for authentication operations
abstract class AuthRepository {
  /// Login with email and password
  /// Returns authenticated user or failure
  Future<Either<Failure, Map<String, dynamic>>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, Map<String, dynamic>>> verifyMfaLogin({
    required String token,
  });

  /// Register a new user
  /// Returns created user or failure
  Future<Either<Failure, Usuario>> register({
    required String email,
    required String password,
    required String nombreCompleto,
    String? telefono,
  });

  /// Logout current user
  /// Returns unit (void) or failure
  Future<Either<Failure, Unit>> logout();

  /// Get current authenticated user
  /// Returns current user or failure
  Future<Either<Failure, Usuario>> getCurrentUser();

  /// Refresh authentication token
  /// Returns unit (void) or failure
  Future<Either<Failure, Unit>> refreshToken();

  /// Check if user is authenticated
  /// Returns true if authenticated
  Future<bool> isAuthenticated();

  /// Reset password via email
  /// Returns unit (void) or failure
  Future<Either<Failure, Unit>> resetPassword(String email);

  /// Update password
  /// Returns unit (void) or failure
  Future<Either<Failure, Unit>> updatePassword({
    required String currentPassword,
    required String newPassword,
  });
}
