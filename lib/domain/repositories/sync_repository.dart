import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/sync/sync_status.dart';

/// Sync repository interface
/// Defines the contract for offline-first synchronization operations
abstract class SyncRepository {
  /// Sync all entities from local to remote
  Future<Either<Failure, SyncStatus>> syncAll();

  /// Sync specific entity type
  Future<Either<Failure, SyncStatus>> syncEntity(String entityType);

  /// Push local changes to remote (Supabase)
  Future<Either<Failure, int>> pushChanges();

  /// Pull remote changes to local (Drift)
  Future<Either<Failure, int>> pullChanges();

  /// Get sync status for all entities
  Future<Either<Failure, Map<String, SyncStatus>>> getSyncStatus();

  /// Get last sync timestamp
  Future<Either<Failure, DateTime?>> getLastSyncTime();

  /// Check if there are pending sync items
  Future<Either<Failure, bool>> hasPendingSync();

  /// Get count of pending sync items
  Future<Either<Failure, int>> getPendingSyncCount();

  /// Resolve sync conflicts
  Future<Either<Failure, int>> resolveConflicts();

  /// Clear all local data (dangerous, for logout/reset)
  Future<Either<Failure, Unit>> clearLocalData();

  /// Force full sync (clear and re-download everything)
  Future<Either<Failure, SyncStatus>> forceFullSync();

  /// Get sync errors/failures
  Future<Either<Failure, List<String>>> getSyncErrors();

  /// Retry failed sync items
  Future<Either<Failure, int>> retryFailedSync();

  /// Enable/disable auto-sync
  Future<Either<Failure, Unit>> setAutoSync(bool enabled);

  /// Check if auto-sync is enabled
  Future<Either<Failure, bool>> isAutoSyncEnabled();
}
