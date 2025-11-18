import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/di/sync_constants.dart';
import 'package:flutter_management_system/core/utils/logger.dart';
import 'package:flutter_management_system/data/datasources/remote/almacen_remote_datasource.dart';
import '../errors/failures.dart';
import '../network/network_info.dart';
import 'sync_status.dart';
import 'sync_queue.dart';
import 'sync_item.dart';
import 'conflict_resolver.dart' hide SyncConflict;
import '../../data/datasources/local/database/app_database.dart';
import '../../data/datasources/remote/producto_remote_datasource.dart';
import '../../domain/entities/producto.dart';

/// SyncManager - Coordina la sincronización offline-first
/// 
/// Manages bidirectional sync between local database and remote server
class SyncManager {
  final AppDatabase _localDb;
  final SyncQueue _syncQueue;
  final NetworkInfo _networkInfo;
  final ConflictResolver _conflictResolver;
  
  // Remote datasources
  final ProductoRemoteDataSource _productoRemote;
  final AlmacenRemoteDataSource _almacenRemote;

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
    required ProductoRemoteDataSource productoRemote,
    required AlmacenRemoteDataSource almacenRemote,
    ConflictResolver? conflictResolver,
  })  : _localDb = localDb,
        _syncQueue = syncQueue,
        _networkInfo = networkInfo,
        _productoRemote = productoRemote,
        _almacenRemote = almacenRemote,
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
      SyncConstants.periodicSyncInterval,
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
      
      AppLogger.info('Iniciando sincronización de ${pendingItems.length} items pendientes');

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
        case SyncEntityType.almacen:
          return await _syncAlmacen(item);
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
    try {
      // Convert camelCase data to snake_case for Supabase
      final remoteData = _convertToRemoteFormat(item.data);
      
      switch (item.operation) {
        case SyncOperation.create:
          // Create on server
          await _productoRemote.createProducto(remoteData);
          
          // Note: Server returns producto with generated ID/timestamps
          // Local already has the data, no need to update again
          break;

        case SyncOperation.update:
          // Update on server
          await _productoRemote.updateProducto(
            id: item.entityId,
            data: remoteData,
          );
          break;

        case SyncOperation.delete:
          // Delete on server (soft delete)
          await _productoRemote.deleteProducto(item.entityId);
          break;
      }

      return const Right(null);
    } catch (e) {
      return Left(SyncFailure(message: 'Failed to sync producto: $e'));
    }
  }

  // Sincronización de almacén
  Future<Either<Failure, void>> _syncAlmacen(SyncItem item) async {
    try {
      AppLogger.info('🔄 Almacen data to sync: ${item.id}');
      // Convert camelCase data to snake_case for Supabase
      final remoteData = _convertAlmacenToRemoteFormat(item.data, isUpdate: item.operation == SyncOperation.update);
      
      switch (item.operation) {
        case SyncOperation.create:
          // Create on server
          await _almacenRemote.createAlmacen(remoteData);
          break;

        case SyncOperation.update:
          // Update on server
          AppLogger.info( 'Synchronizing almacen update: $remoteData' );
          await _almacenRemote.updateAlmacen(
            id: item.entityId,
            data: remoteData,
          );
          break;

        case SyncOperation.delete:
          // Delete on server (soft delete)
          await _almacenRemote.deleteAlmacen(item.entityId);
          break;
      }

      return const Right(null);
    } catch (e) {
      return Left(SyncFailure(message: 'Failed to sync almacen: $e'));
    }
  }


  /// Convert camelCase JSON to snake_case for Supabase (Producto)
  Map<String, dynamic> _convertToRemoteFormat(Map<String, dynamic> data) {
    return {
      'id': data['id'],
      'nombre': data['nombre'],
      'codigo': data['codigo'],
      'descripcion': data['descripcion'],
      'categoria_id': data['categoriaId'],
      'unidad_medida_id': data['unidadMedidaId'],
      'proveedor_principal_id': data['proveedorPrincipalId'],
      'precio_compra': data['precioCompra'],
      'precio_venta': data['precioVenta'],
      'peso_unitario_kg': data['pesoUnitarioKg'],
      'volumen_unitario_m3': data['volumenUnitarioM3'],
      'stock_minimo': data['stockMinimo'],
      'stock_maximo': data['stockMaximo'],
      'marca': data['marca'],
      'grado_calidad': data['gradoCalidad'],
      'norma_tecnica': data['normaTecnica'],
      'requiere_almacen_cubierto': data['requiereAlmacenCubierto'],
      'material_peligroso': data['materialPeligroso'],
      'imagen_url': data['imagenUrl'],
      'ficha_tecnica_url': data['fichaTecnicaUrl'],
      'activo': data['activo'],
      'created_at': data['createdAt'],
      'updated_at': data['updatedAt'],
      'deleted_at': data['deletedAt'],
      // ❌ Don't send sync_id to Supabase - it's local-only
      // 'sync_id': data['syncId'], 
      'last_sync': data['lastSync'],
    };
  }

  /// Convert camelCase JSON to snake_case for Supabase (Almacen)
  Map<String, dynamic> _convertAlmacenToRemoteFormat(Map<String, dynamic> data, {bool isUpdate = false}) {
    final converted = <String, dynamic>{
      'nombre': data['nombre'],
      'codigo': data['codigo'],
      'ubicacion': data['ubicacion'],
      'tipo': data['tipo'],
      'capacidad_m3': data['capacidadM3'],
      'area_m2': data['areaM2'],
      'activo': data['activo'],
    };
    
    // Only include tienda_id for CREATE, not UPDATE
    if (!isUpdate && data['tiendaId'] != null) {
      converted['tienda_id'] = data['tiendaId'];
    }
    
    // Only include deleted_at if it exists
    if (data['deletedAt'] != null) {
      converted['deleted_at'] = data['deletedAt'];
    }
    
    AppLogger.database('🔄 Almacen data to sync (isUpdate: $isUpdate): $converted');
    return converted;
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

  // Generar tempSyncId
  String generateTempSyncId() {
    final now = DateTime.now();
    return 'temp_${now.millisecondsSinceEpoch}';
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
