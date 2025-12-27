import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/errors/exceptions.dart' as app_exceptions;
import '../../../core/utils/logger.dart';
import '../../../core/config/env_config.dart';

/// Datasource remoto para operaciones de autenticación con NestJS backend
class AuthRemoteDataSource {
  static String? _accessToken;
  static String? _refreshToken;
  static String? _tempToken;
  
  /// Base URL del API (configurable desde .env)
  static String get baseUrl => EnvConfig.apiUrl;
  
  /// Obtiene el refresh token actual
  String? getRefreshToken() => _refreshToken;
  
  /// Establece el refresh token
  void setRefreshToken(String? token) => _refreshToken = token;
  
  /// Headers comunes para todas las peticiones
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };

  /// Inicia sesión con email y contraseña
  ///
  /// Returns: Map con access_token, user, y opcionalmente requires_mfa
  /// Throws: AuthenticationException si las credenciales son inválidas
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.auth('Iniciando sesión: $email');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        
        // Si requiere MFA, guardar token temporal
        if (data['requires_mfa'] == true) {
          _tempToken = data['temp_token'] as String?;
          AppLogger.auth('⚠️ MFA requerido para: $email');
        } else {
          // Login exitoso sin MFA - guardar ambos tokens
          _accessToken = data['access_token'] as String?;
          _refreshToken = data['refresh_token'] as String?;
          AppLogger.auth('✅ Sesión iniciada: $email');
        }
        
        return data;
      } else if (response.statusCode == 401) {
        // Verificar si la cuenta está bloqueada
        final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        final message = errorBody['message'] as String? ?? 'Usuario o contraseña incorrectos';
        
        // El backend puede enviar información sobre bloqueo de cuenta
        if (message.contains('bloqueada') || message.contains('locked')) {
          throw app_exceptions.AuthenticationException(
            message: message,
          );
        }
        
        throw app_exceptions.AuthenticationException(
          message: message,
        );
      } else if (response.statusCode == 429) {
        // Rate limiting - demasiados intentos
        throw app_exceptions.AuthenticationException(
          message: 'Demasiados intentos. Por favor espere un momento antes de intentar nuevamente.',
        );
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al iniciar sesión: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.AuthenticationException) rethrow;
      AppLogger.error('Error en login', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Verifica código MFA durante el login
  ///
  /// Returns: Map con access_token y user
  /// Throws: AuthenticationException si el código es inválido
  Future<Map<String, dynamic>> verifyMfaLogin({
    required String token,
  }) async {
    try {
      if (_tempToken == null) {
        throw app_exceptions.AuthenticationException(
          message: 'No hay sesión MFA pendiente',
        );
      }

      AppLogger.auth('Verificando código MFA');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/mfa/verify'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'temp_token': _tempToken,
          'token': token,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _accessToken = data['access_token'] as String?;
        _tempToken = null; // Limpiar token temporal
        AppLogger.auth('✅ MFA verificado correctamente');
        return data;
      } else if (response.statusCode == 401) {
        throw app_exceptions.AuthenticationException(
          message: 'Código MFA inválido o expirado',
        );
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al verificar MFA: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.AuthenticationException) rethrow;
      AppLogger.error('Error en verifyMfaLogin', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Registra un nuevo usuario
  ///
  /// Returns: Map con user y access_token
  /// Throws: AuthenticationException si el email ya existe
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String nombreCompleto,
    required String telefono,
    required String tiendaId,
    required String rolId,
  }) async {
    try {
      AppLogger.auth('Registrando usuario: $email');

      print('json to send: ' + jsonEncode({
          'email': email,
          'password': password,
          'nombre_completo': nombreCompleto,
          'telefono': telefono,
          'tiendaId': tiendaId,
          'rolId': rolId,
        }));
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'nombre_completo': nombreCompleto,
          'telefono': telefono,
          'tiendaId': tiendaId,
          'rolId': rolId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _accessToken = data['access_token'] as String?;
        _refreshToken = data['refresh_token'] as String?;
        AppLogger.auth('✅ Usuario registrado: $email');
        return data;
      } else if (response.statusCode == 409) {
        throw app_exceptions.AuthenticationException(
          message: 'El email ya está registrado',
        );
      } else if (response.statusCode == 400) {
        // Validación fallida (contraseña débil, etc.)
        final errorBody = jsonDecode(response.body);
        final message = errorBody['message'];
        // Si es una lista de errores, unirlos
        if (message is List) {
          throw app_exceptions.ValidationException(
            message: message.join('. '),
          );
        }
        throw app_exceptions.ValidationException(
          message: message?.toString() ?? 'Error de validación',
        );
      } else {
        final errorBody = jsonDecode(response.body);
        throw app_exceptions.ServerException(
          message: errorBody['message'] ?? 'Error al registrar usuario',
        );
      }
    } catch (e) {
      AppLogger.error('Error en register', e);
      if (e is app_exceptions.AuthenticationException || 
          e is app_exceptions.ValidationException ||
          e is app_exceptions.ServerException) rethrow;
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Cierra la sesión actual (notifica al backend)
  Future<void> logout() async {
    try {
      AppLogger.auth('Cerrando sesión');
      
      // Notificar al backend para invalidar refresh token
      if (_accessToken != null) {
        try {
          await http.post(
            Uri.parse('$baseUrl/auth/logout'),
            headers: _headers,
          );
        } catch (_) {
          // Ignorar errores de red en logout
        }
      }
      
      _accessToken = null;
      _refreshToken = null;
      _tempToken = null;
      AppLogger.auth('✅ Sesión cerrada');
    } catch (e) {
      AppLogger.error('Error en logout', e);
    }
  }

  /// Verifica si hay un usuario autenticado
  bool isAuthenticated() {
    print('app access token: ' + (_accessToken ?? 'null'));
    return _accessToken != null && _accessToken!.isNotEmpty;
  }

  /// Obtiene el token de acceso actual
  String? getAccessToken() {
    return _accessToken;
  }

  /// Establece el token de acceso (útil para restaurar sesión)
  void setAccessToken(String? token) {
    _accessToken = token;
  }

  /// Obtiene el perfil completo del usuario
  ///
  /// Returns: Map con los datos del usuario
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      if (!isAuthenticated()) {
        throw app_exceptions.AuthenticationException(
          message: 'No hay usuario autenticado',
        );
      }

      // AppLogger.auth('Obteniendo perfil de usuario');

      final response = await http.get(
        Uri.parse('$baseUrl/auth/profile'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.auth('✅ Perfil obtenido: ${data}');
        return data;
      } else if (response.statusCode == 401) {
        _accessToken = null;
        throw app_exceptions.AuthenticationException(
          message: 'Sesión expirada',
        );
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener perfil: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.AuthenticationException) rethrow;
      AppLogger.error('Error en getUserProfile', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene roles disponibles
  Future<List<Map<String, dynamic>>> getRoles() async {
    try {
      AppLogger.auth('Obteniendo roles disponibles');

      final response = await http.get(
        Uri.parse('$baseUrl/auth/roles'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        AppLogger.auth('✅ Roles obtenidos: ${data.length}');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener roles: ${response.statusCode}',
        );
      }
    } catch (e) {
      AppLogger.error('Error en getRoles', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene tiendas disponibles
  Future<List<Map<String, dynamic>>> getTiendas() async {
    try {
      AppLogger.auth('Obteniendo tiendas disponibles');

      final response = await http.get(
        Uri.parse('$baseUrl/auth/tiendas'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        AppLogger.auth('✅ Tiendas obtenidas: ${data.length}');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener tiendas: ${response.statusCode}',
        );
      }
    } catch (e) {
      AppLogger.error('Error en getTiendas', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  // ============================================
  // MFA (Multi-Factor Authentication) Methods
  // ============================================

  /// Habilita MFA para el usuario actual
  ///
  /// Returns: Map con secret y qrCode (imagen base64)
  Future<Map<String, dynamic>> enableMfa() async {
    try {
      if (!isAuthenticated()) {
        throw app_exceptions.AuthenticationException(
          message: 'No hay usuario autenticado',
        );
      }

      AppLogger.auth('Habilitando MFA');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/mfa/enable'),
        headers: _headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.auth('✅ MFA habilitado - QR generado');
        return data;
      } else if (response.statusCode == 401) {
        _accessToken = null;
        throw app_exceptions.AuthenticationException(
          message: 'Sesión expirada',
        );
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al habilitar MFA: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.AuthenticationException) rethrow;
      AppLogger.error('Error en enableMfa', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Verifica el código MFA para confirmar la habilitación
  ///
  /// [token] - Código de 6 dígitos del autenticador
  Future<void> verifyMfaSetup({required String token}) async {
    try {
      if (!isAuthenticated()) {
        throw app_exceptions.AuthenticationException(
          message: 'No hay usuario autenticado',
        );
      }

      AppLogger.auth('Verificando setup MFA');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/mfa/enable/verify'),
        headers: _headers,
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.auth('✅ MFA verificado y activado');
      } else if (response.statusCode == 401 || response.statusCode == 400) {
        throw app_exceptions.AuthenticationException(
          message: 'Código MFA inválido',
        );
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al verificar MFA: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.AuthenticationException) rethrow;
      AppLogger.error('Error en verifyMfaSetup', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Deshabilita MFA para el usuario actual
  Future<void> disableMfa() async {
    try {
      if (!isAuthenticated()) {
        throw app_exceptions.AuthenticationException(
          message: 'No hay usuario autenticado',
        );
      }

      AppLogger.auth('Deshabilitando MFA');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/mfa/disable'),
        headers: _headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.auth('✅ MFA deshabilitado');
      } else if (response.statusCode == 401) {
        _accessToken = null;
        throw app_exceptions.AuthenticationException(
          message: 'Sesión expirada',
        );
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al deshabilitar MFA: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.AuthenticationException) rethrow;
      AppLogger.error('Error en disableMfa', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  // ============================================
  // Token Management & Session Methods
  // ============================================

  /// Renueva el access token usando el refresh token
  ///
  /// Returns: Map con nuevos access_token, refresh_token y user
  /// Throws: AuthenticationException si el refresh token es inválido
  Future<Map<String, dynamic>> refreshAccessToken() async {
    try {
      if (_refreshToken == null) {
        throw app_exceptions.AuthenticationException(
          message: 'No hay refresh token disponible',
        );
      }

      AppLogger.auth('Renovando access token');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'refresh_token': _refreshToken,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _accessToken = data['access_token'] as String?;
        _refreshToken = data['refresh_token'] as String?;
        AppLogger.auth('✅ Token renovado exitosamente');
        return data;
      } else if (response.statusCode == 401) {
        // Refresh token expirado o inválido
        _accessToken = null;
        _refreshToken = null;
        throw app_exceptions.AuthenticationException(
          message: 'Sesión expirada. Por favor inicie sesión nuevamente.',
        );
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al renovar token: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.AuthenticationException) rethrow;
      AppLogger.error('Error en refreshAccessToken', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Revoca todas las sesiones del usuario
  ///
  /// Útil cuando el usuario sospecha de acceso no autorizado
  Future<void> revokeAllSessions() async {
    try {
      if (!isAuthenticated()) {
        throw app_exceptions.AuthenticationException(
          message: 'No hay usuario autenticado',
        );
      }

      AppLogger.auth('Revocando todas las sesiones');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/revoke-all'),
        headers: _headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Limpiar tokens locales también
        _accessToken = null;
        _refreshToken = null;
        _tempToken = null;
        AppLogger.auth('✅ Todas las sesiones revocadas');
      } else if (response.statusCode == 401) {
        _accessToken = null;
        throw app_exceptions.AuthenticationException(
          message: 'Sesión expirada',
        );
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al revocar sesiones: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.AuthenticationException) rethrow;
      AppLogger.error('Error en revokeAllSessions', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }
}
