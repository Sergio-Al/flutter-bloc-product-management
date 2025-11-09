import 'supabase_datasource.dart';
import '../../../core/utils/logger.dart';

/// Datasource remoto para operaciones de almacenes con Supabase
class AlmacenRemoteDataSource extends SupabaseDataSource {
  static const String _tableName = 'almacenes';

  /// Obtiene todos los almacenes
  Future<List<Map<String, dynamic>>> getAlmacenes({
    DateTime? lastSync,
    String? tiendaId,
    bool? soloActivos,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo almacenes');

      var query = SupabaseDataSource.client
          .from(_tableName)
          .select('''
            *,
            tienda:tiendas(*)
          ''');

      if (lastSync != null) {
        query = SupabaseDataSource.applySyncFilters(query, lastSync);
      }

      if (tiendaId != null) {
        query = query.eq('tienda_id', tiendaId);
      }

      if (soloActivos == true) {
        query = SupabaseDataSource.applyActiveFilter(query);
      }

      final response = await query.order('nombre');

      AppLogger.database('✅ ${response.length} almacenes obtenidos');
      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Obtiene un almacén por ID
  Future<Map<String, dynamic>> getAlmacenById(String id) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo almacén: $id');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('''
            *,
            tienda:tiendas(*)
          ''')
          .eq('id', id)
          .single();

      return response;
    });
  }

  /// Crea un nuevo almacén
  Future<Map<String, dynamic>> createAlmacen(Map<String, dynamic> data) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Creando almacén: ${data['nombre']}');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .insert(data)
          .select()
          .single();

      AppLogger.database('✅ Almacén creado: ${response['id']}');
      return response;
    });
  }

  /// Actualiza un almacén
  Future<Map<String, dynamic>> updateAlmacen({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Actualizando almacén: $id');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .update(data)
          .eq('id', id)
          .select()
          .single();

      AppLogger.database('✅ Almacén actualizado');
      return response;
    });
  }

  /// Elimina un almacén (soft delete)
  Future<void> deleteAlmacen(String id) async {
    await SupabaseDataSource.softDelete(_tableName, id);
    AppLogger.database('✅ Almacén eliminado: $id');
  }

  /// Obtiene almacenes por tipo
  Future<List<Map<String, dynamic>>> getAlmacenesByTipo(String tipo) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo almacenes tipo: $tipo');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .eq('tipo', tipo)
          .order('nombre');

      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Marca un almacén como sincronizado
  Future<void> markAsSynced(String id, DateTime syncTime) async {
    return SupabaseDataSource.executeQuery(() async {
      await SupabaseDataSource.client.from(_tableName).update({
        'last_sync': syncTime.toIso8601String(),
      }).eq('id', id);

      AppLogger.sync('Almacén marcado como sincronizado: $id');
    });
  }
}
