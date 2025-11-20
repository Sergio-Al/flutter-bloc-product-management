import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/core/network/network_info.dart';
import 'package:flutter_management_system/core/sync/sync_manager.dart';
import 'package:flutter_management_system/core/sync/sync_item.dart';
import 'package:flutter_management_system/core/utils/logger.dart';
import 'package:flutter_management_system/data/datasources/local/database/app_database.dart';
import 'package:flutter_management_system/data/datasources/local/database/daos/producto_dao.dart';
import 'package:flutter_management_system/data/datasources/remote/producto_remote_datasource.dart';
import 'package:flutter_management_system/domain/entities/producto.dart';
import 'package:flutter_management_system/domain/repositories/producto_repository.dart';

class ProductoRepositoryImpl extends ProductoRepository {
  final ProductoRemoteDataSource remoteDataSource;
  final ProductoDao productoDao;
  final NetworkInfo networkInfo;
  final SyncManager syncManager;

  ProductoRepositoryImpl({
    required this.remoteDataSource,
    required this.productoDao,
    required this.networkInfo,
    required this.syncManager,
  });

  @override
  Future<Either<Failure, Producto>> createProducto(Producto producto) async {
    try {
      // 1. ALWAYS save locally first (works offline)
      final now = DateTime.now();
      final tempSyncId = syncManager.generateTempSyncId();

      AppLogger.info('Creating producto locally: ${producto.nombre}');

      // Convert entity to Drift ProductoTable object
      final productoTable = ProductoTable(
        id: producto.id,
        nombre: producto.nombre,
        codigo: producto.codigo,
        descripcion: producto.descripcion,
        categoriaId: producto.categoriaId ?? 'default-category-id',
        unidadMedidaId: producto.unidadMedidaId ?? 'default-unit-id',
        proveedorPrincipalId: producto.proveedorPrincipalId,
        precioCompra: producto.precioCompra,
        precioVenta: producto.precioVenta,
        pesoUnitarioKg: producto.pesoUnitarioKg,
        volumenUnitarioM3: producto.volumenUnitarioM3,
        stockMinimo: producto.stockMinimo,
        stockMaximo: producto.stockMaximo,
        marca: producto.marca,
        gradoCalidad: producto.gradoCalidad,
        normaTecnica: producto.normaTecnica,
        requiereAlmacenCubierto: producto.requiereAlmacenCubierto,
        materialPeligroso: producto.materialPeligroso,
        imagenUrl: producto.imagenUrl,
        fichaTecnicaUrl: producto.fichaTecnicaUrl,
        activo: producto.activo,
        createdAt: producto.createdAt,
        updatedAt: now,
        deletedAt: producto.deletedAt,
        syncId: tempSyncId,
        lastSync: producto.lastSync,
      );

      await productoDao.insertProducto(productoTable);

      AppLogger.info('Producto created locally with tempSyncId: $tempSyncId');

      // 2. Add to sync queue
      await syncManager.queueChange(
        entityId: producto.id,
        entityType: SyncEntityType.producto,
        operation: SyncOperation.create,
        data: producto.toJson(),
      );

      // 3. SyncManager will automatically sync if online
      // No need to manually check - it handles it!

      return Right(producto);
    } catch (e) {
      AppLogger.error('Error creating producto: $e');
      return Left(CacheFailure(message: 'Failed to create producto: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProducto(String id) async {
    try {
      // 1. ALWAYS delete locally first (soft delete - works offline)
      final deleted = await productoDao.deleteProducto(id);

      if (!deleted) {
        return Left(CacheFailure(message: 'Producto not found locally'));
      }

      // 2. Add to sync queue
      await syncManager.queueChange(
        entityId: id,
        entityType: SyncEntityType.producto,
        operation: SyncOperation.delete,
        data: {'id': id}, // Minimal data for delete
      );

      // 3. SyncManager handles syncing automatically
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to delete producto: $e'));
    }
  }

  @override
  Future<Either<Failure, Producto>> getProductoByCodigo(String codigo) async {
    try {
      // Attempt to fetch producto by codigo from dao (local database)
      final productoTable = await productoDao.getProductoByCodigo(codigo);
      if (productoTable != null) {
        // Convert ProductoTable to Producto entity
        final producto = Producto(
          id: productoTable.id,
          nombre: productoTable.nombre,
          codigo: productoTable.codigo,
          descripcion: productoTable.descripcion,
          categoriaId: productoTable.categoriaId,
          unidadMedidaId: productoTable.unidadMedidaId,
          proveedorPrincipalId: productoTable.proveedorPrincipalId,
          precioCompra: productoTable.precioCompra,
          precioVenta: productoTable.precioVenta,
          pesoUnitarioKg: productoTable.pesoUnitarioKg,
          volumenUnitarioM3: productoTable.volumenUnitarioM3,
          stockMinimo: productoTable.stockMinimo,
          stockMaximo: productoTable.stockMaximo,
          marca: productoTable.marca,
          gradoCalidad: productoTable.gradoCalidad,
          normaTecnica: productoTable.normaTecnica,
          requiereAlmacenCubierto: productoTable.requiereAlmacenCubierto,
          materialPeligroso: productoTable.materialPeligroso,
          imagenUrl: productoTable.imagenUrl,
          fichaTecnicaUrl: productoTable.fichaTecnicaUrl,
          activo: productoTable.activo,
          createdAt: productoTable.createdAt,
          updatedAt: productoTable.updatedAt,
          deletedAt: productoTable.deletedAt,
          syncId: productoTable.syncId,
          lastSync: productoTable.lastSync,
        );
        return Right(producto);
      }

      // If not found locally, attempt to fetch from remote data source
      if (await networkInfo.isConnected) {
        final remoteProductoMap = await remoteDataSource.searchProductos(
          searchTerm: codigo,
          limit: 1,
        );
        final remoteProducto = remoteProductoMap;
        return Right(remoteProducto as Producto);
      } else {
        return Left(NetworkFailure(message: 'No internet connection'));
      }
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Unexpected error getting producto by codigo: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Producto>> getProductoById(String id) async {
    try {
      // Attempt to fetch producto by id from dao (local database)
      final productoTable = await productoDao.getProductoById(id);
      if (productoTable != null) {
        AppLogger.info('Producto found locally: $id');
        // Convert ProductoTable to Producto entity
        final producto = Producto(
          id: productoTable.id,
          nombre: productoTable.nombre,
          codigo: productoTable.codigo,
          descripcion: productoTable.descripcion,
          categoriaId: productoTable.categoriaId,
          unidadMedidaId: productoTable.unidadMedidaId,
          proveedorPrincipalId: productoTable.proveedorPrincipalId,
          precioCompra: productoTable.precioCompra,
          precioVenta: productoTable.precioVenta,
          pesoUnitarioKg: productoTable.pesoUnitarioKg,
          volumenUnitarioM3: productoTable.volumenUnitarioM3,
          stockMinimo: productoTable.stockMinimo,
          stockMaximo: productoTable.stockMaximo,
          marca: productoTable.marca,
          gradoCalidad: productoTable.gradoCalidad,
          normaTecnica: productoTable.normaTecnica,
          requiereAlmacenCubierto: productoTable.requiereAlmacenCubierto,
          materialPeligroso: productoTable.materialPeligroso,
          imagenUrl: productoTable.imagenUrl,
          fichaTecnicaUrl: productoTable.fichaTecnicaUrl,
          activo: productoTable.activo,
          createdAt: productoTable.createdAt,
          updatedAt: productoTable.updatedAt,
          deletedAt: productoTable.deletedAt,
          syncId: productoTable.syncId,
          lastSync: productoTable.lastSync,
        );
        return Right(producto);
      }

      // If not found locally, attempt to fetch from remote data source
      if (await networkInfo.isConnected) {
        AppLogger.info('Fetching producto by id from remote: $id');
        final remoteProductoMap = await remoteDataSource.getProductoById(id);
        final remoteProducto = remoteProductoMap;
        return Right(remoteProducto as Producto);
      } else {
        return Left(NetworkFailure(message: 'No internet connection'));
      }
    } catch (e) {
      AppLogger.error('Error getting producto by id: $e');
      return Left(
        ServerFailure(message: 'Unexpected error getting producto by id: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Producto>>> getProductos() async {
    try {
      // Fetch all productos from local database
      final localProductosTables = await productoDao.getAllProductos();
      final productos = localProductosTables
          .map(
            (table) => Producto(
              id: table.id,
              nombre: table.nombre,
              codigo: table.codigo,
              descripcion: table.descripcion,
              categoriaId: table.categoriaId,
              unidadMedidaId: table.unidadMedidaId,
              proveedorPrincipalId: table.proveedorPrincipalId,
              precioCompra: table.precioCompra,
              precioVenta: table.precioVenta,
              pesoUnitarioKg: table.pesoUnitarioKg,
              volumenUnitarioM3: table.volumenUnitarioM3,
              stockMinimo: table.stockMinimo,
              stockMaximo: table.stockMaximo,
              marca: table.marca,
              gradoCalidad: table.gradoCalidad,
              normaTecnica: table.normaTecnica,
              requiereAlmacenCubierto: table.requiereAlmacenCubierto,
              materialPeligroso: table.materialPeligroso,
              imagenUrl: table.imagenUrl,
              fichaTecnicaUrl: table.fichaTecnicaUrl,
              activo: table.activo,
              createdAt: table.createdAt,
              updatedAt: table.updatedAt,
              deletedAt: table.deletedAt,
              syncId: table.syncId,
              lastSync: table.lastSync,
            ),
          )
          .toList();

      return Right(productos);
    } catch (e) {
      AppLogger.error('Error fetching productos: $e');
      return Left(CacheFailure(message: 'Failed to fetch productos: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Producto>>> getProductosActivos() async {
    try {
      // 1. Try local first (fast, works offline)
      final localProductosTables = await productoDao.getProductosActivos();
      final localProductos = localProductosTables
          .map(
            (table) => Producto(
              id: table.id,
              nombre: table.nombre,
              codigo: table.codigo,
              descripcion: table.descripcion,
              categoriaId: table.categoriaId,
              unidadMedidaId: table.unidadMedidaId,
              proveedorPrincipalId: table.proveedorPrincipalId,
              precioCompra: table.precioCompra,
              precioVenta: table.precioVenta,
              pesoUnitarioKg: table.pesoUnitarioKg,
              volumenUnitarioM3: table.volumenUnitarioM3,
              stockMinimo: table.stockMinimo,
              stockMaximo: table.stockMaximo,
              marca: table.marca,
              gradoCalidad: table.gradoCalidad,
              normaTecnica: table.normaTecnica,
              requiereAlmacenCubierto: table.requiereAlmacenCubierto,
              materialPeligroso: table.materialPeligroso,
              imagenUrl: table.imagenUrl,
              fichaTecnicaUrl: table.fichaTecnicaUrl,
              activo: table.activo,
              createdAt: table.createdAt,
              updatedAt: table.updatedAt,
              deletedAt: table.deletedAt,
              syncId: table.syncId,
              lastSync: table.lastSync,
            ),
          )
          .toList();

      // 2. If online, fetch fresh data from server
      if (await networkInfo.isConnected) {
        try {
          // Remote datasource returns List<Map<String, dynamic>>
          final remoteProductosMaps = await remoteDataSource
              .getProductosActivos();

          // Convert maps to entities (using fromRemoteJson for snake_case)
          final remoteProductos = remoteProductosMaps
              .map((map) => Producto.fromRemoteJson(map))
              .where((p) => p.activo) // Filter active only
              .toList();

          // 3. Update local cache with fresh data (simplified - in production use upsert)
          // Note: For production, implement proper upsert logic in DAO

          // 4. Return fresh server data
          return Right(remoteProductos);
        } catch (e) {
          // Server failed but we have local data, return it
          if (localProductos.isNotEmpty) {
            return Right(localProductos);
          }
          return Left(
            ServerFailure(message: 'Failed to fetch from server: $e'),
          );
        }
      }

      // 5. Offline: return cached data
      if (localProductos.isEmpty) {
        return Left(CacheFailure(message: 'No cached products available'));
      }

      return Right(localProductos);
    } catch (e) {
      return Left(
        ServerFailure(message: 'Unexpected error getting active products: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Producto>>>
  getProductosAlmacenamientoEspecial() async {
    try {
      // Attempt to fetch productos requiring special storage from dao (local database)
      final productosMap = await productoDao
          .getProductosAlmacenamientoEspecial();
      final productos = productosMap
          .map(
            (table) => Producto(
              id: table.id,
              nombre: table.nombre,
              codigo: table.codigo,
              descripcion: table.descripcion,
              categoriaId: table.categoriaId,
              unidadMedidaId: table.unidadMedidaId,
              proveedorPrincipalId: table.proveedorPrincipalId,
              precioCompra: table.precioCompra,
              precioVenta: table.precioVenta,
              pesoUnitarioKg: table.pesoUnitarioKg,
              volumenUnitarioM3: table.volumenUnitarioM3,
              stockMinimo: table.stockMinimo,
              stockMaximo: table.stockMaximo,
              marca: table.marca,
              gradoCalidad: table.gradoCalidad,
              normaTecnica: table.normaTecnica,
              requiereAlmacenCubierto: table.requiereAlmacenCubierto,
              materialPeligroso: table.materialPeligroso,
              imagenUrl: table.imagenUrl,
              fichaTecnicaUrl: table.fichaTecnicaUrl,
              activo: table.activo,
              createdAt: table.createdAt,
              updatedAt: table.updatedAt,
              deletedAt: table.deletedAt,
              syncId: table.syncId,
              lastSync: table.lastSync,
            ),
          )
          .toList();
      return Right(productos);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Unexpected error getting special storage products: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Producto>>> getProductosByCategoria(
    String categoriaId,
  ) {
    // TODO: implement getProductosByCategoria
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Producto>>> getProductosByProveedor(
    String proveedorId,
  ) {
    // TODO: implement getProductosByProveedor
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Producto>>> getProductosPeligrosos() {
    // TODO: implement getProductosPeligrosos
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Producto>>> getProductosStockBajo() {
    // TODO: implement getProductosStockBajo
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Producto>>> searchProductos(String query) async {
    try {
      // If query is empty, return all productos
      if (query.isEmpty) {
        return getProductos();
      }

      // Search productos by name or code in local database
      final localProductosTables = await productoDao.searchProductos(query);
      final productos = localProductosTables
          .map(
            (table) => Producto(
              id: table.id,
              nombre: table.nombre,
              codigo: table.codigo,
              descripcion: table.descripcion,
              categoriaId: table.categoriaId,
              unidadMedidaId: table.unidadMedidaId,
              proveedorPrincipalId: table.proveedorPrincipalId,
              precioCompra: table.precioCompra,
              precioVenta: table.precioVenta,
              pesoUnitarioKg: table.pesoUnitarioKg,
              volumenUnitarioM3: table.volumenUnitarioM3,
              stockMinimo: table.stockMinimo,
              stockMaximo: table.stockMaximo,
              marca: table.marca,
              gradoCalidad: table.gradoCalidad,
              normaTecnica: table.normaTecnica,
              requiereAlmacenCubierto: table.requiereAlmacenCubierto,
              materialPeligroso: table.materialPeligroso,
              imagenUrl: table.imagenUrl,
              fichaTecnicaUrl: table.fichaTecnicaUrl,
              activo: table.activo,
              createdAt: table.createdAt,
              updatedAt: table.updatedAt,
              deletedAt: table.deletedAt,
              syncId: table.syncId,
              lastSync: table.lastSync,
            ),
          )
          .toList();

      return Right(productos);
    } catch (e) {
      AppLogger.error('Error searching productos: $e');
      return Left(CacheFailure(message: 'Failed to search productos: $e'));
    }
  }

  @override
  Future<Either<Failure, Producto>> toggleProductoActivo(String id) {
    // TODO: implement toggleProductoActivo
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Producto>> updateProducto(Producto producto) async {
    try {
      final now = DateTime.now();

      // Convert entity to Drift ProductoTable object
      final productoTable = ProductoTable(
        id: producto.id,
        nombre: producto.nombre,
        codigo: producto.codigo,
        descripcion: producto.descripcion,
        categoriaId: producto.categoriaId ?? 'default-category-id',
        unidadMedidaId: producto.unidadMedidaId ?? 'default-unit-id',
        proveedorPrincipalId: producto.proveedorPrincipalId,
        precioCompra: producto.precioCompra,
        precioVenta: producto.precioVenta,
        pesoUnitarioKg: producto.pesoUnitarioKg,
        volumenUnitarioM3: producto.volumenUnitarioM3,
        stockMinimo: producto.stockMinimo,
        stockMaximo: producto.stockMaximo,
        marca: producto.marca,
        gradoCalidad: producto.gradoCalidad,
        normaTecnica: producto.normaTecnica,
        requiereAlmacenCubierto: producto.requiereAlmacenCubierto,
        materialPeligroso: producto.materialPeligroso,
        imagenUrl: producto.imagenUrl,
        fichaTecnicaUrl: producto.fichaTecnicaUrl,
        activo: producto.activo,
        createdAt: producto.createdAt,
        updatedAt: now,
        deletedAt: producto.deletedAt,
        syncId: producto.syncId,
        lastSync: producto.lastSync,
      );

      final updated = await productoDao.updateProducto(productoTable);

      AppLogger.info('Producto updated locally: ${producto.id}');

      if (!updated) {
        return Left(CacheFailure(message: 'Producto not found locally'));
      }

      await syncManager.queueChange(
        entityId: producto.id,
        entityType: SyncEntityType.producto,
        operation: SyncOperation.update,
        data: producto.toJson(),
      );

      return Right(producto);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to update producto: $e'));
    }
  }
}
