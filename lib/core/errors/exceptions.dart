// Excepciones personalizadas de la aplicación

/// Excepción base
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Excepción de servidor
class ServerException extends AppException {
  ServerException(super.message, {super.code, super.details});
}

/// Excepción de cache/base de datos local
class CacheException extends AppException {
  CacheException(super.message, {super.code, super.details});
}

/// Excepción de red
class NetworkException extends AppException {
  NetworkException(super.message, {super.code, super.details});
}

/// Excepción de autenticación
class AuthException extends AppException {
  AuthException(super.message, {super.code, super.details});
}

/// Excepción de validación
class ValidationException extends AppException {
  ValidationException(super.message, {super.code, super.details});
}

/// Excepción de sincronización
class SyncException extends AppException {
  SyncException(super.message, {super.code, super.details});
}

/// Excepción de conflicto de sincronización
class ConflictException extends AppException {
  ConflictException(super.message, {super.code, super.details});
}

/// Excepción de permisos
class PermissionException extends AppException {
  PermissionException(super.message, {super.code, super.details});
}

/// Excepción de recurso no encontrado
class NotFoundException extends AppException {
  NotFoundException(super.message, {super.code, super.details});
}
