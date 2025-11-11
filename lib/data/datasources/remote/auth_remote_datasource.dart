import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_datasource.dart';
import '../../../core/errors/exceptions.dart' as app_exceptions;
import '../../../core/utils/logger.dart';

/// Datasource remoto para operaciones de autenticación con Supabase
class AuthRemoteDataSource extends SupabaseDataSource {
  /// Inicia sesión con email y contraseña
  ///
  /// Returns: User autenticado y session
  /// Throws: AuthException si las credenciales son inválidas
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.auth('Iniciando sesión: $email');

      final response = await SupabaseDataSource.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw app_exceptions.AuthenticationException(
          message: 'Usuario o contraseña incorrectos',
        );
      }

      AppLogger.auth('✅ Sesión iniciada: ${response.user!.email}');
      return response;
    });
  }

  /// Registra un nuevo usuario
  ///
  /// Returns: User creado y session
  /// Throws: AuthException si el email ya existe
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String nombreCompleto,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.auth('Registrando usuario: $email');

      final response = await SupabaseDataSource.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'nombre_completo': nombreCompleto,
        },
      );

      if (response.user == null) {
        throw app_exceptions.AuthenticationException(
          message: 'Error al registrar usuario',
        );
      }

      AppLogger.auth('✅ Usuario registrado: ${response.user!.email}');
      return response;
    });
  }

  /// Cierra la sesión actual
  Future<void> logout() async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.auth('Cerrando sesión');

      await SupabaseDataSource.client.auth.signOut();

      AppLogger.auth('✅ Sesión cerrada');
    });
  }

  /// Refresca el token de autenticación
  ///
  /// Returns: Nueva session con token actualizado
  /// Throws: AuthException si el refresh token es inválido
  Future<AuthResponse> refreshToken() async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.auth('Refrescando token');

      final response = await SupabaseDataSource.client.auth.refreshSession();

      if (response.session == null) {
        throw app_exceptions.AuthenticationException(
          message: 'No se pudo refrescar el token',
        );
      }

      AppLogger.auth('✅ Token refrescado');
      return response;
    });
  }

  /// Envía un email para restablecer contraseña
  ///
  /// [email] - Email del usuario
  Future<void> resetPassword(String email) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.auth('Solicitando restablecimiento de contraseña: $email');

      await SupabaseDataSource.client.auth.resetPasswordForEmail(email);

      AppLogger.auth('✅ Email de restablecimiento enviado');
    });
  }

  /// Actualiza la contraseña del usuario actual
  ///
  /// [newPassword] - Nueva contraseña
  Future<User> updatePassword(String newPassword) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.auth('Actualizando contraseña');

      final response = await SupabaseDataSource.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      if (response.user == null) {
        throw app_exceptions.AuthenticationException(
          message: 'Error al actualizar contraseña',
        );
      }

      AppLogger.auth('✅ Contraseña actualizada');
      return response.user!;
    });
  }

  /// Obtiene el usuario actual
  ///
  /// Returns: Usuario autenticado o null si no hay sesión
  User? getCurrentUser() {
    final user = SupabaseDataSource.currentUser;
    if (user != null) {
      AppLogger.auth('Usuario actual: ${user.email}');
    }
    return user;
  }

  /// Obtiene la sesión actual
  ///
  /// Returns: Session activa o null
  Session? getCurrentSession() {
    final session = SupabaseDataSource.currentSession;
    if (session != null) {
      AppLogger.auth('Sesión activa hasta: ${session.expiresAt}');
    }
    return session;
  }

  /// Verifica si hay un usuario autenticado
  bool isAuthenticated() {
    return SupabaseDataSource.isAuthenticated;
  }

  /// Obtiene el perfil completo del usuario desde la tabla usuarios
  ///
  /// [userId] - ID del usuario (opcional, usa el usuario actual si no se proporciona)
  /// Returns: Map con los datos del usuario
  Future<Map<String, dynamic>> getUserProfile([String? userId]) async {
    return SupabaseDataSource.executeQuery(() async {
      final uid = userId ?? SupabaseDataSource.currentUserId;

      if (uid == null) {
        throw app_exceptions.AuthenticationException(
          message: 'No hay usuario autenticado',
        );
      }

      AppLogger.auth('Obteniendo perfil de usuario: $uid');

      try {
        // Primero intentar con joins
        final response = await SupabaseDataSource.client
            .from('usuarios')
            .select('''
              *,
              rol:roles(*),
              tienda:tiendas(*)
            ''')
            .eq('auth_user_id', uid)
            .single();

        AppLogger.auth('✅ Perfil obtenido: ${response['email']}');
        return response;
      } catch (e) {
        AppLogger.auth('⚠️ Error con joins, intentando sin ellos: $e');
        
        // Si falla, intentar sin los joins (solo datos básicos)
        final response = await SupabaseDataSource.client
            .from('usuarios')
            .select('*')
            .eq('auth_user_id', uid)
            .single();

        AppLogger.auth('✅ Perfil obtenido (sin joins): ${response['email']}');
        return response;
      }
    });
  }

  /// Actualiza el perfil del usuario en la tabla usuarios
  ///
  /// [data] - Datos a actualizar
  Future<Map<String, dynamic>> updateUserProfile(
    Map<String, dynamic> data,
  ) async {
    return SupabaseDataSource.executeQuery(() async {
      final uid = SupabaseDataSource.currentUserId;

      if (uid == null) {
        throw app_exceptions.AuthenticationException(
          message: 'No hay usuario autenticado',
        );
      }

      AppLogger.auth('Actualizando perfil de usuario: $uid');

      final response = await SupabaseDataSource.client
          .from('usuarios')
          .update(data)
          .eq('auth_user_id', uid)
          .select()
          .single();

      AppLogger.auth('✅ Perfil actualizado');
      return response;
    });
  }

  /// Verifica si el usuario tiene un rol específico
  ///
  /// [roleName] - Nombre del rol a verificar
  /// Returns: true si el usuario tiene el rol
  Future<bool> hasRole(String roleName) async {
    try {
      final profile = await getUserProfile();
      final rol = profile['rol'] as Map<String, dynamic>?;

      if (rol == null) return false;

      return rol['nombre'] == roleName;
    } catch (e) {
      AppLogger.error('Error al verificar rol', e);
      return false;
    }
  }

  /// Verifica si el usuario tiene un permiso específico
  ///
  /// [permission] - Nombre del permiso a verificar
  /// Returns: true si el usuario tiene el permiso
  Future<bool> hasPermission(String permission) async {
    try {
      final profile = await getUserProfile();
      final rol = profile['rol'] as Map<String, dynamic>?;

      if (rol == null) return false;

      final permisos = rol['permisos'] as Map<String, dynamic>?;
      if (permisos == null) return false;

      return permisos[permission] == true;
    } catch (e) {
      AppLogger.error('Error al verificar permiso', e);
      return false;
    }
  }

  /// Escucha cambios en el estado de autenticación
  ///
  /// [callback] - Función a ejecutar cuando cambia el estado
  /// Returns: Subscription que puede ser cancelada
  Stream<AuthState> onAuthStateChange() {
    AppLogger.auth('Escuchando cambios de autenticación');

    return SupabaseDataSource.client.auth.onAuthStateChange.map((event) {
      AppLogger.auth('Estado de autenticación cambió: ${event.event}');
      return event;
    });
  }

  /// Cambia la contraseña del usuario actual
  ///
  /// [currentPassword] - Contraseña actual (para verificación)
  /// [newPassword] - Nueva contraseña
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      final email = SupabaseDataSource.currentUserEmail;

      if (email == null) {
        throw app_exceptions.AuthenticationException(
          message: 'No hay usuario autenticado',
        );
      }

      AppLogger.auth('Cambiando contraseña');

      // Primero verificar que la contraseña actual es correcta
      try {
        await SupabaseDataSource.client.auth.signInWithPassword(
          email: email,
          password: currentPassword,
        );
      } catch (e) {
        throw app_exceptions.AuthenticationException(
          message: 'Contraseña actual incorrecta',
        );
      }

      // Actualizar con la nueva contraseña
      await updatePassword(newPassword);

      AppLogger.auth('✅ Contraseña cambiada');
    });
  }

  /// Reenvía el email de confirmación
  ///
  /// [email] - Email del usuario
  Future<void> resendConfirmationEmail(String email) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.auth('Reenviando email de confirmación: $email');

      await SupabaseDataSource.client.auth.resend(
        type: OtpType.signup,
        email: email,
      );

      AppLogger.auth('✅ Email de confirmación reenviado');
    });
  }

  /// Verifica si el email del usuario está confirmado
  ///
  /// Returns: true si el email está confirmado
  bool isEmailConfirmed() {
    final user = SupabaseDataSource.currentUser;
    if (user == null) return false;

    final emailConfirmedAt = user.emailConfirmedAt;
    return emailConfirmedAt != null;
  }

  /// Actualiza el email del usuario
  ///
  /// [newEmail] - Nuevo email
  Future<User> updateEmail(String newEmail) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.auth('Actualizando email a: $newEmail');

      final response = await SupabaseDataSource.client.auth.updateUser(
        UserAttributes(email: newEmail),
      );

      if (response.user == null) {
        throw app_exceptions.AuthenticationException(
          message: 'Error al actualizar email',
        );
      }

      AppLogger.auth('✅ Email actualizado (requiere confirmación)');
      return response.user!;
    });
  }
}
