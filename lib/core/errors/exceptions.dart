class ServerException implements Exception {
  final String message;
  final String? code;

  ServerException({required this.message, this.code});

  @override
  String toString() => 'ServerException: $message (code: $code)';
}

class CacheException implements Exception {
  final String message;

  CacheException({required this.message});

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;

  NetworkException({required this.message});

  @override
  String toString() => 'NetworkException: $message';
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException({required this.message});

  @override
  String toString() => 'AuthenticationException: $message';
}

/// Exception for input validation errors (e.g., weak password, invalid format)
class ValidationException implements Exception {
  final String message;
  final List<String>? errors;

  ValidationException({required this.message, this.errors});

  @override
  String toString() => 'ValidationException: $message';
}

/// Exception for rate limiting (too many requests)
class RateLimitException implements Exception {
  final String message;
  final int? retryAfterSeconds;

  RateLimitException({required this.message, this.retryAfterSeconds});

  @override
  String toString() => 'RateLimitException: $message';
}

/// Exception for account lockout
class AccountLockedException implements Exception {
  final String message;
  final DateTime? lockedUntil;

  AccountLockedException({required this.message, this.lockedUntil});

  @override
  String toString() => 'AccountLockedException: $message';
}
