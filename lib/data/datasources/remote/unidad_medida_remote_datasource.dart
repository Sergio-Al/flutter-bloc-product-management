import 'supabase_datasource.dart';
import '../../../core/utils/logger.dart';

/// Datasource remoto para operaciones de unidades de medida con Supabase
class UnidadMedidaRemoteDataSource extends SupabaseDataSource {
  static const String _tableName = 'unidades_medida';

  /// Obtiene todas las unidades de medida activas
  Future<List<Map<String, dynamic>>> getUnidadesActivas() async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo unidades de medida activas desde Supabase');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .order('nombre');

      AppLogger.database('✅ ${response.length} unidades obtenidas');
      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Obtiene todas las unidades de medida
  Future<List<Map<String, dynamic>>> getUnidades() async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo todas las unidades desde Supabase');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .order('nombre');

      AppLogger.database('✅ ${response.length} unidades obtenidas');
      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Obtiene una unidad de medida por ID
  Future<Map<String, dynamic>?> getUnidadById(String id) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo unidad: $id');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .eq('id', id)
          .maybeSingle();

      if (response != null) {
        AppLogger.database('✅ Unidad obtenida: ${response['nombre']}');
      }
      return response;
    });
  }

  /// Obtiene unidades por tipo
  Future<List<Map<String, dynamic>>> getUnidadesByTipo(String tipo) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo unidades por tipo: $tipo');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .eq('tipo', tipo)
          .eq('activo', true)
          .order('nombre');

      AppLogger.database('✅ ${response.length} unidades obtenidas');
      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Crea una nueva unidad de medida
  Future<Map<String, dynamic>> createUnidad(
    Map<String, dynamic> data,
  ) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Creando unidad: ${data['nombre']}');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .insert(data)
          .select()
          .single();

      AppLogger.database('✅ Unidad creada: ${response['id']}');
      return response;
    });
  }

  /// Actualiza una unidad de medida existente
  Future<Map<String, dynamic>> updateUnidad({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Actualizando unidad: $id');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .update(data)
          .eq('id', id)
          .select()
          .single();

      AppLogger.database('✅ Unidad actualizada: ${response['nombre']}');
      return response;
    });
  }

  /// Elimina una unidad de medida (soft delete)
  Future<void> deleteUnidad(String id) async {
    await SupabaseDataSource.softDelete(_tableName, id);
    AppLogger.database('✅ Unidad eliminada: $id');
  }
}
