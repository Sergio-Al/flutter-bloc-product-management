import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/env_config.dart';
import '../../../core/errors/exceptions.dart' as app_exceptions;
import '../../../core/utils/logger.dart';

/// Datasource remoto para operaciones de proveedores con NestJS backend
class ProveedorRemoteDataSource {
  /// Base URL del API (configurable desde .env)
  static String get baseUrl => EnvConfig.apiUrl;

  /// Headers comunes para todas las peticiones
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
  };

  /// Obtiene todos los proveedores
  Future<List<Map<String, dynamic>>> getProveedores({
    DateTime? lastSync,
    bool? soloActivos,
    String? tipoMaterial,
  }) async {
    try {
      AppLogger.database('Obteniendo proveedores desde NestJS');

      // Build query parameters
      final queryParams = <String, String>{};
      if (tipoMaterial != null) {
        queryParams['tipo'] = tipoMaterial;
      }

      final uri = soloActivos == true
          ? Uri.parse('$baseUrl/proveedores/activos').replace(
              queryParameters: queryParams.isNotEmpty ? queryParams : null,
            )
          : Uri.parse('$baseUrl/proveedores').replace(
              queryParameters: queryParams.isNotEmpty ? queryParams : null,
            );

      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} proveedores obtenidos');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener proveedores: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo proveedores', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene un proveedor por ID
  Future<Map<String, dynamic>> getProveedorById(String id) async {
    try {
      AppLogger.database('Obteniendo proveedor: $id');

      final response = await http
          .get(Uri.parse('$baseUrl/proveedores/$id'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Proveedor obtenido: ${data['razon_social']}');
        return data;
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener proveedor: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo proveedor', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Busca proveedores por término
  Future<List<Map<String, dynamic>>> searchProveedores(
    String searchTerm,
  ) async {
    try {
      AppLogger.database('Buscando proveedores: $searchTerm');

      final response = await http
          .get(
            Uri.parse('$baseUrl/proveedores?search=$searchTerm'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} proveedores encontrados');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al buscar proveedores: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error buscando proveedores', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Crea un nuevo proveedor
  Future<Map<String, dynamic>> createProveedor(
    Map<String, dynamic> data,
  ) async {
    try {
      AppLogger.database('Creando proveedor: ${data['razon_social']}');

      final response = await http
          .post(
            Uri.parse('$baseUrl/proveedores'),
            headers: _headers,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Proveedor creado: ${result['id']}');
        return result;
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al crear proveedor: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error creando proveedor', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Actualiza un proveedor
  Future<Map<String, dynamic>> updateProveedor({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      AppLogger.database('Actualizando proveedor: $id');

      final response = await http
          .patch(
            Uri.parse('$baseUrl/proveedores/$id'),
            headers: _headers,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Proveedor actualizado');
        return result;
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al actualizar proveedor: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error actualizando proveedor', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Elimina un proveedor (soft delete)
  Future<void> deleteProveedor(String id) async {
    try {
      AppLogger.database('Eliminando proveedor: $id');

      final response = await http
          .delete(Uri.parse('$baseUrl/proveedores/$id'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 204) {
        AppLogger.database('✅ Proveedor eliminado: $id');
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al eliminar proveedor: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error eliminando proveedor', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene proveedores por tipo de material
  Future<List<Map<String, dynamic>>> getProveedoresByTipoMaterial(
    String tipoMaterial,
  ) async {
    try {
      AppLogger.database('Obteniendo proveedores por tipo: $tipoMaterial');

      final response = await http
          .get(
            Uri.parse('$baseUrl/proveedores/por-tipo?tipo=$tipoMaterial'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} proveedores obtenidos');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message:
              'Error al obtener proveedores por tipo: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo proveedores por tipo', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }
}
