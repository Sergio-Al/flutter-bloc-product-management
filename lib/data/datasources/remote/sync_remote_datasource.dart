import 'supabase_datasource.dart';
import '../../../core/utils/logger.dart';
import '../../../core/sync/sync_status.dart';

/// Datasource remoto para operaciones de sincronización con Supabase
class SyncRemoteDataSource extends SupabaseDataSource {
  /// Obtiene todos los cambios desde una fecha específica
  ///
  /// [lastSync] - Última fecha de sincronización
  /// [tables] - Tablas específicas a sincronizar (opcional)
  /// Returns: Map con los cambios por tabla
  Future<Map<String, List<Map<String, dynamic>>>> pullChanges({
    required DateTime lastSync,
    List<String>? tables,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.sync('📥 Obteniendo cambios desde: $lastSync');

      final tablesToSync = tables ?? [
        'productos',
        'inventarios',
        'movimientos',
        'tiendas',
        'almacenes',
        'proveedores',
        'categorias',
        'lotes',
        'usuarios',
      ];

      final Map<String, List<Map<String, dynamic>>> changes = {};

      for (final table in tablesToSync) {
        try {
          final response = await SupabaseDataSource.client
              .from(table)
              .select('*')
              .gt('updated_at', lastSync.toIso8601String())
              .order('updated_at');

          changes[table] = List<Map<String, dynamic>>.from(response);

          AppLogger.sync('📥 $table: ${changes[table]!.length} cambios');
        } catch (e) {
          AppLogger.error('Error al sincronizar tabla $table', e);
          changes[table] = [];
        }
      }

      final totalChanges = changes.values.fold<int>(
        0,
        (sum, list) => sum + list.length,
      );

      AppLogger.sync('✅ Total de cambios obtenidos: $totalChanges');
      return changes;
    });
  }

  /// Envía cambios locales al servidor
  ///
  /// [changes] - Map con los cambios por tabla
  /// Returns: Map con los resultados de la sincronización
  Future<Map<String, SyncResult>> pushChanges(
    Map<String, List<Map<String, dynamic>>> changes,
  ) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.sync('📤 Enviando cambios al servidor');

      final Map<String, SyncResult> results = {};

      for (final entry in changes.entries) {
        final table = entry.key;
        final records = entry.value;

        try {
          int success = 0;
          int failed = 0;
          final List<String> errors = [];

          for (final record in records) {
            try {
              // Determinar si es insert o update basado en la presencia de sync_id
              final syncId = record['sync_id'];

              if (syncId != null) {
                // Es un registro local que necesita ser insertado
                await SupabaseDataSource.client.from(table).insert(record);
              } else {
                // Es una actualización
                final id = record['id'];
                await SupabaseDataSource.client
                    .from(table)
                    .update(record)
                    .eq('id', id);
              }

              success++;
            } catch (e) {
              failed++;
              errors.add(e.toString());
              AppLogger.error('Error al sincronizar registro de $table', e);
            }
          }

          results[table] = SyncResult(
            success: success,
            failed: failed,
            errors: errors,
          );

          AppLogger.sync('📤 $table: $success éxitos, $failed fallos');
        } catch (e) {
          AppLogger.error('Error al sincronizar tabla $table', e);
          results[table] = SyncResult(
            success: 0,
            failed: records.length,
            errors: [e.toString()],
          );
        }
      }

      AppLogger.sync('✅ Sincronización completada');
      return results;
    });
  }

  /// Detecta conflictos de sincronización
  ///
  /// [localRecords] - Registros locales a verificar
  /// [table] - Nombre de la tabla
  /// Returns: Lista de conflictos detectados
  Future<List<SyncConflict>> detectConflicts({
    required String table,
    required List<Map<String, dynamic>> localRecords,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.sync('🔍 Detectando conflictos en tabla: $table');

      final List<SyncConflict> conflicts = [];

      for (final localRecord in localRecords) {
        try {
          final id = localRecord['id'];
          final localUpdatedAt = DateTime.parse(localRecord['updated_at']);

          // Obtener la versión del servidor
          final serverRecord = await SupabaseDataSource.client
              .from(table)
              .select('*')
              .eq('id', id)
              .maybeSingle();

          if (serverRecord != null) {
            final serverUpdatedAt = DateTime.parse(serverRecord['updated_at']);

            // Si la versión del servidor es más reciente, hay conflicto
            if (serverUpdatedAt.isAfter(localUpdatedAt)) {
              conflicts.add(SyncConflict(
                id: id,
                table: table,
                localRecord: localRecord,
                serverRecord: serverRecord,
                localTimestamp: localUpdatedAt,
                serverTimestamp: serverUpdatedAt,
              ));

              AppLogger.warning('⚠️ Conflicto detectado en $table: $id');
            }
          }
        } catch (e) {
          AppLogger.error('Error al detectar conflicto', e);
        }
      }

      AppLogger.sync('🔍 ${conflicts.length} conflictos detectados');
      return conflicts;
    });
  }

  /// Resuelve un conflicto de sincronización
  ///
  /// [conflict] - Conflicto a resolver
  /// [strategy] - Estrategia de resolución ('server_wins', 'local_wins', 'merge')
  Future<Map<String, dynamic>> resolveConflict({
    required SyncConflict conflict,
    required ConflictResolutionStrategy strategy,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.sync('🔧 Resolviendo conflicto: ${conflict.id}');

      Map<String, dynamic> resolvedRecord;

      switch (strategy) {
        case ConflictResolutionStrategy.serverWins:
          resolvedRecord = conflict.serverRecord;
          AppLogger.sync('✅ Conflicto resuelto: servidor gana');
          break;

        case ConflictResolutionStrategy.localWins:
          resolvedRecord = conflict.localRecord;
          // Actualizar en el servidor
          await SupabaseDataSource.client
              .from(conflict.table)
              .update(resolvedRecord)
              .eq('id', conflict.id);
          AppLogger.sync('✅ Conflicto resuelto: local gana');
          break;

        case ConflictResolutionStrategy.merge:
          // Merge simple: tomar campos más recientes
          resolvedRecord = _mergeRecords(
            conflict.localRecord,
            conflict.serverRecord,
          );
          await SupabaseDataSource.client
              .from(conflict.table)
              .update(resolvedRecord)
              .eq('id', conflict.id);
          AppLogger.sync('✅ Conflicto resuelto: merge');
          break;

        case ConflictResolutionStrategy.manual:
          // Requiere intervención manual
          resolvedRecord = conflict.serverRecord;
          AppLogger.warning('⚠️ Conflicto requiere resolución manual');
          break;
      }

      return resolvedRecord;
    });
  }

  /// Obtiene el estado de sincronización del servidor
  Future<ServerSyncStatus> getServerSyncStatus() async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.sync('📊 Obteniendo estado de sincronización del servidor');

      final serverTime = await SupabaseDataSource.getServerTime();

      // Obtener contadores de registros pendientes
      final pendingCounts = <String, int>{};

      for (final table in ['productos', 'inventarios', 'movimientos']) {
        final count = await SupabaseDataSource.getTableCount(table);
        pendingCounts[table] = count;
      }

      return ServerSyncStatus(
        serverTime: serverTime,
        isOnline: true,
        pendingCounts: pendingCounts,
      );
    });
  }

  /// Verifica si hay cambios pendientes en el servidor
  Future<bool> hasPendingChanges({
    required DateTime lastSync,
    required List<String> tables,
  }) async {
    try {
      for (final table in tables) {
        final response = await SupabaseDataSource.client
            .from(table)
            .select('id')
            .gt('updated_at', lastSync.toIso8601String())
            .limit(1);

        if (response.isNotEmpty) {
          return true;
        }
      }

      return false;
    } catch (e) {
      AppLogger.error('Error al verificar cambios pendientes', e);
      return false;
    }
  }

  /// Sincroniza una tabla específica
  Future<SyncResult> syncTable({
    required String table,
    required DateTime lastSync,
    List<Map<String, dynamic>>? localChanges,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.sync('🔄 Sincronizando tabla: $table');

      int success = 0;
      int failed = 0;
      final List<String> errors = [];

      try {
        // 1. Pull: Obtener cambios del servidor
        final serverChanges = await SupabaseDataSource.client
            .from(table)
            .select('*')
            .gt('updated_at', lastSync.toIso8601String());

        AppLogger.sync('📥 $table: ${serverChanges.length} cambios del servidor');

        // 2. Push: Enviar cambios locales si existen
        if (localChanges != null && localChanges.isNotEmpty) {
          for (final record in localChanges) {
            try {
              await SupabaseDataSource.client
                  .from(table)
                  .upsert(record, onConflict: 'id');
              success++;
            } catch (e) {
              failed++;
              errors.add(e.toString());
            }
          }

          AppLogger.sync('📤 $table: $success cambios enviados');
        }

        return SyncResult(
          success: success + serverChanges.length,
          failed: failed,
          errors: errors,
        );
      } catch (e) {
        AppLogger.error('Error al sincronizar tabla $table', e);
        return SyncResult(
          success: 0,
          failed: localChanges?.length ?? 0,
          errors: [e.toString()],
        );
      }
    });
  }

  /// Realiza un merge simple de dos registros
  Map<String, dynamic> _mergeRecords(
    Map<String, dynamic> local,
    Map<String, dynamic> server,
  ) {
    final merged = Map<String, dynamic>.from(server);

    // Campos que siempre se toman del servidor
    final serverOnlyFields = ['id', 'created_at', 'sync_id'];

    // Campos numéricos se suman
    final numericFields = ['cantidad_actual', 'cantidad_reservada'];

    for (final entry in local.entries) {
      final key = entry.key;
      final localValue = entry.value;

      if (serverOnlyFields.contains(key)) {
        continue;
      }

      if (numericFields.contains(key) && localValue is num) {
        final serverValue = server[key] as num?;
        if (serverValue != null) {
          merged[key] = serverValue + localValue;
        }
      } else if (localValue != null && localValue != server[key]) {
        // Tomar el valor local si es diferente y no nulo
        merged[key] = localValue;
      }
    }

    return merged;
  }

  /// Registra una auditoría de sincronización
  Future<void> logSyncAudit({
    required String action,
    required String table,
    String? recordId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await SupabaseDataSource.client.from('auditorias').insert({
        'usuario_id': SupabaseDataSource.currentUserId,
        'tabla_afectada': table,
        'accion': action,
        'datos_nuevos': metadata,
        'created_at': DateTime.now().toIso8601String(),
      });

      AppLogger.sync('📝 Auditoría registrada: $action en $table');
    } catch (e) {
      AppLogger.error('Error al registrar auditoría', e);
    }
  }
}
