import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import '../errors/failures.dart';
import '../network/network_info.dart';
import 'sync_status.dart';
import 'sync_queue.dart';
import 'sync_item.dart';
import 'conflict_resolver.dart' hide SyncConflict;
import '../../data/datasources/local/database/app_database.dart';

/// SyncManager - Coordina la sincronización offline-first
/// 
/// TODO: Implementaciones pendientes:
/// 1. Agregar remote datasources como dependencias (ProductoRemoteDatasource, etc.)
/// 2. Implementar _syncProducto, _syncInventario, _syncMovimiento con datasources reales
/// 3. Implementar _pullFromServer para traer cambios del servidor
/// 4. Agregar tracking de last_sync timestamp para sincronización incremental
/// 5. Implementar batch syncing para mejorar performance
/// 6. Agregar soporte para todos los tipos de entidades (12 tablas)
class SyncManager {
  final AppDatabase _localDb;
  final SyncQueue _syncQueue;
  final NetworkInfo _networkInfo;
  final ConflictResolver _conflictResolver;

  final _syncStatusController = StreamController<SyncStatus>.broadcast();
  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;

  SyncStatus _currentStatus = SyncStatus.idle();
  SyncStatus get currentStatus => _currentStatus;

  Timer? _periodicSyncTimer;
  StreamSubscription? _connectivitySubscription;

  SyncManager({
    required AppDatabase localDb,
    required SyncQueue syncQueue,
    required NetworkInfo networkInfo,
    ConflictResolver? conflictResolver,
  })  : _localDb = localDb,
        _syncQueue = syncQueue,
        _networkInfo = networkInfo,
        _conflictResolver = conflictResolver ?? ConflictResolver() {
    _init();
  }

  void _init() {
    // Escuchar cambios de conectividad
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (result) {
        if (result != ConnectivityResult.none) {
          // Cuando hay conexión, sincronizar automáticamente
          syncAll();
        }
      },
    );

    // Sincronización periódica cada 15 minutos
    _periodicSyncTimer = Timer.periodic(
      const Duration(minutes: 15),
      (_) => syncAll(),
    );
  }

  /// Sincronizar todos los cambios pendientes
  Future<Either<Failure, void>> syncAll() async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'Sin conexión a internet'));
    }

    if (_currentStatus.state == SyncState.syncing) {
      return Left(SyncFailure(message: 'Sincronización en progreso'));
    }

    _updateStatus(SyncStatus.syncing(pendingItems: _syncQueue.length));

    try {
      final pendingItems = _syncQueue.getPending();
      int successCount = 0;
      int errorCount = 0;
      final conflicts = <SyncConflict>[];

      for (final item in pendingItems) {
        final result = await _syncItem(item);

        result.fold(
          (failure) {
            if (failure is ConflictFailure) {
              conflicts.add(failure.conflict);
            } else {
              errorCount++;
              _syncQueue.markError(item.id, failure.message);
            }
          },
          (_) {
            successCount++;
            _syncQueue.remove(item.id);
          },
        );
      }

      // Sincronizar cambios del servidor hacia local
      await _pullFromServer();

      if (conflicts.isNotEmpty) {
        _updateStatus(SyncStatus.conflict(conflictItems: conflicts.length));
        return Left(ConflictFailure(
          message: 'Se encontraron ${conflicts.length} conflictos',
          conflict: conflicts.first,
        ));
      }

      if (errorCount > 0) {
        _updateStatus(SyncStatus.error(
          'Sincronización completada con $errorCount errores',
        ));
        return Left(SyncFailure(
          message: 'Algunos items no se sincronizaron',
        ));
      }

      _updateStatus(SyncStatus.success());
      return const Right(null);
    } catch (e) {
      _updateStatus(SyncStatus.error(e.toString()));
      return Left(SyncFailure(message: e.toString()));
    }
  }

  /// Sincronizar un item específico
  Future<Either<Failure, void>> _syncItem(SyncItem item) async {
    // Aquí implementarías la lógica específica para cada tipo de entidad
    // Por ahora, esto es un esqueleto

    try {
      switch (item.entityType) {
        case SyncEntityType.producto:
          return await _syncProducto(item);
        case SyncEntityType.inventario:
          return await _syncInventario(item);
        case SyncEntityType.movimiento:
          return await _syncMovimiento(item);
        // ... otros casos
        default:
          return Left(SyncFailure(
            message: 'Tipo de entidad no soportado: ${item.entityType}',
          ));
      }
    } catch (e) {
      return Left(SyncFailure(message: e.toString()));
    }
  }

  /// Ejemplo de sincronización de producto
  Future<Either<Failure, void>> _syncProducto(SyncItem item) async {
    // Esta es una implementación de ejemplo
    // Deberías usar tu ProductoRemoteDatasource aquí
    
    try {
      // TODO: Implementar con el datasource real
      // await _productoRemoteDatasource.sync(item);
      
      return const Right(null);
    } catch (e) {
      return Left(SyncFailure(message: e.toString()));
    }
  }

  /// Ejemplo de sincronización de inventario
  Future<Either<Failure, void>> _syncInventario(SyncItem item) async {
    // TODO: Implementar
    return const Right(null);
  }

  /// Ejemplo de sincronización de movimiento
  Future<Either<Failure, void>> _syncMovimiento(SyncItem item) async {
    // TODO: Implementar
    return const Right(null);
  }

  /// Traer cambios del servidor a local (pull)
  Future<void> _pullFromServer() async {
    // TODO: Implementar lógica para traer cambios del servidor
    // y actualizar la base de datos local
  }

  /// Agregar cambio a la cola de sincronización
  Future<void> queueChange({
    required String entityId,
    required SyncEntityType entityType,
    required SyncOperation operation,
    required Map<String, dynamic> data,
  }) async {
    final item = SyncItem(
      entityId: entityId,
      entityType: entityType,
      operation: operation,
      data: data,
    );

    await _syncQueue.enqueue(item);

    // Si hay conexión, intentar sincronizar inmediatamente
    if (await _networkInfo.isConnected) {
      syncAll();
    }
  }

  /// Actualizar estado y notificar
  void _updateStatus(SyncStatus status) {
    _currentStatus = status;
    _syncStatusController.add(status);
  }

  /// Limpiar recursos
  void dispose() {
    _periodicSyncTimer?.cancel();
    _connectivitySubscription?.cancel();
    _syncStatusController.close();
  }
}
