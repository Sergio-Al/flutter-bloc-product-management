import 'package:logger/logger.dart';
import 'sync_item.dart';
import 'sync_status.dart';

class SyncLogger {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  void logSyncStart(int itemCount) {
    _logger.i('🔄 Iniciando sincronización de $itemCount items');
  }

  void logSyncSuccess(String itemId, SyncEntityType entityType) {
    _logger.d('✅ Sincronizado: $entityType - $itemId');
  }

  void logSyncError(String itemId, SyncEntityType entityType, String error) {
    _logger.e('❌ Error en sincronización: $entityType - $itemId: $error');
  }

  void logConflict(String itemId, SyncEntityType entityType) {
    _logger.w('⚠️ Conflicto detectado: $entityType - $itemId');
  }

  void logStatusChange(SyncStatus status) {
    switch (status.state) {
      case SyncState.idle:
        _logger.d('⏸️ Sincronización en espera');
        break;
      case SyncState.syncing:
        _logger.i('🔄 Sincronizando ${status.pendingItems} items...');
        break;
      case SyncState.success:
        _logger.i('✅ Sincronización completada exitosamente');
        break;
      case SyncState.error:
        _logger.e('❌ Error en sincronización: ${status.message}');
        break;
      case SyncState.conflict:
        _logger.w('⚠️ ${status.conflictItems} conflictos encontrados');
        break;
    }
  }

  void logNetworkStatus(bool isConnected) {
    if (isConnected) {
      _logger.i('🌐 Conexión a internet disponible');
    } else {
      _logger.w('📡 Sin conexión a internet - modo offline');
    }
  }
}
