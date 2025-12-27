import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/env_config.dart';
import '../../../core/errors/exceptions.dart' as app_exceptions;
import '../../../core/utils/logger.dart';
import 'auth_remote_datasource.dart';

/// Datasource remoto para operaciones de productos con NestJS backend
class ProductoRemoteDataSource {
  final AuthRemoteDataSource _authDataSource;

  ProductoRemoteDataSource({required AuthRemoteDataSource authDataSource})
    : _authDataSource = authDataSource;

  /// Base URL del API (configurable desde .env)
  static String get baseUrl => EnvConfig.apiUrl;

  /// Headers comunes para todas las peticiones (incluye auth token)
  Map<String, String> get _headers {
    final token = _authDataSource.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Obtiene todos los productos
  ///
  /// [lastSync] - Fecha de última sincronización (opcional)
  /// [limit] - Límite de resultados
  /// [offset] - Offset para paginación
  Future<List<Map<String, dynamic>>> getProductos({
    DateTime? lastSync,
    int? limit,
    int? offset,
  }) async {
    try {
      AppLogger.database('Obteniendo productos desde NestJS');

      // Build query parameters
      final queryParams = <String, String>{};
      if (lastSync != null) {
        queryParams['lastSync'] = lastSync.toIso8601String();
      }
      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }
      if (offset != null) {
        queryParams['offset'] = offset.toString();
      }

      final uri = Uri.parse(
        '$baseUrl/productos',
      ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} productos obtenidos');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener productos: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo productos', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene los productos activos
  Future<List<Map<String, dynamic>>> getProductosActivos() async {
    try {
      AppLogger.database('Obteniendo productos activos desde NestJS');

      final response = await http
          .get(Uri.parse('$baseUrl/productos?activo=true'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} productos activos obtenidos');
        AppLogger.info('Productos activos data: $data');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener productos activos: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo productos activos', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene un producto por ID
  Future<Map<String, dynamic>> getProductoById(String id) async {
    try {
      AppLogger.database('Obteniendo producto: $id');

      final response = await http
          .get(Uri.parse('$baseUrl/productos/$id'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Producto obtenido: ${data['nombre']}');
        return data;
      } else if (response.statusCode == 404) {
        throw app_exceptions.ServerException(
          message: 'Producto no encontrado: $id',
          code: '404',
        );
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener producto: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) {
        rethrow;
      }
      AppLogger.error('Error obteniendo producto', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Busca productos por término de búsqueda
  Future<List<Map<String, dynamic>>> searchProductos({
    required String searchTerm,
    int? limit,
  }) async {
    try {
      AppLogger.database('Buscando productos: $searchTerm');

      final queryParams = <String, String>{'search': searchTerm};
      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }

      final uri = Uri.parse(
        '$baseUrl/productos',
      ).replace(queryParameters: queryParams);

      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} productos encontrados');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al buscar productos: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error buscando productos', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Crea un nuevo producto
  Future<Map<String, dynamic>> createProducto(Map<String, dynamic> data) async {
    try {
      AppLogger.database('Creando producto: ${data['nombre']}');

      AppLogger.info('Base url $baseUrl');

      final response = await http
          .post(
            Uri.parse('$baseUrl/productos'),
            headers: _headers,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      print(
        'Create producto response: ${response.statusCode} - ${response.body}',
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Producto creado: ${responseData['id']}');
        return responseData;
      } else {
        final errorBody = response.body;
        AppLogger.error('Error creating producto: $errorBody');
        throw app_exceptions.ServerException(
          message:
              'Error al crear producto: ${response.statusCode} - $errorBody',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error creando producto', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Actualiza un producto existente
  Future<Map<String, dynamic>> updateProducto({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      AppLogger.database('Actualizando producto: $id');

      final response = await http
          .patch(
            Uri.parse('$baseUrl/productos/$id'),
            headers: _headers,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Producto actualizado: ${responseData['nombre']}');
        return responseData;
      } else if (response.statusCode == 404) {
        throw app_exceptions.ServerException(
          message: 'Producto no encontrado: $id',
          code: '404',
        );
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al actualizar producto: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) {
        rethrow;
      }
      AppLogger.error('Error actualizando producto', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Elimina un producto (soft delete)
  Future<void> deleteProducto(String id) async {
    try {
      AppLogger.database('Eliminando producto: $id');

      final response = await http
          .delete(Uri.parse('$baseUrl/productos/$id'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 204) {
        AppLogger.database('✅ Producto eliminado: $id');
      } else if (response.statusCode == 404) {
        throw app_exceptions.ServerException(
          message: 'Producto no encontrado: $id',
          code: '404',
        );
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al eliminar producto: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) {
        rethrow;
      }
      AppLogger.error('Error eliminando producto', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Elimina permanentemente un producto
  Future<void> hardDeleteProducto(String id) async {
    // En NestJS, el DELETE endpoint puede ser hard delete por defecto
    // Si necesitas diferenciar, podrías usar un query param o endpoint diferente
    await deleteProducto(id);
    AppLogger.database('✅ Producto eliminado permanentemente: $id');
  }

  /// Restaura un producto eliminado
  Future<void> restoreProducto(String id) async {
    try {
      AppLogger.database('Restaurando producto: $id');

      final response = await http
          .patch(Uri.parse('$baseUrl/productos/$id/restore'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        AppLogger.database('✅ Producto restaurado: $id');
      } else if (response.statusCode == 404) {
        throw app_exceptions.ServerException(
          message: 'Producto no encontrado: $id',
          code: '404',
        );
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al restaurar producto: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) {
        rethrow;
      }
      AppLogger.error('Error restaurando producto', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene productos por categoría
  Future<List<Map<String, dynamic>>> getProductosByCategoria(
    String categoriaId,
  ) async {
    try {
      AppLogger.database('Obteniendo productos por categoría: $categoriaId');

      final response = await http
          .get(
            Uri.parse('$baseUrl/productos?categoriaId=$categoriaId'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database(
          '✅ ${data.length} productos obtenidos para categoría',
        );
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message:
              'Error al obtener productos por categoría: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo productos por categoría', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene productos por proveedor
  Future<List<Map<String, dynamic>>> getProductosByProveedor(
    String proveedorId,
  ) async {
    try {
      AppLogger.database('Obteniendo productos por proveedor: $proveedorId');

      final response = await http
          .get(
            Uri.parse('$baseUrl/productos?proveedorId=$proveedorId'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database(
          '✅ ${data.length} productos obtenidos para proveedor',
        );
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message:
              'Error al obtener productos por proveedor: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo productos por proveedor', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene productos con stock bajo
  Future<List<Map<String, dynamic>>> getProductosStockBajo() async {
    try {
      AppLogger.database('Obteniendo productos con stock bajo');

      final response = await http
          .get(
            Uri.parse('$baseUrl/productos?stockBajo=true'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} productos con stock bajo');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message:
              'Error al obtener productos con stock bajo: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo productos con stock bajo', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Actualiza precios de productos de un proveedor
  Future<void> updatePreciosByProveedor({
    required String proveedorId,
    required double porcentajeIncremento,
  }) async {
    try {
      AppLogger.database(
        'Actualizando precios del proveedor $proveedorId en $porcentajeIncremento%',
      );

      final response = await http
          .post(
            Uri.parse('$baseUrl/productos/actualizar-precios'),
            headers: _headers,
            body: jsonEncode({
              'proveedorId': proveedorId,
              'porcentaje': porcentajeIncremento,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.database('✅ Precios actualizados');
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al actualizar precios: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error actualizando precios', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Marca un producto como sincronizado
  Future<void> markAsSynced(String id, DateTime syncTime) async {
    try {
      await http
          .patch(
            Uri.parse('$baseUrl/productos/$id'),
            headers: _headers,
            body: jsonEncode({'lastSync': syncTime.toIso8601String()}),
          )
          .timeout(const Duration(seconds: 30));

      AppLogger.sync('Producto marcado como sincronizado: $id');
    } catch (e) {
      AppLogger.error('Error marcando producto como sincronizado', e);
    }
  }

  /// Obtiene productos modificados desde una fecha
  Future<List<Map<String, dynamic>>> getProductosModificados(
    DateTime since,
  ) async {
    try {
      AppLogger.sync('Obteniendo productos modificados desde: $since');

      final response = await http
          .get(
            Uri.parse(
              '$baseUrl/productos?modifiedSince=${since.toIso8601String()}',
            ),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.sync('✅ ${data.length} productos modificados');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message:
              'Error al obtener productos modificados: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo productos modificados', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Sube una imagen para un producto
  Future<String> uploadProductoImage({
    required String productoId,
    required String filePath,
  }) async {
    try {
      AppLogger.database('Subiendo imagen para producto: $productoId');

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/productos/$productoId/imagen'),
      );

      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      request.headers.addAll(_headers);

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
      );
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final imageUrl = data['imageUrl'] as String? ?? data['url'] as String?;
        AppLogger.database('✅ Imagen subida: $imageUrl');
        return imageUrl ?? '';
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al subir imagen: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error subiendo imagen', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Elimina la imagen de un producto
  Future<void> deleteProductoImage(String imageUrl) async {
    try {
      AppLogger.database('Eliminando imagen: $imageUrl');

      final response = await http
          .delete(
            Uri.parse('$baseUrl/productos/imagen'),
            headers: _headers,
            body: jsonEncode({'imageUrl': imageUrl}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 204) {
        AppLogger.database('✅ Imagen eliminada');
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al eliminar imagen: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error eliminando imagen', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene estadísticas de productos
  Future<Map<String, dynamic>> getEstadisticas() async {
    try {
      AppLogger.database('Obteniendo estadísticas de productos');

      final response = await http
          .get(Uri.parse('$baseUrl/productos/estadisticas'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Estadísticas obtenidas');
        return data;
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener estadísticas: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo estadísticas', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }
}
