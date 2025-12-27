import 'dart:convert';
import 'package:flutter_management_system/data/datasources/remote/auth_remote_datasource.dart';
import 'package:http/http.dart' as http;
import '../../../core/config/env_config.dart';
import '../../../core/errors/exceptions.dart' as app_exceptions;
import '../../../core/utils/logger.dart';

/// Datasource remoto para operaciones de lotes con NestJS backend
class LoteRemoteDataSource {
  /// Base URL del API (configurable desde .env)
  static String get baseUrl => EnvConfig.apiUrl;

  final AuthRemoteDataSource _authDataSource;

  LoteRemoteDataSource({required AuthRemoteDataSource authDataSource})
    : _authDataSource = authDataSource;

  // Headers with authorization token
  Map<String, String> get _headers {
    final token = _authDataSource.getAccessToken();
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Obtiene todos los lotes
  Future<List<Map<String, dynamic>>> getLotes() async {
    try {
      AppLogger.database('Obteniendo lotes desde NestJS');

      final response = await http
          .get(Uri.parse('$baseUrl/lotes'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} lotes obtenidos');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener lotes: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo lotes', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene un lote por ID
  Future<Map<String, dynamic>> getLoteById(String id) async {
    try {
      AppLogger.database('Obteniendo lote: $id');

      final response = await http
          .get(Uri.parse('$baseUrl/lotes/$id'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Lote obtenido: ${data['numero_lote']}');
        return data;
      } else if (response.statusCode == 404) {
        throw app_exceptions.ServerException(
          message: 'Lote no encontrado: $id',
          code: '404',
        );
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener lote: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo lote', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene un lote por número de lote
  Future<Map<String, dynamic>> getLoteByNumero(String numeroLote) async {
    try {
      AppLogger.database('Obteniendo lote por número: $numeroLote');

      final response = await http
          .get(
            Uri.parse('$baseUrl/lotes/numero/$numeroLote'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Lote obtenido: ${data['numero_lote']}');
        return data;
      } else if (response.statusCode == 404) {
        throw app_exceptions.ServerException(
          message: 'Lote no encontrado: $numeroLote',
          code: '404',
        );
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener lote: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo lote por número', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene lotes por ID de producto
  Future<List<Map<String, dynamic>>> getLotesByProducto(
    String productoId,
  ) async {
    try {
      AppLogger.database('Obteniendo lotes por producto: $productoId');

      final response = await http
          .get(
            Uri.parse('$baseUrl/lotes/producto/$productoId'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} lotes obtenidos para producto');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message:
              'Error al obtener lotes por producto: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo lotes por producto', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene lotes por ID de proveedor
  Future<List<Map<String, dynamic>>> getLotesByProveedor(
    String proveedorId,
  ) async {
    try {
      AppLogger.database('Obteniendo lotes por proveedor: $proveedorId');

      final response = await http
          .get(
            Uri.parse('$baseUrl/lotes/proveedor/$proveedorId'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} lotes obtenidos para proveedor');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message:
              'Error al obtener lotes por proveedor: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo lotes por proveedor', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene lotes por número de factura
  Future<List<Map<String, dynamic>>> getLotesByFactura(
    String numeroFactura,
  ) async {
    try {
      AppLogger.database('Obteniendo lotes por factura: $numeroFactura');

      final uri = Uri.parse(
        '$baseUrl/lotes',
      ).replace(queryParameters: {'numero_factura': numeroFactura});

      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} lotes obtenidos para factura');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener lotes por factura: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo lotes por factura', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene lotes vencidos
  Future<List<Map<String, dynamic>>> getLotesVencidos() async {
    try {
      AppLogger.database('Obteniendo lotes vencidos');

      final response = await http
          .get(Uri.parse('$baseUrl/lotes/vencidos'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} lotes vencidos');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener lotes vencidos: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo lotes vencidos', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene lotes por vencer en X días (default 30)
  Future<List<Map<String, dynamic>>> getLotesPorVencer({int dias = 30}) async {
    try {
      AppLogger.database('Obteniendo lotes por vencer en $dias días');

      final response = await http
          .get(
            Uri.parse('$baseUrl/lotes/proximos-vencer?dias=$dias'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} lotes por vencer');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener lotes por vencer: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo lotes por vencer', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene lotes con stock disponible
  Future<List<Map<String, dynamic>>> getLotesConStock() async {
    try {
      AppLogger.database('Obteniendo lotes con stock');

      final response = await http
          .get(Uri.parse('$baseUrl/lotes/con-stock'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} lotes con stock');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener lotes con stock: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo lotes con stock', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene lotes agotados (sin stock)
  Future<List<Map<String, dynamic>>> getLotesVacios() async {
    try {
      AppLogger.database('Obteniendo lotes agotados');

      final response = await http
          .get(Uri.parse('$baseUrl/lotes/agotados'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} lotes agotados');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener lotes agotados: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo lotes agotados', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene lotes con certificado de calidad
  Future<List<Map<String, dynamic>>> getLotesConCertificado() async {
    try {
      AppLogger.database('Obteniendo lotes con certificado');

      final uri = Uri.parse(
        '$baseUrl/lotes',
      ).replace(queryParameters: {'con_certificado': 'true'});

      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} lotes con certificado');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message:
              'Error al obtener lotes con certificado: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo lotes con certificado', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Busca lotes por número de lote o factura
  Future<List<Map<String, dynamic>>> searchLotes(String query) async {
    try {
      AppLogger.database('Buscando lotes: $query');

      final uri = Uri.parse(
        '$baseUrl/lotes',
      ).replace(queryParameters: {'search': query});

      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} lotes encontrados');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al buscar lotes: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error buscando lotes', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Crea un nuevo lote
  ///
  /// Expects data in NestJS format:
  /// {
  ///   "numero_lote": "LOT-2024-001",
  ///   "productoId": "uuid",
  ///   "fecha_fabricacion": "2024-01-15",
  ///   "fecha_vencimiento": "2025-01-15",
  ///   "proveedorId": "uuid",
  ///   "numero_factura": "FAC-2024-00123",
  ///   "cantidad_inicial": 500,
  ///   "cantidad_actual": 500,
  ///   "certificado_calidad_url": "https://...",
  ///   "observaciones": "..."
  /// }
  Future<Map<String, dynamic>> createLote(Map<String, dynamic> data) async {
    try {
      AppLogger.database('Creando lote: ${data['numero_lote']}');

      AppLogger.info('Create lote payload: $data and headers: $_headers');

      final response = await http
          .post(
            Uri.parse('$baseUrl/lotes'),
            headers: _headers,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      AppLogger.info(
        'Create lote response: ${response.statusCode} - ${response.body}',
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Lote creado: ${result['id']}');
        return result;
      } else {
        throw app_exceptions.ServerException(
          message:
              'Error al crear lote: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error creando lote', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Actualiza un lote existente
  Future<Map<String, dynamic>> updateLote({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      AppLogger.database('Actualizando lote: $id');

      final response = await http
          .patch(
            Uri.parse('$baseUrl/lotes/$id'),
            headers: _headers,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Lote actualizado');
        return result;
      } else if (response.statusCode == 404) {
        throw app_exceptions.ServerException(
          message: 'Lote no encontrado: $id',
          code: '404',
        );
      } else {
        throw app_exceptions.ServerException(
          message:
              'Error al actualizar lote: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error actualizando lote', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Ajusta el stock de un lote (puede ser positivo o negativo)
  Future<Map<String, dynamic>> ajustarStockLote({
    required String loteId,
    required int cantidad,
    String? motivo,
  }) async {
    try {
      AppLogger.database('Ajustando stock del lote $loteId: $cantidad');

      final body = <String, dynamic>{'cantidad': cantidad};
      if (motivo != null) {
        body['motivo'] = motivo;
      }

      final response = await http
          .patch(
            Uri.parse('$baseUrl/lotes/$loteId/ajustar-stock'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        AppLogger.database('✅ Stock ajustado');
        return result;
      } else if (response.statusCode == 404) {
        throw app_exceptions.ServerException(
          message: 'Lote no encontrado: $loteId',
          code: '404',
        );
      } else {
        throw app_exceptions.ServerException(
          message:
              'Error al ajustar stock: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error ajustando stock', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Actualiza la cantidad de un lote (deprecated - use ajustarStockLote)
  Future<Map<String, dynamic>> updateCantidadLote({
    required String loteId,
    required int cantidadNueva,
  }) async {
    return updateLote(id: loteId, data: {'cantidad_actual': cantidadNueva});
  }

  /// Elimina un lote
  Future<void> deleteLote(String id) async {
    try {
      AppLogger.database('Eliminando lote: $id');

      final response = await http
          .delete(Uri.parse('$baseUrl/lotes/$id'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 204) {
        AppLogger.database('✅ Lote eliminado: $id');
      } else if (response.statusCode == 404) {
        throw app_exceptions.ServerException(
          message: 'Lote no encontrado: $id',
          code: '404',
        );
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al eliminar lote: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error eliminando lote', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Obtiene lotes modificados desde un timestamp (para sincronización incremental)
  Future<List<Map<String, dynamic>>> getChangedSince(DateTime? since) async {
    try {
      AppLogger.database('Obteniendo lotes modificados desde: $since');

      final queryParams = <String, String>{};
      if (since != null) {
        queryParams['modifiedSince'] = since.toIso8601String();
      }

      final uri = Uri.parse(
        '$baseUrl/lotes',
      ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.database('✅ ${data.length} lotes modificados');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw app_exceptions.ServerException(
          message: 'Error al obtener lotes modificados: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is app_exceptions.ServerException) rethrow;
      AppLogger.error('Error obteniendo lotes modificados', e);
      throw app_exceptions.ServerException(
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }
}
