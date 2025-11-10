import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_management_system/domain/usecases/auth/auth_usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Authentication BLoC
/// Manages authentication state and handles authentication events
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // final AuthRepository authRepository;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final RefreshTokenUsecase refreshTokenUsecase;
  final RegisterUsecase registerUsecase;
  final IsAuthenticatedUsecase isAuthenticatedUsecase;
  final GetCurrentUserUsecase getCurrentUserUsecase;
  final UpdatePasswordUsecase updatePasswordUsecase;
  final ResetPasswordUsecase resetPasswordUsecase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.refreshTokenUsecase,
    required this.registerUsecase,
    required this.isAuthenticatedUsecase,
    required this.getCurrentUserUsecase,
    required this.updatePasswordUsecase,
    required this.resetPasswordUsecase,
  }) : super(const AuthInitial()) {
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

    final result = await loginUseCase(
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

    final result = await registerUsecase(
      email: event.email,
      password: event.password,
      nombreCompleto: event.nombreCompleto,
      telefono: event.telefono ?? '',
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

    final result = await logoutUseCase();

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) =>
          emit(const AuthUnauthenticated(message: 'Logged out successfully')),
    );
  }

  /// Handle authentication status check (app startup)
  Future<void> _onCheckStatusRequested(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final isAuthenticated = await isAuthenticatedUsecase();

    if (!isAuthenticated) {
      emit(const AuthUnauthenticated());
      return;
    }

    // If authenticated, get current user
    final result = await getCurrentUserUsecase();
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
    final result = await refreshTokenUsecase();

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

    final result = await resetPasswordUsecase(email: event.email);

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

    final result = await updatePasswordUsecase(
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
    );

    result.fold((failure) => emit(AuthError(message: failure.message)), (_) {
      emit(const AuthPasswordUpdated());
      // Return to authenticated state
      if (state is AuthAuthenticated) {
        emit(state);
      }
    });
  }
}
