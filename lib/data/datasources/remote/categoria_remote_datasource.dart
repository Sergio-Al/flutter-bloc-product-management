import 'supabase_datasource.dart';
import '../../../core/utils/logger.dart';

/// Datasource remoto para operaciones de categorías con Supabase
class CategoriaRemoteDataSource extends SupabaseDataSource {
  static const String _tableName = 'categorias';

  /// Obtiene todas las categorías activas
  Future<List<Map<String, dynamic>>> getCategoriasActivas() async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo categorías activas desde Supabase');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .order('nombre');

      AppLogger.database('✅ ${response.length} categorías obtenidas');
      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Obtiene todas las categorías
  Future<List<Map<String, dynamic>>> getCategorias() async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo todas las categorías desde Supabase');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .order('nombre');

      AppLogger.database('✅ ${response.length} categorías obtenidas');
      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Obtiene una categoría por ID
  Future<Map<String, dynamic>?> getCategoriaById(String id) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo categoría: $id');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .eq('id', id)
          .maybeSingle();

      if (response != null) {
        AppLogger.database('✅ Categoría obtenida: ${response['nombre']}');
      }
      return response;
    });
  }

  /// Crea una nueva categoría
  Future<Map<String, dynamic>> createCategoria(
    Map<String, dynamic> data,
  ) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Creando categoría: ${data['nombre']}');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .insert(data)
          .select()
          .single();

      AppLogger.database('✅ Categoría creada: ${response['id']}');
      return response;
    });
  }

  /// Actualiza una categoría existente
  Future<Map<String, dynamic>> updateCategoria({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Actualizando categoría: $id');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .update(data)
          .eq('id', id)
          .select()
          .single();

      AppLogger.database('✅ Categoría actualizada: ${response['nombre']}');
      return response;
    });
  }

  /// Elimina una categoría (soft delete)
  Future<void> deleteCategoria(String id) async {
    await SupabaseDataSource.softDelete(_tableName, id);
    AppLogger.database('✅ Categoría eliminada: $id');
  }
}
