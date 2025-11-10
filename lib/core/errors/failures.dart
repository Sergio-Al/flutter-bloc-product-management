import 'package:equatable/equatable.dart';
import '../sync/sync_status.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class SyncFailure extends Failure {
  const SyncFailure({required super.message});
}

class ConflictFailure extends Failure {
  final SyncConflict conflict;

  const ConflictFailure({
    required super.message,
    required this.conflict,
  });

  @override
  List<Object?> get props => [message, conflict];
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({required super.message});
}

class PermissionFailure extends Failure {
  const PermissionFailure({required super.message});
}
