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
