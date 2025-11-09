// Clases de fallo para el manejo de errores
import 'package:equatable/equatable.dart';

/// Fallo base
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Fallo de servidor
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

/// Fallo de cache/base de datos local
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

/// Fallo de red
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}

/// Fallo de autenticación
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}

/// Fallo de validación
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});
}

/// Fallo de sincronización
class SyncFailure extends Failure {
  const SyncFailure(super.message, {super.code});
}

/// Fallo de conflicto
class ConflictFailure extends Failure {
  const ConflictFailure(super.message, {super.code});
}

/// Fallo de permisos
class PermissionFailure extends Failure {
  const PermissionFailure(super.message, {super.code});
}

/// Fallo de recurso no encontrado
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.code});
}

/// Fallo inesperado
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message, {super.code});
}
