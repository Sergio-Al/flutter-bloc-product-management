import 'supabase_datasource.dart';
import '../../../core/utils/logger.dart';

/// Datasource remoto para operaciones de proveedores con Supabase
class ProveedorRemoteDataSource extends SupabaseDataSource {
  static const String _tableName = 'proveedores';

  /// Obtiene todos los proveedores
  Future<List<Map<String, dynamic>>> getProveedores({
    DateTime? lastSync,
    bool? soloActivos,
    String? tipoMaterial,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo proveedores');

      var query = SupabaseDataSource.client.from(_tableName).select('*');

      if (lastSync != null) {
        query = SupabaseDataSource.applySyncFilters(query, lastSync);
      }

      if (soloActivos == true) {
        query = SupabaseDataSource.applyActiveFilter(query);
      }

      if (tipoMaterial != null) {
        query = query.eq('tipo_material', tipoMaterial);
      }

      final response = await query.order('razon_social');

      AppLogger.database('✅ ${response.length} proveedores obtenidos');
      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Obtiene un proveedor por ID
  Future<Map<String, dynamic>> getProveedorById(String id) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo proveedor: $id');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .eq('id', id)
          .single();

      return response;
    });
  }

  /// Busca proveedores por término
  Future<List<Map<String, dynamic>>> searchProveedores(String searchTerm) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Buscando proveedores: $searchTerm');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .or('razon_social.ilike.%$searchTerm%,nit.ilike.%$searchTerm%,nombre_contacto.ilike.%$searchTerm%');

      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Crea un nuevo proveedor
  Future<Map<String, dynamic>> createProveedor(Map<String, dynamic> data) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Creando proveedor: ${data}');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .insert(data)
          .select()
          .single();

      AppLogger.database('✅ Proveedor creado: ${response['id']}');
      return response;
    });
  }

  /// Actualiza un proveedor
  Future<Map<String, dynamic>> updateProveedor({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Actualizando proveedor: $id');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .update(data)
          .eq('id', id)
          .select()
          .single();

      AppLogger.database('✅ Proveedor actualizado');
      return response;
    });
  }

  /// Elimina un proveedor (soft delete)
  Future<void> deleteProveedor(String id) async {
    await SupabaseDataSource.softDelete(_tableName, id);
    AppLogger.database('✅ Proveedor eliminado: $id');
  }

  /// Obtiene proveedores por tipo de material
  Future<List<Map<String, dynamic>>> getProveedoresByTipoMaterial(
    String tipoMaterial,
  ) async {
    return getProveedores(tipoMaterial: tipoMaterial, soloActivos: true);
  }

  /// Marca un proveedor como sincronizado
  Future<void> markAsSynced(String id, DateTime syncTime) async {
    return SupabaseDataSource.executeQuery(() async {
      await SupabaseDataSource.client.from(_tableName).update({
        'last_sync': syncTime.toIso8601String(),
      }).eq('id', id);

      AppLogger.sync('Proveedor marcado como sincronizado: $id');
    });
  }

  /// Obtiene estadísticas de compras por proveedor
  Future<Map<String, dynamic>> getEstadisticasProveedor(String proveedorId) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo estadísticas del proveedor: $proveedorId');

      final response = await SupabaseDataSource.client
          .rpc('get_estadisticas_proveedor', params: {
        'p_proveedor_id': proveedorId,
      });

      return response;
    });
  }
}
