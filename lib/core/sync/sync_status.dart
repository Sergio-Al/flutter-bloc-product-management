// Estado y gestión del estado de sincronización

enum SyncState {
  idle,
  syncing,
  success,
  error,
  conflict,
}

class SyncStatus {
  final SyncState state;
  final DateTime? lastSyncTime;
  final String? errorMessage;
  final int pendingChanges;
  final int conflictsCount;

  const SyncStatus({
    required this.state,
    this.lastSyncTime,
    this.errorMessage,
    this.pendingChanges = 0,
    this.conflictsCount = 0,
  });

  factory SyncStatus.idle() {
    return const SyncStatus(state: SyncState.idle);
  }

  factory SyncStatus.syncing({int pendingChanges = 0}) {
    return SyncStatus(
      state: SyncState.syncing,
      pendingChanges: pendingChanges,
    );
  }

  factory SyncStatus.success({
    required DateTime lastSyncTime,
    int pendingChanges = 0,
  }) {
    return SyncStatus(
      state: SyncState.success,
      lastSyncTime: lastSyncTime,
      pendingChanges: pendingChanges,
    );
  }

  factory SyncStatus.error({
    required String errorMessage,
    int pendingChanges = 0,
  }) {
    return SyncStatus(
      state: SyncState.error,
      errorMessage: errorMessage,
      pendingChanges: pendingChanges,
    );
  }

  factory SyncStatus.conflict({
    required int conflictsCount,
    int pendingChanges = 0,
  }) {
    return SyncStatus(
      state: SyncState.conflict,
      conflictsCount: conflictsCount,
      pendingChanges: pendingChanges,
    );
  }

  bool get isIdle => state == SyncState.idle;
  bool get isSyncing => state == SyncState.syncing;
  bool get isSuccess => state == SyncState.success;
  bool get isError => state == SyncState.error;
  bool get hasConflicts => state == SyncState.conflict;
  bool get hasPendingChanges => pendingChanges > 0;

  SyncStatus copyWith({
    SyncState? state,
    DateTime? lastSyncTime,
    String? errorMessage,
    int? pendingChanges,
    int? conflictsCount,
  }) {
    return SyncStatus(
      state: state ?? this.state,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      errorMessage: errorMessage ?? this.errorMessage,
      pendingChanges: pendingChanges ?? this.pendingChanges,
      conflictsCount: conflictsCount ?? this.conflictsCount,
    );
  }
}

/// Resultado de una operación de sincronización
class SyncResult {
  final int success;
  final int failed;
  final List<String> errors;

  const SyncResult({
    required this.success,
    required this.failed,
    required this.errors,
  });

  bool get hasErrors => failed > 0;
  bool get isSuccess => failed == 0;
  int get total => success + failed;
}

/// Conflicto de sincronización
class SyncConflict {
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
}

/// Estrategia de resolución de conflictos
enum ConflictResolutionStrategy {
  /// El servidor gana - usar datos del servidor
  serverWins,

  /// Local gana - usar datos locales
  localWins,

  /// Merge - combinar ambos
  merge,

  /// Manual - requiere intervención del usuario
  manual,
}

/// Estado de sincronización del servidor
class ServerSyncStatus {
  final DateTime serverTime;
  final bool isOnline;
  final Map<String, int> pendingCounts;

  const ServerSyncStatus({
    required this.serverTime,
    required this.isOnline,
    required this.pendingCounts,
  });

  int get totalPending {
    return pendingCounts.values.fold<int>(0, (sum, count) => sum + count);
  }
}
