import 'supabase_datasource.dart';
import '../../../core/utils/logger.dart';

/// Datasource remoto para operaciones de tiendas con Supabase
class TiendaRemoteDataSource extends SupabaseDataSource {
  static const String _tableName = 'tiendas';

  /// Obtiene todas las tiendas
  Future<List<Map<String, dynamic>>> getTiendas({
    DateTime? lastSync,
    bool? soloActivas,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo tiendas');

      var query = SupabaseDataSource.client.from(_tableName).select('*');

      if (lastSync != null) {
        query = SupabaseDataSource.applySyncFilters(query, lastSync);
      }

      if (soloActivas == true) {
        query = SupabaseDataSource.applyActiveFilter(query);
      }

      final response = await query.order('nombre');

      AppLogger.database('✅ ${response.length} tiendas obtenidas');
      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Obtiene una tienda por ID
  Future<Map<String, dynamic>> getTiendaById(String id) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo tienda: $id');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .eq('id', id)
          .single();

      return response;
    });
  }

  /// Crea una nueva tienda
  Future<Map<String, dynamic>> createTienda(Map<String, dynamic> data) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Creando tienda: ${data['nombre']}');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .insert(data)
          .select()
          .single();

      AppLogger.database('✅ Tienda creada: ${response['id']}');
      return response;
    });
  }

  /// Actualiza una tienda
  Future<Map<String, dynamic>> updateTienda({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Actualizando tienda: $id');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .update(data)
          .eq('id', id)
          .select()
          .single();

      AppLogger.database('✅ Tienda actualizada');
      return response;
    });
  }

  /// Elimina una tienda (soft delete)
  Future<void> deleteTienda(String id) async {
    await SupabaseDataSource.softDelete(_tableName, id);
    AppLogger.database('✅ Tienda eliminada: $id');
  }

  /// Marca una tienda como sincronizada
  Future<void> markAsSynced(String id, DateTime syncTime) async {
    return SupabaseDataSource.executeQuery(() async {
      await SupabaseDataSource.client.from(_tableName).update({
        'last_sync': syncTime.toIso8601String(),
      }).eq('id', id);

      AppLogger.sync('Tienda marcada como sincronizada: $id');
    });
  }
}
