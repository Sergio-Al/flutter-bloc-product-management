import 'package:flutter_management_system/core/sync/sync_status.dart';
import 'package:flutter_management_system/data/datasources/remote/almacen_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/categoria_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/inventario_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/lote_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/movimiento_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/producto_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/proveedor_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/tienda_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/unidad_medida_remote_datasource.dart';
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
    ProductoRemoteDataSource productoRemote,
    AlmacenRemoteDataSource almacenRemote,
    TiendaRemoteDataSource tiendaRemote,
    ProveedorRemoteDataSource proveedorRemote,
    LoteRemoteDataSource loteRemote,
    CategoriaRemoteDataSource categoriaRemote,
    UnidadMedidaRemoteDataSource unidadMedidaRemote,
    InventarioRemoteDataSource inventarioRemote,
    MovimientoRemoteDataSource movimientoRemote,
  ) {
    final queue = SyncQueue(prefs);
    _syncManager = SyncManager(
      localDb: database,
      syncQueue: queue,
      networkInfo: networkInfo,
      productoRemote: productoRemote,
      almacenRemote: almacenRemote,
      tiendaRemote: tiendaRemote,
      proveedorRemote: proveedorRemote,
      loteRemote: loteRemote,
      categoriaRemote: categoriaRemote,
      unidadMedidaRemote: unidadMedidaRemote,
      inventarioRemote: inventarioRemote,
      movimientoRemote: movimientoRemote,
    );
  }

  static Future<SyncService> initialize({
    required AppDatabase database,
    required SharedPreferences prefs,
    required NetworkInfo networkInfo,
    required ProductoRemoteDataSource productoRemote,
    required AlmacenRemoteDataSource almacenRemote,
    required TiendaRemoteDataSource tiendaRemote,
    required ProveedorRemoteDataSource proveedorRemote,
    required LoteRemoteDataSource loteRemote,
    required CategoriaRemoteDataSource categoriaRemote,
    required UnidadMedidaRemoteDataSource unidadMedidaRemote,
    required InventarioRemoteDataSource inventarioRemote,
    required MovimientoRemoteDataSource movimientoRemote,
  }) async {
    _instance ??= SyncService._internal(
      database,
      prefs,
      networkInfo,
      productoRemote,
      almacenRemote,
      tiendaRemote,
      proveedorRemote,
      loteRemote,
      categoriaRemote,
      unidadMedidaRemote,
      inventarioRemote,
      movimientoRemote,
    );
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
