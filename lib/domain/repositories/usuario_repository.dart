import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/usuario.dart';

/// Usuario repository interface
/// Defines the contract for user management operations
abstract class UsuarioRepository {
  /// Get all users
  Future<Either<Failure, List<Usuario>>> getUsuarios();

  /// Get user by ID
  Future<Either<Failure, Usuario>> getUsuarioById(String id);

  /// Get user by email
  Future<Either<Failure, Usuario>> getUsuarioByEmail(String email);

  /// Get users by store (tienda)
  Future<Either<Failure, List<Usuario>>> getUsuariosByTienda(String tiendaId);

  /// Get users by role
  Future<Either<Failure, List<Usuario>>> getUsuariosByRol(String rolId);

  /// Create a new user
  Future<Either<Failure, Usuario>> createUsuario(Usuario usuario);

  /// Update existing user
  Future<Either<Failure, Usuario>> updateUsuario(Usuario usuario);

  /// Delete user (soft delete)
  Future<Either<Failure, Unit>> deleteUsuario(String id);

  /// Activate/deactivate user
  Future<Either<Failure, Usuario>> toggleUsuarioActivo(String id);

  /// Search users by name or email
  Future<Either<Failure, List<Usuario>>> searchUsuarios(String query);

  /// Get active users only
  Future<Either<Failure, List<Usuario>>> getUsuariosActivos();
}
