import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/env_config.dart';
import '../../../core/errors/exceptions.dart' as app_exceptions;
import '../../../core/utils/logger.dart';
import 'auth_remote_datasource.dart';

/// Datasource remoto para operaciones de tiendas con NestJS backend
class TiendaRemoteDataSource {
  /// Base URL del API (configurable desde .env)
  static String get baseUrl => EnvConfig.apiUrl;

  final AuthRemoteDataSource? _authDataSource;

  /// Constructor with optional authDataSource for public endpoints (like initial seeding)
  TiendaRemoteDataSource({AuthRemoteDataSource? authDataSource})
    : _authDataSource = authDataSource;

  /// Headers with authorization token (if available)
  Map<String, String> get _headers {
    final token = _authDataSource?.getAccessToken();
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Obtiene todas las tiendas
  Future<List<Map<String, dynamic>>> getTiendas({
    DateTime? lastSync,
    bool? soloActivas,
  }) async {
    try {
      AppLogger.database('Obteniendo tiendas desde NestJS');

      final uri = soloActivas == true
          ? Uri.parse('$baseUrl/tiendas/activas')
          : Uri.parse('$baseUrl/tiendas');

      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} tiendas obtenidas');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener tiendas: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo tiendas', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene una tienda por ID
  Future<Map<String, dynamic>> getTiendaById(String id) async {
    try {
      AppLogger.database('Obteniendo tienda: $id');

      final response = await http
          .get(Uri.parse('$baseUrl/tiendas/$id'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Tienda obtenida: ${data['nombre']}');
        return data;
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener tienda: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo tienda', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Crea una nueva tienda
  Future<Map<String, dynamic>> createTienda(Map<String, dynamic> data) async {
    try {
      AppLogger.database('Creando tienda: ${data['nombre']}');

      final response = await http
          .post(
            Uri.parse('$baseUrl/tiendas'),
            headers: _headers,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Tienda creada: ${result['id']}');
        return result;
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al crear tienda: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error creando tienda', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Actualiza una tienda
  Future<Map<String, dynamic>> updateTienda({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      AppLogger.database('Actualizando tienda: $id');

      final response = await http
          .patch(
            Uri.parse('$baseUrl/tiendas/$id'),
            headers: _headers,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Tienda actualizada');
        return result;
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al actualizar tienda: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error actualizando tienda', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Elimina una tienda (soft delete)
  Future<void> deleteTienda(String id) async {
    try {
      AppLogger.database('Eliminando tienda: $id');

      final response = await http
          .delete(Uri.parse('$baseUrl/tiendas/$id'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 204) {
        AppLogger.database('✅ Tienda eliminada: $id');
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al eliminar tienda: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error eliminando tienda', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Marca una tienda como sincronizada
  Future<void> markAsSynced(String id, DateTime syncTime) async {
    try {
      await http
          .patch(
            Uri.parse('$baseUrl/tiendas/$id'),
            headers: _headers,
            body: jsonEncode({'last_sync': syncTime.toIso8601String()}),
          )
          .timeout(const Duration(seconds: 30));

      AppLogger.sync('Tienda marcada como sincronizada: $id');
    } catch (e) {
      AppLogger.error('Error marcando tienda como sincronizada', e);
    }
  }
}

