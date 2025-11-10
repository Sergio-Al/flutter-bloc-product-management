// import 'package:dartz/dartz.dart';
// import '../../core/errors/failures.dart';
// import '../../core/errors/exceptions.dart';
// import '../../core/sync/sync_service.dart';
// import '../../core/sync/sync_item.dart';
// import '../../core/network/network_info.dart';
// import '../../domain/entities/producto.dart';
// import '../../domain/repositories/producto_repository.dart';
// import '../datasources/local/database/app_database.dart';
// import '../datasources/remote/producto_remote_datasource.dart';
// import '../models/producto_model.dart';

// class ProductoRepositoryImpl implements ProductoRepository {
//   final AppDatabase localDatasource;
//   final ProductoRemoteDatasource remoteDatasource;
//   final NetworkInfo networkInfo;
//   final SyncService syncService;

//   ProductoRepositoryImpl({
//     required this.localDatasource,
//     required this.remoteDatasource,
//     required this.networkInfo,
//     required this.syncService,
//   });

//   @override
//   Future<Either<Failure, List<Producto>>> getProductos() async {
//     try {
//       // 1. Siempre leer de la base de datos local primero (offline-first)
//       final localProductos = await localDatasource.productoDao.getAllProductos();
      
//       // 2. Si hay conexión, sincronizar en segundo plano
//       if (await networkInfo.isConnected) {
//         _syncProductosInBackground();
//       }

//       return Right(localProductos.map((p) => p.toEntity()).toList());
//     } on CacheException catch (e) {
//       return Left(CacheFailure(message: e.message));
//     }
//   }

//   @override
//   Future<Either<Failure, Producto>> getProductoById(String id) async {
//     try {
//       final producto = await localDatasource.productoDao.getProductoById(id);
      
//       if (producto == null) {
//         // Si no existe localmente y hay internet, intentar traerlo del servidor
//         if (await networkInfo.isConnected) {
//           final remoteProducto = await remoteDatasource.getProductoById(id);
//           await localDatasource.productoDao.insertProducto(
//             remoteProducto.toTable(),
//           );
//           return Right(remoteProducto.toEntity());
//         }
//         return Left(CacheFailure(message: 'Producto no encontrado'));
//       }

//       return Right(producto.toEntity());
//     } catch (e) {
//       return Left(CacheFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, Producto>> createProducto(Producto producto) async {
//     try {
//       // 1. Guardar localmente primero
//       final productoModel = ProductoModel.fromEntity(producto);
//       await localDatasource.productoDao.insertProducto(productoModel.toTable());

//       // 2. Agregar a la cola de sincronización
//       await syncService.queueProductoChange(
//         productoId: producto.id,
//         operation: SyncOperation.create,
//         data: productoModel.toJson(),
//       );

//       return Right(producto);
//     } on CacheException catch (e) {
//       return Left(CacheFailure(message: e.message));
//     }
//   }

//   @override
//   Future<Either<Failure, Producto>> updateProducto(Producto producto) async {
//     try {
//       // 1. Actualizar localmente
//       final productoModel = ProductoModel.fromEntity(producto);
//       await localDatasource.productoDao.updateProducto(productoModel.toTable());

//       // 2. Agregar a la cola de sincronización
//       await syncService.queueProductoChange(
//         productoId: producto.id,
//         operation: SyncOperation.update,
//         data: productoModel.toJson(),
//       );

//       return Right(producto);
//     } on CacheException catch (e) {
//       return Left(CacheFailure(message: e.message));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> deleteProducto(String id) async {
//     try {
//       // 1. Soft delete local
//       await localDatasource.productoDao.deleteProducto(id);

//       // 2. Agregar a la cola de sincronización
//       await syncService.queueProductoChange(
//         productoId: id,
//         operation: SyncOperation.delete,
//         data: {'id': id},
//       );

//       return const Right(null);
//     } on CacheException catch (e) {
//       return Left(CacheFailure(message: e.message));
//     }
//   }

//   @override
//   Future<Either<Failure, List<Producto>>> searchProductos(String query) async {
//     try {
//       final productos = await localDatasource.productoDao.searchProductos(query);
//       return Right(productos.map((p) => p.toEntity()).toList());
//     } on CacheException catch (e) {
//       return Left(CacheFailure(message: e.message));
//     }
//   }

//   /// Sincronizar productos en segundo plano
//   Future<void> _syncProductosInBackground() async {
//     try {
//       // Obtener última fecha de sincronización
//       // TODO: Guardar en SharedPreferences
//       final lastSync = DateTime.now().subtract(const Duration(hours: 1));
      
//       // Traer cambios del servidor
//       final remoteProductos = await remoteDatasource.syncProductos(lastSync);
      
//       // Actualizar base de datos local
//       for (final producto in remoteProductos) {
//         final exists = await localDatasource.productoDao
//             .getProductoById(producto.id);
        
//         if (exists != null) {
//           await localDatasource.productoDao.updateProducto(producto.toTable());
//         } else {
//           await localDatasource.productoDao.insertProducto(producto.toTable());
//         }
//       }
//     } catch (e) {
//       // Ignorar errores de sincronización en segundo plano
//       print('Error en sincronización: $e');
//     }
//   }
// }
