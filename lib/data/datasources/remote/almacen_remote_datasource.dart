import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/env_config.dart';
import '../../../core/errors/exceptions.dart' as app_exceptions;
import '../../../core/utils/logger.dart';
import 'auth_remote_datasource.dart';

/// Datasource remoto para operaciones de almacenes con NestJS backend
class AlmacenRemoteDataSource {
  /// Base URL del API (configurable desde .env)
  static String get baseUrl => EnvConfig.apiUrl;

  final AuthRemoteDataSource? _authDataSource;

  /// Constructor with optional authDataSource for public endpoints (like initial seeding)
  AlmacenRemoteDataSource({AuthRemoteDataSource? authDataSource})
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

  /// Obtiene todos los almacenes
  Future<List<Map<String, dynamic>>> getAlmacenes({
    DateTime? lastSync,
    String? tiendaId,
    bool? soloActivos,
  }) async {
    try {
      AppLogger.database('Obteniendo almacenes desde NestJS');

      // Build query parameters
      final queryParams = <String, String>{};
      if (tiendaId != null) {
        queryParams['tiendaId'] = tiendaId;
      }

      final uri = Uri.parse('$baseUrl/almacenes').replace(
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} almacenes obtenidos');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener almacenes: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo almacenes', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene un almacén por ID
  Future<Map<String, dynamic>> getAlmacenById(String id) async {
    try {
      AppLogger.database('Obteniendo almacén: $id');

      final response = await http
          .get(Uri.parse('$baseUrl/almacenes/$id'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Almacén obtenido: ${data['nombre']}');
        return data;
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener almacén: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo almacén', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Crea un nuevo almacén
  Future<Map<String, dynamic>> createAlmacen(Map<String, dynamic> data) async {
    try {
      AppLogger.database('Creando almacén: ${data['nombre']}');
      AppLogger.database('📤 Data being sent to NestJS: $data');

      final response = await http
          .post(
            Uri.parse('$baseUrl/almacenes'),
            headers: _headers,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Almacén creado: ${result['id']}');
        return result;
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al crear almacén: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error creando almacén', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Actualiza un almacén
  Future<Map<String, dynamic>> updateAlmacen({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      AppLogger.database('Actualizando almacén: $id');
      AppLogger.database('Data a actualizar: $data');

      final response = await http
          .patch(
            Uri.parse('$baseUrl/almacenes/$id'),
            headers: _headers,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Almacén actualizado: ${result['id']}');
        return result;
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al actualizar almacén: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error actualizando almacén', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Elimina un almacén (soft delete)
  Future<void> deleteAlmacen(String id) async {
    try {
      AppLogger.database('Eliminando almacén: $id');

      final response = await http
          .delete(Uri.parse('$baseUrl/almacenes/$id'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 204) {
        AppLogger.database('✅ Almacén eliminado: $id');
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al eliminar almacén: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error eliminando almacén', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene almacenes por tipo
  Future<List<Map<String, dynamic>>> getAlmacenesByTipo(String tipo) async {
    try {
      AppLogger.database('Obteniendo almacenes tipo: $tipo');

      final uri = Uri.parse('$baseUrl/almacenes').replace(
        queryParameters: {'tipo': tipo},
      );

      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener almacenes por tipo: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo almacenes por tipo', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Marca un almacén como sincronizado
  Future<void> markAsSynced(String id, DateTime syncTime) async {
    try {
      await http
          .patch(
            Uri.parse('$baseUrl/almacenes/$id'),
            headers: _headers,
            body: jsonEncode({'last_sync': syncTime.toIso8601String()}),
          )
          .timeout(const Duration(seconds: 30));

      AppLogger.sync('Almacén marcado como sincronizado: $id');
    } catch (e) {
      AppLogger.error('Error marcando almacén como sincronizado', e);
    }
  }
}
