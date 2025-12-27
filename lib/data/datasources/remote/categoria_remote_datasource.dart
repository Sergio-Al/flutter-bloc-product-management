import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/env_config.dart';
import '../../../core/errors/exceptions.dart' as app_exceptions;
import '../../../core/utils/logger.dart';

/// Datasource remoto para operaciones de categorías con NestJS backend
class CategoriaRemoteDataSource {
  /// Base URL del API (configurable desde .env)
  static String get baseUrl => EnvConfig.apiUrl;

  /// Headers comunes para todas las peticiones
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
  };

  /// Obtiene todas las categorías
  Future<List<Map<String, dynamic>>> getCategorias() async {
    try {
      AppLogger.database('Obteniendo categorías desde NestJS');

      final response = await http
          .get(Uri.parse('$baseUrl/categorias'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} categorías obtenidas');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener categorías: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo categorías', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene todas las categorías activas
  Future<List<Map<String, dynamic>>> getCategoriasActivas() async {
    try {
      AppLogger.database('Obteniendo categorías activas desde NestJS');

      final response = await http
          .get(Uri.parse('$baseUrl/categorias/activas'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} categorías activas obtenidas');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message:
              'Error al obtener categorías activas: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo categorías activas', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene una categoría por ID
  Future<Map<String, dynamic>?> getCategoriaById(String id) async {
    try {
      AppLogger.database('Obteniendo categoría: $id');

      final response = await http
          .get(Uri.parse('$baseUrl/categorias/$id'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Categoría obtenida: ${data['nombre']}');
        return data;
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener categoría: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo categoría', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene el árbol de categorías (con subcategorías anidadas)
  Future<List<Map<String, dynamic>>> getCategoriasArbol() async {
    try {
      AppLogger.database('Obteniendo árbol de categorías desde NestJS');

      final response = await http
          .get(Uri.parse('$baseUrl/categorias/arbol'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ Árbol de categorías obtenido');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message:
              'Error al obtener árbol de categorías: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo árbol de categorías', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Crea una nueva categoría
  Future<Map<String, dynamic>> createCategoria(
    Map<String, dynamic> data,
  ) async {
    try {
      AppLogger.database('Creando categoría: ${data['nombre']}');

      final response = await http
          .post(
            Uri.parse('$baseUrl/categorias'),
            headers: _headers,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Categoría creada: ${result['id']}');
        return result;
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al crear categoría: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error creando categoría', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Actualiza una categoría existente
  Future<Map<String, dynamic>> updateCategoria({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      AppLogger.database('Actualizando categoría: $id');

      final response = await http
          .patch(
            Uri.parse('$baseUrl/categorias/$id'),
            headers: _headers,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Categoría actualizada: ${result['nombre']}');
        return result;
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al actualizar categoría: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error actualizando categoría', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Elimina una categoría
  Future<void> deleteCategoria(String id) async {
    try {
      AppLogger.database('Eliminando categoría: $id');

      final response = await http
          .delete(Uri.parse('$baseUrl/categorias/$id'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 204) {
        AppLogger.database('✅ Categoría eliminada: $id');
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al eliminar categoría: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error eliminando categoría', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }
}
