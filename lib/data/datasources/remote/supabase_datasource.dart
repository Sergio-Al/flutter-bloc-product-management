import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/errors/exceptions.dart' as app_exceptions;
import '../../../core/utils/logger.dart';

/// Datasource base para todas las operaciones con Supabase
/// Proporciona acceso al cliente de Supabase y métodos comunes
abstract class SupabaseDataSource {
  /// Cliente de Supabase singleton
  static SupabaseClient get client => Supabase.instance.client;

  /// Usuario actual autenticado
  static User? get currentUser => client.auth.currentUser;

  /// ID del usuario actual
  static String? get currentUserId => currentUser?.id;

  /// Email del usuario actual
  static String? get currentUserEmail => currentUser?.email;

  /// Verifica si hay un usuario autenticado
  static bool get isAuthenticated => currentUser != null;

  /// Session actual
  static Session? get currentSession => client.auth.currentSession;

  /// Maneja errores de Supabase y los convierte en excepciones personalizadas
  static Never handleError(dynamic error, [StackTrace? stackTrace]) {
    AppLogger.error('Error en Supabase', error, stackTrace);

    if (error is PostgrestException) {
      throw app_exceptions.ServerException(
        error.message,
        code: error.code,
      );
    }

    if (error is AuthException) {
      throw app_exceptions.AuthException(
        error.message,
        code: error.statusCode,
      );
    }

    if (error is StorageException) {
      throw app_exceptions.ServerException(
        error.message,
        code: error.statusCode,
      );
    }

    throw app_exceptions.ServerException(error.toString());
  }

  /// Ejecuta una query de manera segura con manejo de errores
  static Future<T> executeQuery<T>(Future<T> Function() query) async {
    try {
      return await query();
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
    }
  }

  /// Construye filtros de sincronización para obtener solo datos actualizados
  static PostgrestFilterBuilder<PostgrestList> applySyncFilters(
    PostgrestFilterBuilder<PostgrestList> query,
    DateTime? lastSync,
  ) {
    if (lastSync != null) {
      return query.gt('updated_at', lastSync.toIso8601String());
    }
    return query;
  }

  /// Construye filtros de paginación
  static PostgrestFilterBuilder<PostgrestList> applyPagination(
    PostgrestFilterBuilder<PostgrestList> query, {
    int? limit,
    int? offset,
  }) {
    if (limit != null) {
      query = query.limit(limit) as PostgrestFilterBuilder<PostgrestList>;
    }
    if (offset != null) {
      query = query.range(offset, offset + (limit ?? 10) - 1)
          as PostgrestFilterBuilder<PostgrestList>;
    }
    return query;
  }

  /// Construye filtros de ordenamiento
  static PostgrestFilterBuilder<PostgrestList> applyOrdering(
    PostgrestFilterBuilder<PostgrestList> query, {
    String column = 'created_at',
    bool ascending = false,
  }) {
    return query.order(column, ascending: ascending)
        as PostgrestFilterBuilder<PostgrestList>;
  }

  /// Construye filtros de búsqueda
  static PostgrestFilterBuilder<PostgrestList> applySearch(
    PostgrestFilterBuilder<PostgrestList> query, {
    required String column,
    required String searchTerm,
  }) {
    return query.ilike(column, '%$searchTerm%');
  }

  /// Filtra solo registros activos (no eliminados)
  static PostgrestFilterBuilder<PostgrestList> applyActiveFilter(
    PostgrestFilterBuilder<PostgrestList> query,
  ) {
    return query.isFilter('deleted_at', null);
  }

  /// Obtiene el timestamp actual del servidor
  static Future<DateTime> getServerTime() async {
    try {
      final response = await client
          .from('usuarios')
          .select('created_at')
          .limit(1)
          .single();

      if (response['created_at'] != null) {
        return DateTime.parse(response['created_at']);
      }

      return DateTime.now();
    } catch (e) {
      AppLogger.warning('No se pudo obtener tiempo del servidor, usando local');
      return DateTime.now();
    }
  }

  /// Verifica la conexión con Supabase
  static Future<bool> checkConnection() async {
    try {
      await client.from('usuarios').select('id').limit(1);
      return true;
    } catch (e) {
      AppLogger.error('Error al verificar conexión con Supabase', e);
      return false;
    }
  }

  /// Obtiene estadísticas de una tabla
  static Future<int> getTableCount(String tableName) async {
    try {
      final response = await client
          .from(tableName)
          .select('id')
          .count(CountOption.exact);

      // Supabase devuelve la lista, el count está en otra propiedad
      // Por ahora, contamos manualmente
      return (response as List).length;
    } catch (e) {
      AppLogger.error('Error al obtener conteo de $tableName', e);
      return 0;
    }
  }

  /// Realiza una operación de soft delete
  static Future<void> softDelete(
    String tableName,
    String id,
  ) async {
    await executeQuery(() async {
      await client.from(tableName).update({
        'deleted_at': DateTime.now().toIso8601String(),
        'activo': false,
      }).eq('id', id);
    });
  }

  /// Restaura un registro eliminado (soft delete)
  static Future<void> restore(
    String tableName,
    String id,
  ) async {
    await executeQuery(() async {
      await client.from(tableName).update({
        'deleted_at': null,
        'activo': true,
      }).eq('id', id);
    });
  }

  /// Realiza una operación de hard delete
  static Future<void> hardDelete(
    String tableName,
    String id,
  ) async {
    await executeQuery(() async {
      await client.from(tableName).delete().eq('id', id);
    });
  }

  /// Sube una imagen a Supabase Storage
  static Future<String> uploadImage({
    required String bucket,
    required String path,
    required File file,
  }) async {
    try {
      await client.storage.from(bucket).upload(
            path,
            file,
          );

      final publicUrl = client.storage.from(bucket).getPublicUrl(path);

      AppLogger.info('✅ Imagen subida: $publicUrl');
      return publicUrl;
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
    }
  }

  /// Elimina una imagen de Supabase Storage
  static Future<void> deleteImage({
    required String bucket,
    required String path,
  }) async {
    await executeQuery(() async {
      await client.storage.from(bucket).remove([path]);
    });
  }

  /// Obtiene la URL pública de una imagen
  static String getPublicUrl({
    required String bucket,
    required String path,
  }) {
    return client.storage.from(bucket).getPublicUrl(path);
  }
}
