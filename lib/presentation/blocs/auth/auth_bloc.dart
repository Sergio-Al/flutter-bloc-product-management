import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_management_system/domain/usecases/auth/auth_usecases.dart';
import '../../../domain/entities/usuario.dart';
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
  final VerifyMfaLoginUseCase verifyMfaLoginUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.refreshTokenUsecase,
    required this.registerUsecase,
    required this.isAuthenticatedUsecase,
    required this.getCurrentUserUsecase,
    required this.updatePasswordUsecase,
    required this.resetPasswordUsecase,
    required this.verifyMfaLoginUseCase,
  }) : super(const AuthInitial()) {
    // Register event handlers
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthMfaCodeSubmitted>(_onMfaCodeSubmitted);
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

    result.fold((failure) => emit(AuthError(message: failure.message)), (
      response,
    ) {
      // Check if MFA is required
      if (response['requires_mfa'] == true) {
        emit(AuthMfaRequired(tempToken: response['temp_token'] as String));
      } else {
        // Login successful - convert user data to Usuario entity
        final userData = response['user'] as Map<String, dynamic>;
        final usuario = _mapToUsuario(userData);
        emit(AuthAuthenticated(user: usuario));
      }
    });
  }

  /// Handle MFA code verification
  Future<void> _onMfaCodeSubmitted(
    AuthMfaCodeSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await verifyMfaLoginUseCase(token: event.code);

    result.fold((failure) => emit(AuthError(message: failure.message)), (
      response,
    ) {
      // MFA verification successful - convert user data to Usuario entity
      final userData = response['user'] as Map<String, dynamic>;
      final usuario = _mapToUsuario(userData);
      emit(AuthAuthenticated(user: usuario));
    });
  }

  /// Helper to map API response to Usuario entity
  Usuario _mapToUsuario(Map<String, dynamic> userData) {
    // Extract tienda info (can be nested object or just ID)
    String? tiendaId;
    String? tiendaNombre;
    final tienda = userData['tienda'];
    if (tienda is Map<String, dynamic>) {
      tiendaId = tienda['id'] as String?;
      tiendaNombre = tienda['nombre'] as String?;
    } else {
      tiendaId =
          userData['tienda_id'] as String? ?? userData['tiendaId'] as String?;
    }

    // Extract rol info (can be nested object or just ID)
    String? rolId;
    String? rolNombre;
    final rol = userData['rol'];
    if (rol is Map<String, dynamic>) {
      rolId = rol['id'] as String?;
      rolNombre = rol['nombre'] as String?;
    } else {
      rolId = userData['rol_id'] as String? ?? userData['rolId'] as String?;
    }

    return Usuario(
      id: userData['id'] ?? '',
      authUserId: userData['id'] ?? '',
      email: userData['email'] ?? '',
      nombreCompleto:
          userData['nombre_completo'] ?? userData['nombreCompleto'] ?? '',
      telefono: userData['telefono'] ?? '',
      tiendaId: tiendaId,
      tiendaNombre: tiendaNombre,
      rolId: rolId,
      rolNombre: rolNombre,
      activo: userData['activo'] ?? true,
      mfaEnabled: userData['mfa_enabled'] ?? userData['mfaEnabled'] ?? false,
      createdAt:
          DateTime.tryParse(
            userData['created_at'] ?? userData['createdAt'] ?? '',
          ) ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(
            userData['updated_at'] ?? userData['updatedAt'] ?? '',
          ) ??
          DateTime.now(),
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
