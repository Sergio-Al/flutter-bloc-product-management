import 'package:flutter_management_system/data/datasources/remote/supabase_datasource.dart';

class LoteRemoteDataSource extends SupabaseDataSource {
  static const String _tableName = 'lotes';

  /// Obtiene todos los lotes
  Future<List<Map<String, dynamic>>> getLotes() async {
    return SupabaseDataSource.executeQuery(() async {
      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .order('fecha_vencimiento');

      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Obtiene un lote por ID
  Future<Map<String, dynamic>> getLoteById(String id) async {
    return SupabaseDataSource.executeQuery(() async {
      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .eq('id', id)
          .single();

      return response;
    });
  }

  // Obtiene un lote por número de lote
  Future<Map<String, dynamic>> getLoteByNumero(String numeroLote) async {
    return SupabaseDataSource.executeQuery(() async {
      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .eq('numero_lote', numeroLote)
          .single();

      return response;
    });
  }

  /// Obtiene lotes por ID de producto
  Future<List<Map<String, dynamic>>> getLotesByProducto(
    String productoId,
  ) async {
    return SupabaseDataSource.executeQuery(() async {
      final query = SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .eq('producto_id', productoId);

      return query;
    });
  }

  /// Obtiene lotes por ID de proveedor
  Future<List<Map<String, dynamic>>> getLotesByProveedor(
    String proveedorId,
  ) async {
    return SupabaseDataSource.executeQuery(() async {
      final query = SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .eq('proveedor_id', proveedorId);

      return query;
    });
  }

  /// Obtiene lotes por número de factura
  Future<List<Map<String, dynamic>>> getLotesByFactura(
    String numeroFactura,
  ) async {
    return SupabaseDataSource.executeQuery(() async {
      final query = SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .eq('numero_factura', numeroFactura);
      return query;
    });
  }

  // Obtiene lotes vencidos
  Future<List<Map<String, dynamic>>> getLotesVencidos() async {
    return SupabaseDataSource.executeQuery(() async {
      final query = SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .lt('fecha_vencimiento', DateTime.now().toIso8601String());

      return query;
    });
  }

  // Obtiene lotes por vencer en 30 días
  Future<List<Map<String, dynamic>>> getLotesPorVencer() async {
    return SupabaseDataSource.executeQuery(() async {
      final now = DateTime.now();
      final in30Days = now.add(Duration(days: 30));
      final query = SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .gte('fecha_vencimiento', now.toIso8601String())
          .lte('fecha_vencimiento', in30Days.toIso8601String());

      return query;
    });
  }

  /// Obtiene lotes con stock disponible
  Future<List<Map<String, dynamic>>> getLotesConStock() async {
    return SupabaseDataSource.executeQuery(() async {
      final query = SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .gt('cantidad', 0);
      return query;
    });
  }

  /// Obtiene lotes vacios
  Future<List<Map<String, dynamic>>> getLotesVacios() async {
    return SupabaseDataSource.executeQuery(() async {
      final query = SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .eq('cantidad', 0);
      return query;
    });
  }

  /// Obtiene lotes con certificado de calidad
  Future<List<Map<String, dynamic>>> getLotesConCertificado() async {
    return SupabaseDataSource.executeQuery(() async {
      final query = SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .not('certificado_calidad', 'is', null);
      return query;
    });
  }

  // Busca lotes por número de lote o factura
  Future<List<Map<String, dynamic>>> searchLotes(String query) async {
    return SupabaseDataSource.executeQuery(() async {
      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .or('numero_lote.ilike.%$query%,numero_factura.ilike.%$query%')
          .order('fecha_vencimiento');

      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Crea un nuevo lote
  Future<Map<String, dynamic>> createLote(Map<String, dynamic> data) async {
    return SupabaseDataSource.executeQuery(() async {
      final response = await SupabaseDataSource.client
          .from(_tableName)
          .insert(data)
          .select()
          .single();

      return response;
    });
  }

  /// Actualiza un lote existente
  Future<Map<String, dynamic>> updateLote({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      final response = await SupabaseDataSource.client
          .from(_tableName)
          .update(data)
          .eq('id', id)
          .select()
          .single();

      return response;
    });
  }

  /// Actualiza la cantidad de un lote
  Future<Map<String, dynamic>> updateCantidadLote({
    required String loteId,
    required int cantidadNueva,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      final response = await SupabaseDataSource.client
          .from(_tableName)
          .update({'cantidad': cantidadNueva})
          .eq('id', loteId)
          .select()
          .single();

      return response;
    });
  }

  /// Elimina un lote
  Future<void> deleteLote(String id) async {
    return SupabaseDataSource.executeQuery(() async {
      await SupabaseDataSource.client.from(_tableName).delete().eq('id', id);
    });
  }

  /// Obtiene lotes modificados desde un timestamp (para sincronización incremental)
  Future<List<Map<String, dynamic>>> getChangedSince(DateTime? since) async {
    return SupabaseDataSource.executeQuery(() async {
      var query = SupabaseDataSource.client.from(_tableName).select('*');

      if (since != null) {
        query = query.gt('updated_at', since.toIso8601String());
      }

      final response = await query.order('updated_at');
      return List<Map<String, dynamic>>.from(response);
    });
  }
}
