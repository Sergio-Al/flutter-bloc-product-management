import 'package:equatable/equatable.dart';

/// Base class for all authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to request login with email and password
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Event to request user registration
class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String nombreCompleto;
  final String? telefono;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.nombreCompleto,
    this.telefono,
  });

  @override
  List<Object?> get props => [email, password, nombreCompleto, telefono];
}

/// Event to request logout
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Event to check if user is authenticated (app startup)
class AuthCheckStatusRequested extends AuthEvent {
  const AuthCheckStatusRequested();
}

/// Event to refresh authentication token
class AuthRefreshTokenRequested extends AuthEvent {
  const AuthRefreshTokenRequested();
}

/// Event to request password reset
class AuthPasswordResetRequested extends AuthEvent {
  final String email;

  const AuthPasswordResetRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Event to update password
class AuthPasswordUpdateRequested extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const AuthPasswordUpdateRequested({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}
