import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/env_config.dart';
import '../../../core/errors/exceptions.dart' as app_exceptions;
import '../../../core/utils/logger.dart';

/// Datasource remoto para operaciones de unidades de medida con NestJS backend
class UnidadMedidaRemoteDataSource {
  /// Base URL del API (configurable desde .env)
  static String get baseUrl => EnvConfig.apiUrl;

  /// Headers comunes para todas las peticiones
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
  };

  /// Obtiene todas las unidades de medida
  Future<List<Map<String, dynamic>>> getUnidades() async {
    try {
      AppLogger.database('Obteniendo unidades de medida desde NestJS');

      final response = await http
          .get(Uri.parse('$baseUrl/unidades-medida'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} unidades de medida obtenidas');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message:
              'Error al obtener unidades de medida: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo unidades de medida', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene todas las unidades de medida activas
  /// Nota: En NestJS puede ser el mismo endpoint si no hay filtro de activos
  Future<List<Map<String, dynamic>>> getUnidadesActivas() async {
    return getUnidades();
  }

  /// Obtiene una unidad de medida por ID
  Future<Map<String, dynamic>?> getUnidadById(String id) async {
    try {
      AppLogger.database('Obteniendo unidad de medida: $id');

      final response = await http
          .get(Uri.parse('$baseUrl/unidades-medida/$id'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Unidad obtenida: ${data['nombre']}');
        return data;
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener unidad de medida: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo unidad de medida', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene unidades por tipo
  Future<List<Map<String, dynamic>>> getUnidadesByTipo(String tipo) async {
    try {
      AppLogger.database('Obteniendo unidades por tipo: $tipo');

      final response = await http
          .get(
            Uri.parse('$baseUrl/unidades-medida/por-tipo?tipo=$tipo'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} unidades obtenidas');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener unidades por tipo: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo unidades por tipo', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Crea una nueva unidad de medida
  Future<Map<String, dynamic>> createUnidad(Map<String, dynamic> data) async {
    try {
      AppLogger.database('Creando unidad de medida: ${data['nombre']}');

      final response = await http
          .post(
            Uri.parse('$baseUrl/unidades-medida'),
            headers: _headers,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Unidad creada: ${result['id']}');
        return result;
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al crear unidad de medida: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error creando unidad de medida', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Actualiza una unidad de medida existente
  Future<Map<String, dynamic>> updateUnidad({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      AppLogger.database('Actualizando unidad de medida: $id');

      final response = await http
          .patch(
            Uri.parse('$baseUrl/unidades-medida/$id'),
            headers: _headers,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Unidad actualizada: ${result['nombre']}');
        return result;
      } else {
        throw app_exceptions.ServerException(
          message:
              'Error al actualizar unidad de medida: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error actualizando unidad de medida', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Elimina una unidad de medida
  Future<void> deleteUnidad(String id) async {
    try {
      AppLogger.database('Eliminando unidad de medida: $id');

      final response = await http
          .delete(Uri.parse('$baseUrl/unidades-medida/$id'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 204) {
        AppLogger.database('✅ Unidad eliminada: $id');
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al eliminar unidad de medida: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error eliminando unidad de medida', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }
}
