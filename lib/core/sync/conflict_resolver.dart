// Resolutor de conflictos de sincronización

enum ConflictResolutionStrategy {
  serverWins,
  clientWins,
  manual,
  lastWriteWins,
}

class SyncConflict {
  final String entityType;
  final String entityId;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> remoteData;
  final DateTime localTimestamp;
  final DateTime remoteTimestamp;

  SyncConflict({
    required this.entityType,
    required this.entityId,
    required this.localData,
    required this.remoteData,
    required this.localTimestamp,
    required this.remoteTimestamp,
  });
}

class ConflictResolver {
  final ConflictResolutionStrategy defaultStrategy;

  ConflictResolver({
    this.defaultStrategy = ConflictResolutionStrategy.lastWriteWins,
  });

  /// Resuelve un conflicto usando la estrategia especificada
  Map<String, dynamic> resolve(
    SyncConflict conflict, {
    ConflictResolutionStrategy? strategy,
  }) {
    final resolutionStrategy = strategy ?? defaultStrategy;

    switch (resolutionStrategy) {
      case ConflictResolutionStrategy.serverWins:
        return conflict.remoteData;

      case ConflictResolutionStrategy.clientWins:
        return conflict.localData;

      case ConflictResolutionStrategy.lastWriteWins:
        return conflict.localTimestamp.isAfter(conflict.remoteTimestamp)
            ? conflict.localData
            : conflict.remoteData;

      case ConflictResolutionStrategy.manual:
        throw Exception('Manual conflict resolution required');
    }
  }

  /// Detecta conflictos entre datos locales y remotos
  bool hasConflict(
    Map<String, dynamic> localData,
    Map<String, dynamic> remoteData,
    DateTime localTimestamp,
    DateTime remoteTimestamp,
  ) {
    // Si las marcas de tiempo son diferentes, hay un posible conflicto
    if (localTimestamp != remoteTimestamp) {
      // Comparar datos para confirmar el conflicto
      return !_areDataEqual(localData, remoteData);
    }
    return false;
  }

  /// Compara dos mapas de datos
  bool _areDataEqual(Map<String, dynamic> data1, Map<String, dynamic> data2) {
    if (data1.length != data2.length) return false;

    for (final key in data1.keys) {
      if (!data2.containsKey(key) || data1[key] != data2[key]) {
        return false;
      }
    }
    return true;
  }

  /// Crea un conflicto para resolución manual
  SyncConflict createConflict({
    required String entityType,
    required String entityId,
    required Map<String, dynamic> localData,
    required Map<String, dynamic> remoteData,
    required DateTime localTimestamp,
    required DateTime remoteTimestamp,
  }) {
    return SyncConflict(
      entityType: entityType,
      entityId: entityId,
      localData: localData,
      remoteData: remoteData,
      localTimestamp: localTimestamp,
      remoteTimestamp: remoteTimestamp,
    );
  }
}
