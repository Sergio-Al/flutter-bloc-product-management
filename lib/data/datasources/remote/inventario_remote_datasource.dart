import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/env_config.dart';
import '../../../core/errors/exceptions.dart' as app_exceptions;
import '../../../core/utils/logger.dart';
import 'auth_remote_datasource.dart';

/// Datasource remoto para operaciones de inventario con NestJS backend
class InventarioRemoteDataSource {
  /// Base URL del API (configurable desde .env)
  static String get baseUrl => EnvConfig.apiUrl;

  final AuthRemoteDataSource? _authDataSource;

  /// Constructor with optional authDataSource for public endpoints
  InventarioRemoteDataSource({AuthRemoteDataSource? authDataSource})
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

  /// Obtiene todos los inventarios
  Future<List<Map<String, dynamic>>> getInventarios({
    DateTime? lastSync,
    String? tiendaId,
    String? almacenId,
  }) async {
    try {
      AppLogger.database('Obteniendo inventarios desde NestJS');

      // Build query parameters
      final queryParams = <String, String>{};
      if (tiendaId != null) {
        queryParams['tiendaId'] = tiendaId;
      }
      if (almacenId != null) {
        queryParams['almacenId'] = almacenId;
      }

      final uri = Uri.parse('$baseUrl/inventarios').replace(
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} inventarios obtenidos');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener inventarios: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo inventarios', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene inventario por ID
  Future<Map<String, dynamic>?> getInventarioById(String id) async {
    try {
      AppLogger.database('Obteniendo inventario: $id');

      final response = await http
          .get(Uri.parse('$baseUrl/inventarios/$id'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Inventario obtenido');
        return data;
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener inventario: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo inventario', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene inventario por producto y almacén
  Future<Map<String, dynamic>?> getInventarioByProductoAlmacen({
    required String productoId,
    required String almacenId,
  }) async {
    try {
      AppLogger.database('Obteniendo inventario producto: $productoId, almacén: $almacenId');

      final uri = Uri.parse('$baseUrl/inventarios').replace(
        queryParameters: {
          'productoId': productoId,
          'almacenId': almacenId,
        },
      );

      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return data.first as Map<String, dynamic>;
        }
        return null;
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener inventario: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo inventario por producto/almacén', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene inventarios por tienda
  Future<List<Map<String, dynamic>>> getInventariosByTienda(String tiendaId) async {
    try {
      AppLogger.database('Obteniendo inventarios por tienda: $tiendaId');

      final response = await http
          .get(Uri.parse('$baseUrl/inventarios/tienda/$tiendaId'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} inventarios obtenidos para tienda');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener inventarios por tienda: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo inventarios por tienda', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene inventarios por almacén
  Future<List<Map<String, dynamic>>> getInventariosByAlmacen(String almacenId) async {
    try {
      AppLogger.database('Obteniendo inventarios por almacén: $almacenId');

      final response = await http
          .get(Uri.parse('$baseUrl/inventarios/almacen/$almacenId'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} inventarios obtenidos para almacén');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener inventarios por almacén: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo inventarios por almacén', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene inventarios por producto
  Future<List<Map<String, dynamic>>> getInventariosByProducto(String productoId) async {
    try {
      AppLogger.database('Obteniendo inventarios por producto: $productoId');

      final response = await http
          .get(Uri.parse('$baseUrl/inventarios/producto/$productoId'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} inventarios obtenidos para producto');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener inventarios por producto: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo inventarios por producto', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene inventarios por lote
  Future<List<Map<String, dynamic>>> getInventariosByLote(String loteId) async {
    try {
      AppLogger.database('Obteniendo inventarios por lote: $loteId');

      final uri = Uri.parse('$baseUrl/inventarios').replace(
        queryParameters: {'loteId': loteId},
      );

      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} inventarios obtenidos para lote');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener inventarios por lote: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo inventarios por lote', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene inventarios con stock bajo
  Future<List<Map<String, dynamic>>> getInventariosStockBajo({
    String? tiendaId,
    int minimo = 10,
  }) async {
    try {
      AppLogger.database('Obteniendo inventarios con stock bajo');

      final queryParams = <String, String>{'minimo': minimo.toString()};
      if (tiendaId != null) {
        queryParams['tiendaId'] = tiendaId;
      }

      final uri = Uri.parse('$baseUrl/inventarios/bajo-stock').replace(
        queryParameters: queryParams,
      );

      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} inventarios con stock bajo');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener inventarios bajo stock: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo inventarios bajo stock', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene disponibilidad de un producto en todas las ubicaciones
  Future<List<Map<String, dynamic>>> getDisponibilidadProducto(String productoId) async {
    try {
      AppLogger.database('Obteniendo disponibilidad producto: $productoId');

      final response = await http
          .get(Uri.parse('$baseUrl/inventarios/disponibilidad/$productoId'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        }
        // If single object, wrap in list
        return [data as Map<String, dynamic>];
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener disponibilidad: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo disponibilidad producto', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene inventarios disponibles (con stock > 0)
  Future<List<Map<String, dynamic>>> getInventariosDisponibles() async {
    try {
      AppLogger.database('Obteniendo inventarios disponibles');

      final uri = Uri.parse('$baseUrl/inventarios').replace(
        queryParameters: {'disponible': 'true'},
      );

      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} inventarios disponibles');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener inventarios disponibles: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo inventarios disponibles', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Crea un nuevo registro de inventario
  Future<Map<String, dynamic>> createInventario(Map<String, dynamic> data) async {
    try {
      AppLogger.database('Creando inventario');
      AppLogger.info('Create inventario payload: $data');

      final response = await http
          .post(
            Uri.parse('$baseUrl/inventarios'),
            headers: _headers,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      AppLogger.info('Create inventario response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Inventario creado: ${result['id']}');
        return result;
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al crear inventario: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error creando inventario', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Actualiza inventario completo
  Future<Map<String, dynamic>> updateInventario({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      AppLogger.database('Actualizando inventario: $id');

      final response = await http
          .patch(
            Uri.parse('$baseUrl/inventarios/$id'),
            headers: _headers,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Inventario actualizado');
        return result;
      } else if (response.statusCode == 404) {
        throw app_exceptions.ServerException(
          message: 'Inventario no encontrado: $id',
          code: '404',
        );
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al actualizar inventario: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error actualizando inventario', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Actualiza el stock de un inventario
  Future<Map<String, dynamic>> updateStock({
    required String id,
    required int cantidadActual,
    int? cantidadReservada,
  }) async {
    final data = <String, dynamic>{
      'cantidadActual': cantidadActual,
    };
    if (cantidadReservada != null) {
      data['cantidadReservada'] = cantidadReservada;
    }
    return updateInventario(id: id, data: data);
  }

  /// Reserva stock
  Future<Map<String, dynamic>> reservarStock({
    required String inventarioId,
    required int cantidad,
  }) async {
    try {
      AppLogger.database('Reservando stock inventario $inventarioId: $cantidad');

      final response = await http
          .patch(
            Uri.parse('$baseUrl/inventarios/$inventarioId/reservar'),
            headers: _headers,
            body: jsonEncode({'cantidad': cantidad}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Stock reservado');
        return result;
      } else if (response.statusCode == 404) {
        throw app_exceptions.ServerException(
          message: 'Inventario no encontrado: $inventarioId',
          code: '404',
        );
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al reservar stock: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error reservando stock', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Libera stock reservado
  Future<Map<String, dynamic>> liberarStock({
    required String inventarioId,
    required int cantidad,
  }) async {
    try {
      AppLogger.database('Liberando stock inventario $inventarioId: $cantidad');

      final response = await http
          .patch(
            Uri.parse('$baseUrl/inventarios/$inventarioId/liberar'),
            headers: _headers,
            body: jsonEncode({'cantidad': cantidad}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Stock liberado');
        return result;
      } else if (response.statusCode == 404) {
        throw app_exceptions.ServerException(
          message: 'Inventario no encontrado: $inventarioId',
          code: '404',
        );
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al liberar stock: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error liberando stock', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Ajusta el stock de un inventario
  Future<Map<String, dynamic>> ajustarStock({
    required String inventarioId,
    required int nuevaCantidad,
    required String motivo,
  }) async {
    return updateInventario(
      id: inventarioId,
      data: {
        'cantidadActual': nuevaCantidad,
        'motivoAjuste': motivo,
      },
    );
  }

  /// Elimina un inventario
  Future<void> deleteInventario(String id) async {
    try {
      AppLogger.database('Eliminando inventario: $id');

      final response = await http
          .delete(Uri.parse('$baseUrl/inventarios/$id'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 204) {
        AppLogger.database('✅ Inventario eliminado: $id');
      } else if (response.statusCode == 404) {
        throw app_exceptions.ServerException(
          message: 'Inventario no encontrado: $id',
          code: '404',
        );
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al eliminar inventario: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error eliminando inventario', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene inventarios modificados desde una fecha
  Future<List<Map<String, dynamic>>> getInventariosModificados(DateTime since) async {
    try {
      AppLogger.database('Obteniendo inventarios modificados desde: $since');

      final uri = Uri.parse('$baseUrl/inventarios').replace(
        queryParameters: {'modifiedSince': since.toIso8601String()},
      );

      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} inventarios modificados');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener inventarios modificados: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo inventarios modificados', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Marca un inventario como sincronizado
  Future<void> markAsSynced(String id, DateTime syncTime) async {
    try {
      await http
          .patch(
            Uri.parse('$baseUrl/inventarios/$id'),
            headers: _headers,
            body: jsonEncode({'lastSync': syncTime.toIso8601String()}),
          )
          .timeout(const Duration(seconds: 30));

      AppLogger.sync('Inventario marcado como sincronizado: $id');
    } catch (e) {
      AppLogger.error('Error marcando inventario como sincronizado', e);
    }
  }

  /// Obtiene resumen de inventario por tienda (if endpoint exists)
  Future<List<Map<String, dynamic>>> getResumenPorTienda(String tiendaId) async {
    // This may need a custom endpoint in NestJS
    return getInventariosByTienda(tiendaId);
  }

  /// Obtiene inventarios con stock crítico
  Future<List<Map<String, dynamic>>> getInventariosStockCritico() async {
    // Use bajo-stock with low threshold
    return getInventariosStockBajo(minimo: 5);
  }

  /// Obtiene el valor total del inventario (if endpoint exists)
  Future<Map<String, dynamic>> getValorTotalInventario({
    String? tiendaId,
    String? almacenId,
  }) async {
    // This would need a custom endpoint in NestJS
    // For now, return empty data
    return {'valorTotal': 0.0, 'moneda': 'BOB'};
  }
}
