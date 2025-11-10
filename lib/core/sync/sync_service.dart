import 'package:flutter_management_system/core/sync/sync_status.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sync_manager.dart';
import 'sync_queue.dart';
import 'sync_item.dart';
import '../network/network_info.dart';
import '../../data/datasources/local/database/app_database.dart';

class SyncService {
  static SyncService? _instance;
  late final SyncManager _syncManager;

  SyncService._internal(
    AppDatabase database,
    SharedPreferences prefs,
    NetworkInfo networkInfo,
  ) {
    final queue = SyncQueue(prefs);
    _syncManager = SyncManager(
      localDb: database,
      syncQueue: queue,
      networkInfo: networkInfo,
    );
  }

  static Future<SyncService> initialize({
    required AppDatabase database,
    required SharedPreferences prefs,
    required NetworkInfo networkInfo,
  }) async {
    _instance ??= SyncService._internal(database, prefs, networkInfo);
    return _instance!;
  }

  static SyncService get instance {
    if (_instance == null) {
      throw Exception('SyncService no ha sido inicializado');
    }
    return _instance!;
  }

  // Exponer métodos del SyncManager
  Future<void> syncAll() => _syncManager.syncAll();

  Future<void> queueProductoChange({
    required String productoId,
    required SyncOperation operation,
    required Map<String, dynamic> data,
  }) async {
    await _syncManager.queueChange(
      entityId: productoId,
      entityType: SyncEntityType.producto,
      operation: operation,
      data: data,
    );
  }

  Future<void> queueInventarioChange({
    required String inventarioId,
    required SyncOperation operation,
    required Map<String, dynamic> data,
  }) async {
    await _syncManager.queueChange(
      entityId: inventarioId,
      entityType: SyncEntityType.inventario,
      operation: operation,
      data: data,
    );
  }

  Future<void> queueMovimientoChange({
    required String movimientoId,
    required SyncOperation operation,
    required Map<String, dynamic> data,
  }) async {
    await _syncManager.queueChange(
      entityId: movimientoId,
      entityType: SyncEntityType.movimiento,
      operation: operation,
      data: data,
    );
  }

  Stream<SyncStatus> get syncStatusStream => _syncManager.syncStatusStream;
  SyncStatus get currentStatus => _syncManager.currentStatus;

  void dispose() => _syncManager.dispose();
}
