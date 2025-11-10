import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Authentication BLoC
/// Manages authentication state and handles authentication events
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(const AuthInitial()) {
    // Register event handlers
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckStatusRequested>(_onCheckStatusRequested);
    on<AuthRefreshTokenRequested>(_onRefreshTokenRequested);
    on<AuthPasswordResetRequested>(_onPasswordResetRequested);
    on<AuthPasswordUpdateRequested>(_onPasswordUpdateRequested);
  }

  /// Handle login request
  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.login(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  /// Handle registration request
  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.register(
      email: event.email,
      password: event.password,
      nombreCompleto: event.nombreCompleto,
      telefono: event.telefono,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  /// Handle logout request
  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.logout();

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const AuthUnauthenticated(message: 'Logged out successfully')),
    );
  }

  /// Handle authentication status check (app startup)
  Future<void> _onCheckStatusRequested(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final isAuthenticated = await authRepository.isAuthenticated();

    if (!isAuthenticated) {
      emit(const AuthUnauthenticated());
      return;
    }

    // If authenticated, get current user
    final result = await authRepository.getCurrentUser();

    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  /// Handle token refresh request
  Future<void> _onRefreshTokenRequested(
    AuthRefreshTokenRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Don't show loading for token refresh (background operation)
    final result = await authRepository.refreshToken();

    result.fold(
      (failure) {
        // If token refresh fails, user needs to login again
        emit(AuthError(message: 'Session expired. Please login again.'));
        emit(const AuthUnauthenticated());
      },
      (_) {
        // Token refreshed successfully, maintain current state
        // Optionally emit a success state
        if (state is AuthAuthenticated) {
          emit(const AuthTokenRefreshed());
          emit(state); // Return to previous authenticated state
        }
      },
    );
  }

  /// Handle password reset request
  Future<void> _onPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.resetPassword(event.email);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(AuthPasswordResetSent(email: event.email)),
    );
  }

  /// Handle password update request
  Future<void> _onPasswordUpdateRequested(
    AuthPasswordUpdateRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.updatePassword(
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) {
        emit(const AuthPasswordUpdated());
        // Return to authenticated state
        if (state is AuthAuthenticated) {
          emit(state);
        }
      },
    );
  }
}
