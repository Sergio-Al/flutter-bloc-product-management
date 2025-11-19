import 'supabase_datasource.dart';
import '../../../core/utils/logger.dart';

/// Datasource remoto para operaciones de inventario con Supabase
class InventarioRemoteDataSource extends SupabaseDataSource {
  static const String _tableName = 'inventarios';

  /// Obtiene todos los inventarios
  Future<List<Map<String, dynamic>>> getInventarios({
    DateTime? lastSync,
    String? tiendaId,
    String? almacenId,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo inventarios');

      var query = SupabaseDataSource.client
          .from(_tableName)
          .select('''
            *,
            producto:productos(*),
            almacen:almacenes(*),
            tienda:tiendas(*),
            lote:lotes(*)
          ''');

      if (tiendaId != null) {
        query = query.eq('tienda_id', tiendaId);
      }

      if (almacenId != null) {
        query = query.eq('almacen_id', almacenId);
      }

      final response = await query.order('producto_id', ascending: true);

      AppLogger.database('✅ ${response.length} inventarios obtenidos');
      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Obtiene inventario por producto y almacén
  Future<Map<String, dynamic>?> getInventarioByProductoAlmacen({
    required String productoId,
    required String almacenId,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo inventario: $productoId - $almacenId');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .eq('producto_id', productoId)
          .eq('almacen_id', almacenId)
          .maybeSingle();

      return response;
    });
  }

  /// Actualiza el stock de un inventario
  Future<Map<String, dynamic>> updateStock({
    required String id,
    required int cantidadActual,
    int? cantidadReservada,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Actualizando stock: $id');

      final data = <String, dynamic>{
        'cantidad_actual': cantidadActual,
        'ultima_actualizacion': DateTime.now().toIso8601String(),
      };

      if (cantidadReservada != null) {
        data['cantidad_reservada'] = cantidadReservada;
      }

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .update(data)
          .eq('id', id)
          .select()
          .single();

      AppLogger.database('✅ Stock actualizado');
      return response;
    });
  }

  /// Crea un nuevo registro de inventario
  Future<Map<String, dynamic>> createInventario(
    Map<String, dynamic> data,
  ) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Creando inventario');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .insert(data)
          .select()
          .single();

      AppLogger.database('✅ Inventario creado: ${response['id']}');
      return response;
    });
  }

  /// Obtiene inventarios con stock bajo
  Future<List<Map<String, dynamic>>> getInventariosStockBajo({
    String? tiendaId,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo inventarios con stock bajo');

      var query = SupabaseDataSource.client
          .from(_tableName)
          .select('''
            *,
            producto:productos(*)
          ''')
          .filter('cantidad_actual', 'lte', 'producto.stock_minimo');

      if (tiendaId != null) {
        query = query.eq('tienda_id', tiendaId);
      }

      final response = await query;

      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Obtiene inventarios con stock crítico (por debajo del mínimo)
  Future<List<Map<String, dynamic>>> getInventariosStockCritico() async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo inventarios con stock crítico');

      final response = await SupabaseDataSource.client
          .rpc('get_inventarios_stock_critico');

      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Obtiene el valor total del inventario
  Future<Map<String, dynamic>> getValorTotalInventario({
    String? tiendaId,
    String? almacenId,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo valor total del inventario');

      final response = await SupabaseDataSource.client
          .rpc('get_valor_total_inventario', params: {
        if (tiendaId != null) 'p_tienda_id': tiendaId,
        if (almacenId != null) 'p_almacen_id': almacenId,
      });

      return response;
    });
  }

  /// Ajusta el stock de un inventario
  Future<Map<String, dynamic>> ajustarStock({
    required String inventarioId,
    required int nuevaCantidad,
    required String motivo,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Ajustando stock del inventario: $inventarioId');

      final response = await SupabaseDataSource.client
          .rpc('ajustar_stock_inventario', params: {
        'p_inventario_id': inventarioId,
        'p_nueva_cantidad': nuevaCantidad,
        'p_motivo': motivo,
      });

      AppLogger.database('✅ Stock ajustado');
      return response;
    });
  }

  /// Marca un inventario como sincronizado
  Future<void> markAsSynced(String id, DateTime syncTime) async {
    return SupabaseDataSource.executeQuery(() async {
      await SupabaseDataSource.client.from(_tableName).update({
        'last_sync': syncTime.toIso8601String(),
      }).eq('id', id);

      AppLogger.sync('Inventario marcado como sincronizado: $id');
    });
  }

  /// Obtiene inventarios modificados desde una fecha
  Future<List<Map<String, dynamic>>> getInventariosModificados(
    DateTime since,
  ) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.sync('Obteniendo inventarios modificados desde: $since');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .gt('updated_at', since.toIso8601String())
          .order('updated_at');

      AppLogger.sync('✅ ${response.length} inventarios modificados');
      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Obtiene resumen de inventario por tienda
  Future<List<Map<String, dynamic>>> getResumenPorTienda(String tiendaId) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo resumen de inventario por tienda: $tiendaId');

      final response = await SupabaseDataSource.client
          .rpc('get_resumen_inventario_tienda', params: {
        'p_tienda_id': tiendaId,
      });

      return List<Map<String, dynamic>>.from(response);
    });
  }
}
