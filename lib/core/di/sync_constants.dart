// Constantes de sincronización
class SyncConstants {
  // Estados de sincronización
  static const String syncStatusPending = 'pending';
  static const String syncStatusSyncing = 'syncing';
  static const String syncStatusSynced = 'synced';
  static const String syncStatusError = 'error';
  static const String syncStatusConflict = 'conflict';
  
  // Tipos de operación
  static const String operationCreate = 'create';
  static const String operationUpdate = 'update';
  static const String operationDelete = 'delete';
  
  // Prioridades de sincronización
  static const int priorityHigh = 1;
  static const int priorityMedium = 2;
  static const int priorityLow = 3;
  
  // Configuración
  static const int maxRetries = 3;
  static const Duration syncInterval = Duration(minutes: 5);
  static const Duration conflictTimeout = Duration(hours: 24);
  
  // Estrategias de resolución de conflictos
  static const String conflictStrategyServerWins = 'server_wins';
  static const String conflictStrategyClientWins = 'client_wins';
  static const String conflictStrategyManual = 'manual';

  // Sincronización periódica
  static const Duration periodicSyncInterval = Duration(minutes: 15);
}
