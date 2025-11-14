import 'package:equatable/equatable.dart';
import '../../../core/sync/sync_status.dart' as core;

abstract class SyncBlocState extends Equatable {
  const SyncBlocState();
}

class SyncIdle extends SyncBlocState {
  const SyncIdle();

  @override
  List<Object?> get props => [];
}

class SyncInProgress extends SyncBlocState {
  final int pendingItems;
  final double progress;

  const SyncInProgress({required this.pendingItems, this.progress = 0.0});

  @override
  List<Object?> get props => [pendingItems, progress];
}

class SyncCompleted extends SyncBlocState {
  final DateTime lastSync;

  const SyncCompleted({required this.lastSync});

  @override
  List<Object> get props => [lastSync];
}

class SyncFailed extends SyncBlocState {
  final String message;

  const SyncFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class SyncConflictDetected extends SyncBlocState {
  final int conflictCount;

  const SyncConflictDetected({required this.conflictCount});

  @override
  List<Object> get props => [conflictCount];
}

// Extension to map core.SyncStatus → SyncBlocState
extension SyncStatusMapping on core.SyncStatus {
  SyncBlocState toBlocState() {
    switch (state) {
      case core.SyncState.idle:
        return const SyncIdle();
      case core.SyncState.syncing:
        return SyncInProgress(
          pendingItems: pendingItems,
          progress: pendingItems > 0 ? 1.0 - (pendingItems / 10.0) : 0.0,
        );
      case core.SyncState.success:
        return SyncCompleted(lastSync: lastSync ?? DateTime.now());
      case core.SyncState.error:
        return SyncFailed(message: message ?? 'Unknown error');
      case core.SyncState.conflict:
        return SyncConflictDetected(conflictCount: conflictItems);
    }
  }
}
