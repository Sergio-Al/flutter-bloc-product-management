// lib/core/sync/sync_status.dart
import 'package:equatable/equatable.dart';

// ============================================
// ENUMS
// ============================================

enum SyncState {
  idle,
  syncing,
  success,
  error,
  conflict,
}

/// Estrategia de resolución de conflictos
enum ConflictResolutionStrategy {
  serverWins,  // El servidor tiene la razón
  localWins,   // El local tiene la razón
  merge,       // Mezclar ambos
  manual,      // Requiere intervención manual
}

// ============================================
// SYNC STATUS
// ============================================

class SyncStatus extends Equatable {
  final SyncState state;
  final String? message;
  final DateTime? lastSync;
  final int pendingItems;
  final int conflictItems;

  const SyncStatus({
    required this.state,
    this.message,
    this.lastSync,
    this.pendingItems = 0,
    this.conflictItems = 0,
  });

  factory SyncStatus.idle() => const SyncStatus(state: SyncState.idle);

  factory SyncStatus.syncing({int pendingItems = 0}) => SyncStatus(
        state: SyncState.syncing,
        message: 'Sincronizando...',
        pendingItems: pendingItems,
      );

  factory SyncStatus.success({DateTime? lastSync}) => SyncStatus(
        state: SyncState.success,
        message: 'Sincronización completada',
        lastSync: lastSync ?? DateTime.now(),
      );

  factory SyncStatus.error(String message) => SyncStatus(
        state: SyncState.error,
        message: message,
      );

  factory SyncStatus.conflict({required int conflictItems}) => SyncStatus(
        state: SyncState.conflict,
        message: 'Conflictos detectados',
        conflictItems: conflictItems,
      );

  SyncStatus copyWith({
    SyncState? state,
    String? message,
    DateTime? lastSync,
    int? pendingItems,
    int? conflictItems,
  }) {
    return SyncStatus(
      state: state ?? this.state,
      message: message ?? this.message,
      lastSync: lastSync ?? this.lastSync,
      pendingItems: pendingItems ?? this.pendingItems,
      conflictItems: conflictItems ?? this.conflictItems,
    );
  }

  @override
  List<Object?> get props => [state, message, lastSync, pendingItems, conflictItems];
}

// ============================================
// SYNC RESULT
// ============================================

/// Resultado de una operación de sincronización
class SyncResult extends Equatable {
  final int success;
  final int failed;
  final List<String> errors;

  const SyncResult({
    required this.success,
    required this.failed,
    required this.errors,
  });

  factory SyncResult.empty() => const SyncResult(
        success: 0,
        failed: 0,
        errors: [],
      );

  /// Indica si la sincronización fue exitosa (sin fallos)
  bool get isSuccess => failed == 0;

  /// Total de operaciones
  int get total => success + failed;

  /// Porcentaje de éxito
  double get successRate => total == 0 ? 0.0 : (success / total) * 100;

  @override
  List<Object?> get props => [success, failed, errors];

  @override
  String toString() {
    return 'SyncResult(success: $success, failed: $failed, errors: ${errors.length})';
  }
}

// ============================================
// SYNC CONFLICT
// ============================================

/// Representa un conflicto de sincronización entre local y servidor
class SyncConflict extends Equatable {
  final String id;
  final String table;
  final Map<String, dynamic> localRecord;
  final Map<String, dynamic> serverRecord;
  final DateTime localTimestamp;
  final DateTime serverTimestamp;

  const SyncConflict({
    required this.id,
    required this.table,
    required this.localRecord,
    required this.serverRecord,
    required this.localTimestamp,
    required this.serverTimestamp,
  });

  /// Indica si el servidor tiene la versión más reciente
  bool get serverIsNewer => serverTimestamp.isAfter(localTimestamp);

  /// Indica si el local tiene la versión más reciente
  bool get localIsNewer => localTimestamp.isAfter(serverTimestamp);

  /// Diferencia de tiempo entre versiones
  Duration get timeDifference => serverTimestamp.difference(localTimestamp).abs();

  /// Obtiene los campos que difieren entre local y servidor
  Map<String, dynamic> getDifferences() {
    final differences = <String, dynamic>{};
    
    for (final key in localRecord.keys) {
      if (localRecord[key] != serverRecord[key]) {
        differences[key] = {
          'local': localRecord[key],
          'server': serverRecord[key],
        };
      }
    }
    
    return differences;
  }

  @override
  List<Object?> get props => [
        id,
        table,
        localRecord,
        serverRecord,
        localTimestamp,
        serverTimestamp,
      ];

  @override
  String toString() {
    return 'SyncConflict(id: $id, table: $table, timeDiff: ${timeDifference.inSeconds}s)';
  }
}

// ============================================
// SERVER SYNC STATUS
// ============================================

/// Estado de sincronización del servidor
class ServerSyncStatus extends Equatable {
  final DateTime serverTime;
  final bool isOnline;
  final Map<String, int> pendingCounts;

  const ServerSyncStatus({
    required this.serverTime,
    required this.isOnline,
    required this.pendingCounts,
  });

  /// Total de registros pendientes en el servidor
  int get totalPending => pendingCounts.values.fold(0, (sum, count) => sum + count);

  /// Indica si hay cambios pendientes
  bool get hasPendingChanges => totalPending > 0;

  @override
  List<Object?> get props => [serverTime, isOnline, pendingCounts];

  @override
  String toString() {
    return 'ServerSyncStatus(online: $isOnline, pending: $totalPending)';
  }
}
