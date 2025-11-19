import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:flutter_management_system/core/di/sync_constants.dart';
import 'package:flutter_management_system/core/utils/logger.dart';
import 'package:flutter_management_system/data/datasources/remote/almacen_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/inventario_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/movimiento_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/proveedor_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/tienda_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/lote_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/categoria_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/unidad_medida_remote_datasource.dart';
import '../errors/failures.dart';
import '../network/network_info.dart';
import 'sync_status.dart';
import 'sync_queue.dart';
import 'sync_item.dart';
import 'conflict_resolver.dart' hide SyncConflict;
import '../../data/datasources/local/database/app_database.dart';
import '../../data/datasources/remote/producto_remote_datasource.dart';

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
  final TiendaRemoteDataSource _tiendaRemote;
  final ProveedorRemoteDataSource _proveedorRemote;
  final LoteRemoteDataSource _loteRemote;
  final CategoriaRemoteDataSource _categoriaRemote;
  final UnidadMedidaRemoteDataSource _unidadMedidaRemote;
  final InventarioRemoteDataSource _inventarioRemote;
  final MovimientoRemoteDataSource _movimientoRemote;

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
    required TiendaRemoteDataSource tiendaRemote,
    required ProveedorRemoteDataSource proveedorRemote,
    required LoteRemoteDataSource loteRemote,
    required CategoriaRemoteDataSource categoriaRemote,
    required UnidadMedidaRemoteDataSource unidadMedidaRemote,
    required InventarioRemoteDataSource inventarioRemote,
    required MovimientoRemoteDataSource movimientoRemote,
    ConflictResolver? conflictResolver,
  }) : _localDb = localDb,
       _syncQueue = syncQueue,
       _networkInfo = networkInfo,
       _productoRemote = productoRemote,
       _almacenRemote = almacenRemote,
       _tiendaRemote = tiendaRemote,
       _proveedorRemote = proveedorRemote,
       _loteRemote = loteRemote,
       _categoriaRemote = categoriaRemote,
       _unidadMedidaRemote = unidadMedidaRemote,
       _inventarioRemote = inventarioRemote,
       _movimientoRemote = movimientoRemote,
       _conflictResolver = conflictResolver ?? ConflictResolver() {
    _init();
  }

  void _init() {
    // Escuchar cambios de conectividad
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        // Cuando hay conexión, sincronizar automáticamente
        syncAll();
      }
    });

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
      int errorCount = 0;
      final conflicts = <SyncConflict>[];

      AppLogger.info(
        'Iniciando sincronización de ${pendingItems.length} items pendientes',
      );

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
            _syncQueue.remove(item.id);
          },
        );
      }

      // Sincronizar cambios del servidor hacia local
      await _pullFromServer();

      if (conflicts.isNotEmpty) {
        _updateStatus(SyncStatus.conflict(conflictItems: conflicts.length));
        return Left(
          ConflictFailure(
            message: 'Se encontraron ${conflicts.length} conflictos',
            conflict: conflicts.first,
          ),
        );
      }

      if (errorCount > 0) {
        _updateStatus(
          SyncStatus.error('Sincronización completada con $errorCount errores'),
        );
        return Left(SyncFailure(message: 'Algunos items no se sincronizaron'));
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
        case SyncEntityType.tienda:
          return await _syncTienda(item);
        case SyncEntityType.proveedor:
          return await _syncProveedor(item);
        case SyncEntityType.lote:
          return await _syncLote(item);
        default:
          return Left(
            SyncFailure(
              message: 'Tipo de entidad no soportado: ${item.entityType}',
            ),
          );
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
      final remoteData = _convertAlmacenToRemoteFormat(
        item.data,
        isUpdate: item.operation == SyncOperation.update,
      );

      switch (item.operation) {
        case SyncOperation.create:
          // Create on server
          await _almacenRemote.createAlmacen(remoteData);
          break;

        case SyncOperation.update:
          // Update on server
          AppLogger.info('Synchronizing almacen update: $remoteData');
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

  // Sincronización de tienda
  Future<Either<Failure, void>> _syncTienda(SyncItem item) async {
    try {
      AppLogger.info('🔄 Tienda data to sync: ${item.id}');
      // Convert camelCase data to snake_case for Supabase
      final remoteData = _convertTiendaToRemoteFormat(
        item.data,
        isUpdate: item.operation == SyncOperation.update,
      );

      switch (item.operation) {
        case SyncOperation.create:
          // Create on server
          AppLogger.info('Synchronizing tienda create: $remoteData');
          await _tiendaRemote.createTienda(remoteData);
          break;

        case SyncOperation.update:
          // Update on server
          AppLogger.info('Synchronizing tienda update: $remoteData');
          await _tiendaRemote.updateTienda(id: item.entityId, data: remoteData);
          break;

        case SyncOperation.delete:
          // Delete on server (soft delete)
          await _tiendaRemote.deleteTienda(item.entityId);
          break;
      }
      return const Right(null);
    } catch (e) {
      return Left(SyncFailure(message: 'Failed to sync tienda: $e'));
    }
  }

  // Sincronización de proveedor
  Future<Either<Failure, void>> _syncProveedor(SyncItem item) async {
    try {
      AppLogger.info('🔄 Proveedor data to sync: ${item.id}');

      // Convert camelCase data to snake_case for Supabase
      final remoteData = _convertProveedorToRemoteFormat(
        item.data,
        isUpdate: item.operation == SyncOperation.update,
      );

      switch (item.operation) {
        case SyncOperation.create:
          // Create on server
          await _proveedorRemote.createProveedor(remoteData);
          break;

        case SyncOperation.update:
          // Update on server
          await _proveedorRemote.updateProveedor(
            id: item.entityId,
            data: remoteData,
          );
          break;

        case SyncOperation.delete:
          // Delete on server (soft delete)
          await _proveedorRemote.deleteProveedor(item.entityId);
          break;
      }

      return const Right(null);
    } catch (e) {
      return Left(SyncFailure(message: 'Failed to sync proveedor: $e'));
    }
  }

  // Sincronización de lote
  Future<Either<Failure, void>> _syncLote(SyncItem item) async {
    try {
      AppLogger.info('🔄 Lote data to sync: ${item.id}');

      // Convert camelCase data to snake_case for Supabase
      final remoteData = _convertLoteToRemoteFormat(
        item.data,
        isUpdate: item.operation == SyncOperation.update,
      );

      switch (item.operation) {
        case SyncOperation.create:
          // Create on server
          await _loteRemote.createLote(remoteData);
          break;

        case SyncOperation.update:
          // Update on server
          await _loteRemote.updateLote(id: item.entityId, data: remoteData);
          break;

        case SyncOperation.delete:
          // Delete on server (soft delete)
          await _loteRemote.deleteLote(item.entityId);
          break;
      }
      return const Right(null);
    } catch (e) {
      return Left(SyncFailure(message: 'Failed to sync lote: $e'));
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
  Map<String, dynamic> _convertAlmacenToRemoteFormat(
    Map<String, dynamic> data, {
    bool isUpdate = false,
  }) {
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

    AppLogger.database(
      '🔄 Almacen data to sync (isUpdate: $isUpdate): $converted',
    );
    return converted;
  }

  /// Convert camelCase JSON to snake_case for Supabase (Tienda)
  Map<String, dynamic> _convertTiendaToRemoteFormat(
    Map<String, dynamic> data, {
    bool isUpdate = false,
  }) {
    final converted = <String, dynamic>{
      'id': data['id'],
      'nombre': data['nombre'],
      'codigo': data['codigo'],
      'direccion': data['direccion'],
      'ciudad': data['ciudad'],
      'departamento': data['departamento'],
      'telefono': data['telefono'],
      'horario_atencion': data['horarioAtencion'],
      'activo': data['activo'],
    };
    // Only include deleted_at if it exists
    if (data['deletedAt'] != null) {
      converted['deleted_at'] = data['deletedAt'];
    }
    return converted;
  }

  /// Convert camelCase JSON to snake_case for Supabase (Proveedor)
  Map<String, dynamic> _convertProveedorToRemoteFormat(
    Map<String, dynamic> data, {
    bool isUpdate = false,
  }) {
    final converted = <String, dynamic>{
      'id': data['id'],
      'razon_social': data['razonSocial'],
      'nit': data['nit'],
      'direccion': data['direccion'],
      'ciudad': data['ciudad'],
      'telefono': data['telefono'],
      'email': data['email'],
      'nombre_contacto': data['nombreContacto'],
      'tipo_material': data['tipoMaterial'],
      'dias_credito': data['diasCredito'],
      'activo': data['activo'],
    };

    // Only include deleted_at if it exists
    if (data['deletedAt'] != null) {
      converted['deleted_at'] = data['deletedAt'];
    }
    return converted;
  }

  /// Convert camelCase JSON to snake_case for Supabase (Lote)
  Map<String, dynamic> _convertLoteToRemoteFormat(
    Map<String, dynamic> data, {
    bool isUpdate = false,
  }) {
    final converted = <String, dynamic>{
      'id': data['id'],
      'numero_lote': data['numeroLote'],
      'producto_id': data['productoId'],
      'fecha_fabricacion': data['fechaFabricacion'],
      'fecha_vencimiento': data['fechaVencimiento'],
      'proveedor_id': data['proveedorId'],
      'numero_factura': data['numeroFactura'],
      'cantidad_inicial': data['cantidadInicial'],
      'cantidad_actual': data['cantidadActual'],
      'certificado_calidad_url': data['certificadoCalidadUrl'],
      'observaciones': data['observaciones'],
    };

    return converted;
  }

  // Sincronización de inventario
  Future<Either<Failure, void>> _syncInventario(SyncItem item) async {
    try {
      AppLogger.info('🔄 Inventario data to sync: ${item.id}');

      // Convert camelCase data to snake_case for Supabase
      final remoteData = _convertInventarioToRemoteFormat(
        item.data,
        isUpdate: item.operation == SyncOperation.update,
      );

      switch (item.operation) {
        case SyncOperation.create:
          // Create on server
          await _inventarioRemote.createInventario(remoteData);
          break;

        case SyncOperation.update:
          // Update on server
          await _inventarioRemote.updateInventario(
            id: item.entityId,
            data: remoteData,
          );
          break;

        case SyncOperation.delete:
          // Delete on server (soft delete)
          await _inventarioRemote.deleteInventario(item.entityId);
          break;
      }

      return const Right(null);
    } catch (e) {
      return Left(SyncFailure(message: 'Failed to sync inventario: $e'));
    }
  }

  /// Convert camelCase JSON to snake_case for Supabase (Inventario)
  Map<String, dynamic> _convertInventarioToRemoteFormat(
    Map<String, dynamic> data, {
    bool isUpdate = false,
  }) {
    final converted = <String, dynamic>{
      'id': data['id'],
      'producto_id': data['productoId'],
      'almacen_id': data['almacenId'],
      'tienda_id': data['tiendaId'],
      'lote_id': data['loteId'],
      'cantidad_actual': data['cantidadActual'],
      'cantidad_reservada': data['cantidadReservada'],
      // 'cantidad_disponible': data['cantidadDisponible'],
      'valor_total': data['valorTotal'],
      'ubicacion_fisica': data['ubicacionFisica'],
      'ultima_actualizacion': data['ultimaActualizacion'],
    };
    return converted;
  }

  /// Ejemplo de sincronización de movimiento
  Future<Either<Failure, void>> _syncMovimiento(SyncItem item) async {
    try {
      // Convert camelCase data to snake_case for Supabase
      final remoteData = _convertMovimientoToRemoteFormat(item.data);

      switch (item.operation) {
        case SyncOperation.create:
          // Create on server
          await _movimientoRemote.createMovimiento(remoteData);
          break;

        case SyncOperation.update:
          // Update on server
          await _movimientoRemote.updateMovimiento(
            id: item.entityId,
            data: remoteData,
          );
          break;

        case SyncOperation.delete:
          // Movimientos are not deleted, only soft-deleted via 'estado' field
          break;
      }

      return const Right(null);
    } catch (e) {
      return Left(SyncFailure(message: 'Failed to sync movimiento: $e'));
    }
  }

  /// Convert camelCase JSON to snake_case for Supabase (Movimiento)
  /// Note: toJson() already returns snake_case, so we just pass it through
  /// removing local-only fields
  Map<String, dynamic> _convertMovimientoToRemoteFormat(
    Map<String, dynamic> data,
  ) {
    // Remove local-only fields (sincronizado)
    final remoteData = Map<String, dynamic>.from(data);
    remoteData.remove('sincronizado');
    remoteData.remove('sync_id');
    return remoteData;
  }

  /// Traer cambios del servidor a local (pull)
  Future<void> _pullFromServer() async {
    try {
      AppLogger.info('🔽 Iniciando pull desde servidor...');

      // 1. Sync reference data first (order matters due to foreign keys)
      await _pullCategorias();
      await _pullUnidadesMedida();

      // 2. Sync master data
      await _pullTiendas();
      await _pullProveedores();
      await _pullAlmacenes();

      // 3. Sync transactional data
      await _pullProductos();
      await _pullLotes();
      await _pullInventarios();
      await _pullMovimientos();

      AppLogger.info('✅ Pull desde servidor completado');
    } catch (e) {
      AppLogger.error('❌ Error en pull desde servidor: $e');
      rethrow;
    }
  }

  /// Pull categorías from server
  Future<void> _pullCategorias() async {
    try {
      final remoteData = await _categoriaRemote.getCategorias();

      AppLogger.sync('Sincronizando ${remoteData.length} categorías...');

      for (final data in remoteData) {
        final categoria = CategoriasCompanion(
          id: Value(data['id'] as String),
          nombre: Value(data['nombre'] as String),
          codigo: Value(data['codigo'] as String? ?? ''),
          descripcion: Value(data['descripcion'] as String?),
          categoriaPadreId: Value(data['categoria_padre_id'] as String?),
          requiereLote: Value(data['requiere_lote'] as bool? ?? false),
          requiereCertificacion: Value(
            data['requiere_certificacion'] as bool? ?? false,
          ),
          activo: Value(data['activo'] as bool? ?? true),
          createdAt: Value(
            data['created_at'] != null
                ? DateTime.parse(data['created_at'] as String)
                : DateTime.now(),
          ),
          updatedAt: Value(
            data['updated_at'] != null
                ? DateTime.parse(data['updated_at'] as String)
                : DateTime.now(),
          ),
        );

        await _localDb
            .into(_localDb.categorias)
            .insertOnConflictUpdate(categoria);
      }

      AppLogger.sync('✅ Categorías sincronizadas');
    } catch (e) {
      AppLogger.error('Error syncing categorías: $e');
    }
  }

  /// Pull unidades medida from server
  Future<void> _pullUnidadesMedida() async {
    try {
      final remoteData = await _unidadMedidaRemote.getUnidades();

      AppLogger.sync(
        'Sincronizando ${remoteData.length} unidades de medida...',
      );

      for (final data in remoteData) {
        final unidad = UnidadesMedidaCompanion(
          id: Value(data['id'] as String),
          nombre: Value(data['nombre'] as String),
          abreviatura: Value(data['abreviatura'] as String),
          tipo: Value(data['tipo'] as String),
          factorConversion: Value(data['factor_conversion'] as double? ?? 1.0),
          createdAt: Value(
            data['created_at'] != null
                ? DateTime.parse(data['created_at'] as String)
                : DateTime.now(),
          ),
          updatedAt: Value(
            data['updated_at'] != null
                ? DateTime.parse(data['updated_at'] as String)
                : DateTime.now(),
          ),
        );

        await _localDb
            .into(_localDb.unidadesMedida)
            .insertOnConflictUpdate(unidad);
      }

      AppLogger.sync('✅ Unidades de medida sincronizadas');
    } catch (e) {
      AppLogger.error('Error syncing unidades medida: $e');
    }
  }

  /// Pull tiendas from server
  Future<void> _pullTiendas() async {
    try {
      final remoteData = await _tiendaRemote.getTiendas();

      AppLogger.sync('Sincronizando ${remoteData.length} tiendas...');

      for (final data in remoteData) {
        final tienda = TiendasCompanion(
          id: Value(data['id'] as String),
          nombre: Value(data['nombre'] as String),
          codigo: Value(data['codigo'] as String),
          direccion: Value(data['direccion'] as String? ?? ''),
          ciudad: Value(data['ciudad'] as String? ?? ''),
          departamento: Value(data['departamento'] as String? ?? ''),
          telefono: Value(data['telefono'] as String?),
          horarioAtencion: Value(data['horario_atencion'] as String?),
          activo: Value(data['activo'] as bool? ?? true),
          createdAt: Value(
            data['created_at'] != null
                ? DateTime.parse(data['created_at'] as String)
                : DateTime.now(),
          ),
          updatedAt: Value(
            data['updated_at'] != null
                ? DateTime.parse(data['updated_at'] as String)
                : DateTime.now(),
          ),
          deletedAt: Value(
            data['deleted_at'] != null
                ? DateTime.parse(data['deleted_at'] as String)
                : null,
          ),
        );

        await _localDb.into(_localDb.tiendas).insertOnConflictUpdate(tienda);
      }

      AppLogger.sync('✅ Tiendas sincronizadas');
    } catch (e) {
      AppLogger.error('Error syncing tiendas: $e');
    }
  }

  /// Pull proveedores from server
  Future<void> _pullProveedores() async {
    try {
      final remoteData = await _proveedorRemote.getProveedores();

      AppLogger.sync('Sincronizando ${remoteData.length} proveedores...');

      for (final data in remoteData) {
        final proveedor = ProveedoresCompanion(
          id: Value(data['id'] as String),
          razonSocial: Value(data['razon_social'] as String),
          nit: Value(data['nit'] as String? ?? ''),
          direccion: Value(data['direccion'] as String?),
          ciudad: Value(data['ciudad'] as String?),
          telefono: Value(data['telefono'] as String?),
          email: Value(data['email'] as String?),
          nombreContacto: Value(data['nombre_contacto'] as String?),
          tipoMaterial: Value(data['tipo_material'] as String?),
          diasCredito: Value(data['dias_credito'] as int? ?? 0),
          activo: Value(data['activo'] as bool? ?? true),
          createdAt: Value(
            data['created_at'] != null
                ? DateTime.parse(data['created_at'] as String)
                : DateTime.now(),
          ),
          updatedAt: Value(
            data['updated_at'] != null
                ? DateTime.parse(data['updated_at'] as String)
                : DateTime.now(),
          ),
          deletedAt: Value(
            data['deleted_at'] != null
                ? DateTime.parse(data['deleted_at'] as String)
                : null,
          ),
        );

        await _localDb
            .into(_localDb.proveedores)
            .insertOnConflictUpdate(proveedor);
      }

      AppLogger.sync('✅ Proveedores sincronizados');
    } catch (e) {
      AppLogger.error('Error syncing proveedores: $e');
    }
  }

  /// Pull almacenes from server
  Future<void> _pullAlmacenes() async {
    try {
      final remoteData = await _almacenRemote.getAlmacenes();

      AppLogger.sync('Sincronizando ${remoteData.length} almacenes...');

      for (final data in remoteData) {
        final almacen = AlmacenesCompanion(
          id: Value(data['id'] as String),
          nombre: Value(data['nombre'] as String),
          codigo: Value(data['codigo'] as String),
          ubicacion: Value(data['ubicacion'] as String? ?? ''),
          tipo: Value(data['tipo'] as String),
          capacidadM3: Value(data['capacidad_m3'] as double?),
          areaM2: Value(data['area_m2'] as double?),
          tiendaId: Value(data['tienda_id'] as String? ?? ''),
          activo: Value(data['activo'] as bool? ?? true),
          createdAt: Value(
            data['created_at'] != null
                ? DateTime.parse(data['created_at'] as String)
                : DateTime.now(),
          ),
          updatedAt: Value(
            data['updated_at'] != null
                ? DateTime.parse(data['updated_at'] as String)
                : DateTime.now(),
          ),
          deletedAt: Value(
            data['deleted_at'] != null
                ? DateTime.parse(data['deleted_at'] as String)
                : null,
          ),
        );

        await _localDb.into(_localDb.almacenes).insertOnConflictUpdate(almacen);
      }

      AppLogger.sync('✅ Almacenes sincronizados');
    } catch (e) {
      AppLogger.error('Error syncing almacenes: $e');
    }
  }

  /// Pull productos from server
  Future<void> _pullProductos() async {
    try {
      final remoteData = await _productoRemote.getProductos();

      AppLogger.sync('Sincronizando ${remoteData.length} productos...');

      for (final data in remoteData) {
        final producto = ProductosCompanion(
          id: Value(data['id'] as String),
          nombre: Value(data['nombre'] as String),
          codigo: Value(data['codigo'] as String),
          descripcion: Value(data['descripcion'] as String?),
          categoriaId: Value(data['categoria_id'] as String? ?? ''),
          unidadMedidaId: Value(data['unidad_medida_id'] as String? ?? ''),
          proveedorPrincipalId: Value(
            data['proveedor_principal_id'] as String?,
          ),
          precioCompra: Value(data['precio_compra'] as double? ?? 0.0),
          precioVenta: Value(data['precio_venta'] as double? ?? 0.0),
          pesoUnitarioKg: Value(data['peso_unitario_kg'] as double?),
          volumenUnitarioM3: Value(data['volumen_unitario_m3'] as double?),
          stockMinimo: Value(data['stock_minimo'] as int? ?? 0),
          stockMaximo: Value(data['stock_maximo'] as int? ?? 0),
          marca: Value(data['marca'] as String?),
          gradoCalidad: Value(data['grado_calidad'] as String?),
          normaTecnica: Value(data['norma_tecnica'] as String?),
          requiereAlmacenCubierto: Value(
            data['requiere_almacen_cubierto'] as bool? ?? false,
          ),
          materialPeligroso: Value(
            data['material_peligroso'] as bool? ?? false,
          ),
          imagenUrl: Value(data['imagen_url'] as String?),
          fichaTecnicaUrl: Value(data['ficha_tecnica_url'] as String?),
          activo: Value(data['activo'] as bool? ?? true),
          createdAt: Value(
            data['created_at'] != null
                ? DateTime.parse(data['created_at'] as String)
                : DateTime.now(),
          ),
          updatedAt: Value(
            data['updated_at'] != null
                ? DateTime.parse(data['updated_at'] as String)
                : DateTime.now(),
          ),
          deletedAt: Value(
            data['deleted_at'] != null
                ? DateTime.parse(data['deleted_at'] as String)
                : null,
          ),
        );

        await _localDb
            .into(_localDb.productos)
            .insertOnConflictUpdate(producto);
      }

      AppLogger.sync('✅ Productos sincronizados');
    } catch (e) {
      AppLogger.error('Error syncing productos: $e');
    }
  }

  /// Pull lotes from server
  Future<void> _pullLotes() async {
    try {
      final remoteData = await _loteRemote.getLotes();

      // AppLogger.sync('Sincronizando ${remoteData.length} lotes...');

      for (final data in remoteData) {
        AppLogger.database('Lote data: $data');
        final lote = LotesCompanion(
          id: Value(data['id'] as String),
          numeroLote: Value(data['numero_lote'] as String),
          productoId: Value(data['producto_id'] as String),
          proveedorId: Value(data['proveedor_id'] as String?),
          cantidadInicial: Value(data['cantidad_inicial'] as int? ?? 0),
          cantidadActual: Value(data['cantidad_actual'] as int? ?? 0),
          fechaFabricacion: Value(
            data['fecha_fabricacion'] != null
                ? DateTime.parse(data['fecha_fabricacion'] as String)
                : null,
          ),
          fechaVencimiento: Value(
            data['fecha_vencimiento'] != null
                ? DateTime.parse(data['fecha_vencimiento'] as String)
                : null,
          ),
          certificadoCalidadUrl: Value(data['certificado_calidad'] as String?),
          numeroFactura: Value(data['numero_factura'] as String?),
          observaciones: const Value.absent(),
          createdAt: Value(
            data['created_at'] != null
                ? DateTime.parse(data['created_at'] as String)
                : DateTime.now(),
          ),
          updatedAt: Value(
            data['updated_at'] != null
                ? DateTime.parse(data['updated_at'] as String)
                : DateTime.now(),
          ),
        );

        await _localDb.into(_localDb.lotes).insertOnConflictUpdate(lote);
      }

      AppLogger.sync('✅ Lotes sincronizados');
    } catch (e) {
      AppLogger.error('Error syncing lotes: $e');
    }
  }

  // Pull inventarios from server
  Future<void> _pullInventarios() async {
    try {
      final remoteData = await _inventarioRemote.getInventarios();

      AppLogger.sync('Sincronizando ${remoteData.length} inventarios...');

      for (final data in remoteData) {
        final inventario = InventariosCompanion(
          id: Value(data['id'] as String),
          productoId: Value(data['producto_id'] as String),
          almacenId: Value(data['almacen_id'] as String),
          tiendaId: Value(data['tienda_id'] as String),
          loteId: Value(data['lote_id'] as String?),
          cantidadActual: Value(data['cantidad_actual'] as int? ?? 0),
          cantidadReservada: Value(data['cantidad_reservada'] as int? ?? 0),
          // cantidadDisponible: Value(data['cantidad_disponible'] as int? ?? 0),
          valorTotal: Value(data['valor_total'] as double? ?? 0.0),
          ubicacionFisica: Value(data['ubicacion_fisica'] as String?),
          ultimaActualizacion: Value(
            data['ultima_actualizacion'] != null
                ? DateTime.parse(data['ultima_actualizacion'] as String)
                : DateTime.now(),
          ),
        );

        await _localDb
            .into(_localDb.inventarios)
            .insertOnConflictUpdate(inventario);
      }

      AppLogger.sync('✅ Inventarios sincronizados');
    } catch (e) {
      AppLogger.error('Error syncing inventarios: $e');
    }
  }

  /*
  CREATE TABLE public.movimientos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    numero_movimiento VARCHAR(100) UNIQUE NOT NULL,
    producto_id UUID REFERENCES public.productos(id) NOT NULL,
    inventario_id UUID REFERENCES public.inventarios(id) ON DELETE SET NULL,
    lote_id UUID REFERENCES public.lotes(id) ON DELETE SET NULL,
    tienda_origen_id UUID REFERENCES public.tiendas(id) ON DELETE SET NULL,
    tienda_destino_id UUID REFERENCES public.tiendas(id) ON DELETE SET NULL,
    proveedor_id UUID REFERENCES public.proveedores(id) ON DELETE SET NULL,
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('COMPRA', 'VENTA', 'TRANSFERENCIA', 'AJUSTE', 'DEVOLUCION', 'MERMA')),
    motivo TEXT,
    cantidad INTEGER NOT NULL,
    costo_unitario DECIMAL(10, 2) DEFAULT 0 NOT NULL,
    costo_total DECIMAL(12, 2) DEFAULT 0 NOT NULL,
    peso_total_kg DECIMAL(10, 2),
    usuario_id UUID REFERENCES public.usuarios(id) NOT NULL,
    estado VARCHAR(50) NOT NULL DEFAULT 'PENDIENTE' CHECK (estado IN ('PENDIENTE', 'EN_TRANSITO', 'COMPLETADO', 'CANCELADO')),
    fecha_movimiento TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    numero_factura VARCHAR(100),
    numero_guia_remision VARCHAR(100),
    vehiculo_placa VARCHAR(20),
    conductor VARCHAR(255),
    observaciones TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    sync_id UUID DEFAULT uuid_generate_v4(),
    last_sync TIMESTAMPTZ,
    sincronizado BOOLEAN DEFAULT false NOT NULL
);
   */
  // Pull movimientos from server
  Future<void> _pullMovimientos() async {
    try {
      final remoteData = await _movimientoRemote.getMovimientos();

      AppLogger.sync('Sincronizando ${remoteData.length} movimientos...');

      for (final data in remoteData) {
        final movimiento = MovimientosCompanion(
          id: Value(data['id'] as String),
          numeroMovimiento: Value(data['numero_movimiento'] as String),
          productoId: Value(data['producto_id'] as String),
          inventarioId: Value(data['inventario_id'] as String),
          loteId: Value(data['lote_id'] as String?),
          tiendaOrigenId: Value(data['tienda_origen_id'] as String?),
          tiendaDestinoId: Value(data['tienda_destino_id'] as String?),
          proveedorId: Value(data['proveedor_id'] as String?),
          tipo: Value(data['tipo'] as String),
          motivo: Value(data['motivo'] as String?),
          cantidad: Value(data['cantidad'] as int? ?? 0),
          costoUnitario: Value(data['costo_unitario'] as double? ?? 0.0),
          costoTotal: Value(data['costo_total'] as double? ?? 0.0),
          pesoTotalKg: Value(data['peso_total_kg'] as double?),
          usuarioId: Value(data['usuario_id'] as String),
          estado: Value(data['estado'] as String? ?? 'PENDIENTE'),
          fechaMovimiento: Value(
            data['fecha_movimiento'] != null
                ? DateTime.parse(data['fecha_movimiento'] as String)
                : DateTime.now(),
          ),
          numeroFactura: Value(data['numero_factura'] as String?),
          numeroGuiaRemision: Value(data['numero_guia_remision'] as String?),
          vehiculoPlaca: Value(data['vehiculo_placa'] as String?),
          conductor: Value(data['conductor'] as String?),
          observaciones: Value(data['observaciones'] as String?),
          createdAt: Value(
            data['created_at'] != null
                ? DateTime.parse(data['created_at'] as String)
                : DateTime.now(),
          ),
          updatedAt: Value(
            data['updated_at'] != null
                ? DateTime.parse(data['updated_at'] as String)
                : DateTime.now(),
          ),
        );

        await _localDb
            .into(_localDb.movimientos)
            .insertOnConflictUpdate(movimiento);
      }
    } catch (e) {
      AppLogger.sync('Error sincronizando movimientos: $e');
    }
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
