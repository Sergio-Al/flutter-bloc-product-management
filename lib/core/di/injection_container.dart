import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_management_system/core/sync/sync_manager.dart';
import 'package:flutter_management_system/core/sync/sync_queue.dart';
import 'package:flutter_management_system/data/datasources/local/database/app_database.dart';
import 'package:flutter_management_system/data/datasources/local/database/daos/almacen_dao.dart';
import 'package:flutter_management_system/data/datasources/local/database/daos/inventario_dao.dart';
import 'package:flutter_management_system/data/datasources/local/database/daos/movimiento_dao.dart';
import 'package:flutter_management_system/data/datasources/local/database/daos/producto_dao.dart';
import 'package:flutter_management_system/data/datasources/local/database/daos/proveedor_dao.dart';
import 'package:flutter_management_system/data/datasources/local/database/daos/tienda_dao.dart';
import 'package:flutter_management_system/data/datasources/local/database/daos/lote_dao.dart';
import 'package:flutter_management_system/data/datasources/local/database/daos/rol_dao.dart';
import 'package:flutter_management_system/data/datasources/local/database/daos/usuario_dao.dart';
import 'package:flutter_management_system/data/datasources/remote/almacen_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/inventario_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/movimiento_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/producto_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/proveedor_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/tienda_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/lote_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/categoria_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/unidad_medida_remote_datasource.dart';
import 'package:flutter_management_system/data/repositories/almacen_repository_impl.dart';
import 'package:flutter_management_system/data/repositories/inventario_repository_impl.dart';
import 'package:flutter_management_system/data/repositories/movimiento_repository_impl.dart';
import 'package:flutter_management_system/data/repositories/producto_repository_impl.dart';
import 'package:flutter_management_system/data/repositories/proveedor_repository_impl.dart';
import 'package:flutter_management_system/data/repositories/tienda_repository_impl.dart';
import 'package:flutter_management_system/data/repositories/lote_repository_impl.dart';
import 'package:flutter_management_system/domain/repositories/almacen_repository.dart';
import 'package:flutter_management_system/domain/repositories/inventario_repository.dart';
import 'package:flutter_management_system/domain/repositories/movimiento_repository.dart';
import 'package:flutter_management_system/domain/repositories/producto_repository.dart';
import 'package:flutter_management_system/domain/repositories/proveedor_repository.dart';
import 'package:flutter_management_system/domain/repositories/tienda_repository.dart';
import 'package:flutter_management_system/domain/repositories/lote_repository.dart';
import 'package:flutter_management_system/domain/usecases/auth/auth_usecases.dart';
import 'package:flutter_management_system/domain/usecases/inventarios/inventario_usecases.dart';
import 'package:flutter_management_system/domain/usecases/movimientos/movimiento_usecases.dart';
import 'package:flutter_management_system/domain/usecases/productos/product_usecases.dart';
import 'package:flutter_management_system/domain/usecases/almacenes/almacen_usecases.dart';
import 'package:flutter_management_system/domain/usecases/proveedores/proveedores_usecases.dart';
import 'package:flutter_management_system/domain/usecases/tienda/tienda_usecases.dart';
import 'package:flutter_management_system/domain/usecases/lotes/lote_usecases.dart';
import 'package:flutter_management_system/presentation/blocs/almacen/almacen_bloc.dart';
import 'package:flutter_management_system/presentation/blocs/inventario/inventario_bloc.dart';
import 'package:flutter_management_system/presentation/blocs/movimiento/movimiento_bloc.dart';
import 'package:flutter_management_system/presentation/blocs/producto/producto_bloc.dart';
import 'package:flutter_management_system/presentation/blocs/proveedor/proveedor_bloc.dart';
import 'package:flutter_management_system/presentation/blocs/tienda/tienda_bloc.dart';
import 'package:flutter_management_system/presentation/blocs/lote/lote_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/local/auth_local_datasource.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../network/connectivity_observer.dart';
import '../network/network_info.dart';

final getIt = GetIt.instance;

/// Inicializa todas las dependencias del proyecto.
/// Esto debe llamarse en main() antes de runApp()
Future<void> setupDependencies() async {
  // ============================================================================
  // External Dependencies (Async initialization required)
  // ============================================================================

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // ============================================================================
  // Core - Network
  // ============================================================================

  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  getIt.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker(),
  );

  getIt.registerLazySingleton<ConnectivityObserver>(
    () => ConnectivityObserver(getIt()),
  );

  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: getIt(), connectionChecker: getIt()),
  );

  // ============================================================================
  // Data sources - Auth
  // ============================================================================

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(),
  );

  getIt.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasourceImpl(sharedPreferences: getIt()),
  );

  // ============================================================================
  // Repositories - Auth
  // ============================================================================

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDatasource: getIt(),
      localDatasource: getIt(),
      networkInfo: getIt(),
      usuarioDao: getIt(),
      rolDao: getIt(),
      tiendaDao: getIt(),
    ),
  );

  // ============================================================================
  // Use Cases - Auth
  // ============================================================================

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<RefreshTokenUsecase>(
    () => RefreshTokenUsecase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<RegisterUsecase>(
    () => RegisterUsecase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<IsAuthenticatedUsecase>(
    () => IsAuthenticatedUsecase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<GetCurrentUserUsecase>(
    () => GetCurrentUserUsecase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<UpdatePasswordUsecase>(
    () => UpdatePasswordUsecase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<ResetPasswordUsecase>(
    () => ResetPasswordUsecase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<VerifyMfaLoginUseCase>(
    () => VerifyMfaLoginUseCase(getIt<AuthRepository>()),
  );

  // ============================================================================
  // BLoCs - Auth
  // ============================================================================

  // Use registerFactory for BLoCs so each BlocProvider gets a fresh instance
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      refreshTokenUsecase: getIt<RefreshTokenUsecase>(),
      registerUsecase: getIt<RegisterUsecase>(),
      isAuthenticatedUsecase: getIt<IsAuthenticatedUsecase>(),
      getCurrentUserUsecase: getIt<GetCurrentUserUsecase>(),
      updatePasswordUsecase: getIt<UpdatePasswordUsecase>(),
      resetPasswordUsecase: getIt<ResetPasswordUsecase>(),
      verifyMfaLoginUseCase: getIt<VerifyMfaLoginUseCase>(),
    ),
  );

  // ============================================================================
  // Core - Database
  // ============================================================================

  // Sync Queue (persists pending operations)
  getIt.registerLazySingleton<SyncQueue>(
    () => SyncQueue(getIt<SharedPreferences>()),
  );

  // App Database (Drift)
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // Ensure default categories and units exist
  await getIt<AppDatabase>().ensureDefaultsExist();

  // ============================================================================
  // Data sources - Remote (Must be before SyncManager)
  // ============================================================================

  getIt.registerLazySingleton<ProductoRemoteDataSource>(
    () =>
        ProductoRemoteDataSource(authDataSource: getIt<AuthRemoteDataSource>()),
  );

  getIt.registerLazySingleton<AlmacenRemoteDataSource>(
    () => AlmacenRemoteDataSource(
      authDataSource: getIt<AuthRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<TiendaRemoteDataSource>(
    () => TiendaRemoteDataSource(
      authDataSource: getIt<AuthRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<ProveedorRemoteDataSource>(
    () => ProveedorRemoteDataSource(),
  );

  getIt.registerLazySingleton<LoteRemoteDataSource>(
    () => LoteRemoteDataSource(
      authDataSource: getIt<AuthRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<CategoriaRemoteDataSource>(
    () => CategoriaRemoteDataSource(),
  );

  getIt.registerLazySingleton<UnidadMedidaRemoteDataSource>(
    () => UnidadMedidaRemoteDataSource(),
  );

  getIt.registerLazySingleton<InventarioRemoteDataSource>(
    () => InventarioRemoteDataSource(
      authDataSource: getIt<AuthRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<MovimientoRemoteDataSource>(
    () => MovimientoRemoteDataSource(),
  );

  // ============================================================================
  // Core - Sync System (Must be after Remote DataSources)
  // ============================================================================

  // Sync Manager (coordinates offline-first sync)
  getIt.registerLazySingleton<SyncManager>(
    () => SyncManager(
      localDb: getIt<AppDatabase>(),
      syncQueue: getIt<SyncQueue>(),
      networkInfo: getIt<NetworkInfo>(),
      productoRemote: getIt<ProductoRemoteDataSource>(),
      almacenRemote: getIt<AlmacenRemoteDataSource>(),
      tiendaRemote: getIt<TiendaRemoteDataSource>(),
      proveedorRemote: getIt<ProveedorRemoteDataSource>(),
      loteRemote: getIt<LoteRemoteDataSource>(),
      categoriaRemote: getIt<CategoriaRemoteDataSource>(),
      unidadMedidaRemote: getIt<UnidadMedidaRemoteDataSource>(),
      inventarioRemote: getIt<InventarioRemoteDataSource>(),
      movimientoRemote: getIt<MovimientoRemoteDataSource>(),
    ),
  );

  // ============================================================================
  // Data sources - Local DAOs
  // ============================================================================

  getIt.registerLazySingleton<UsuarioDao>(
    () => getIt<AppDatabase>().usuarioDao,
  );

  getIt.registerLazySingleton<RolDao>(
    () => getIt<AppDatabase>().rolDao,
  );

  getIt.registerLazySingleton<ProductoDao>(
    () => getIt<AppDatabase>().productoDao,
  );

  // ============================================================================
  // Repositories - Productos
  // ============================================================================

  getIt.registerLazySingleton<ProductoRepository>(
    () => ProductoRepositoryImpl(
      remoteDataSource: getIt<ProductoRemoteDataSource>(),
      productoDao: getIt<ProductoDao>(),
      networkInfo: getIt<NetworkInfo>(),
      syncManager: getIt<SyncManager>(),
    ),
  );

  // ============================================================================
  // Use Cases - Productos
  // ============================================================================

  getIt.registerLazySingleton<GetProductosUsecase>(
    () => GetProductosUsecase(getIt<ProductoRepository>()),
  );

  getIt.registerLazySingleton<GetProductosActivosUseCase>(
    () => GetProductosActivosUseCase(repository: getIt<ProductoRepository>()),
  );

  getIt.registerLazySingleton<GetProductoByCodigoUsecase>(
    () => GetProductoByCodigoUsecase(getIt<ProductoRepository>()),
  );

  getIt.registerLazySingleton<CreateProductoUsecase>(
    () => CreateProductoUsecase(repository: getIt<ProductoRepository>()),
  );

  getIt.registerLazySingleton<UpdateProductoUseCase>(
    () => UpdateProductoUseCase(repository: getIt<ProductoRepository>()),
  );

  getIt.registerLazySingleton<DeleteProductoUsecase>(
    () => DeleteProductoUsecase(repository: getIt<ProductoRepository>()),
  );

  getIt.registerLazySingleton<GetProductoByIdUsecase>(
    () => GetProductoByIdUsecase(getIt<ProductoRepository>()),
  );

  // ============================================================================
  // BLoCs - Productos
  // ============================================================================

  getIt.registerFactory<ProductoBloc>(
    () => ProductoBloc(
      getProductosUsecase: getIt<GetProductosUsecase>(),
      getProductosActivosUseCase: getIt<GetProductosActivosUseCase>(),
      getProductoByCodigoUsecase: getIt<GetProductoByCodigoUsecase>(),
      createProductoUsecase: getIt<CreateProductoUsecase>(),
      updateProductoUsecase: getIt<UpdateProductoUseCase>(),
      deleteProductoUsecase: getIt<DeleteProductoUsecase>(),
      getProductoByIdUsecase: getIt<GetProductoByIdUsecase>(),
    ),
  );

  // ============================================================================
  // Data sources - Almacenes (Local)
  // ============================================================================

  getIt.registerLazySingleton<AlmacenDao>(
    () => getIt<AppDatabase>().almacenDao,
  );

  // ============================================================================
  // Repositories - Almacenes
  // ============================================================================

  getIt.registerLazySingleton<AlmacenRepository>(
    () => AlmacenRepositoryImpl(
      remoteDataSource: getIt<AlmacenRemoteDataSource>(),
      almacenDao: getIt<AlmacenDao>(),
      networkInfo: getIt<NetworkInfo>(),
      syncManager: getIt<SyncManager>(),
    ),
  );

  // ============================================================================
  // Use Cases - Almacenes
  // ============================================================================

  getIt.registerLazySingleton<GetAlmacenesUseCase>(
    () => GetAlmacenesUseCase(getIt<AlmacenRepository>()),
  );

  getIt.registerLazySingleton<GetAlmacenByIdUseCase>(
    () => GetAlmacenByIdUseCase(getIt<AlmacenRepository>()),
  );

  getIt.registerLazySingleton<GetAlmacenByCodigoUsecase>(
    () => GetAlmacenByCodigoUsecase(getIt<AlmacenRepository>()),
  );

  getIt.registerLazySingleton<GetAlmacenPrincipalUsecase>(
    () => GetAlmacenPrincipalUsecase(getIt<AlmacenRepository>()),
  );

  getIt.registerLazySingleton<GetAlmacenesActivosUsecase>(
    () => GetAlmacenesActivosUsecase(getIt<AlmacenRepository>()),
  );

  getIt.registerLazySingleton<GetAlmacenesByTiendaUsecase>(
    () => GetAlmacenesByTiendaUsecase(getIt<AlmacenRepository>()),
  );

  getIt.registerLazySingleton<GetAlmacenesByTipoUsecase>(
    () => GetAlmacenesByTipoUsecase(getIt<AlmacenRepository>()),
  );

  getIt.registerLazySingleton<SearchAlmacenesUsecase>(
    () => SearchAlmacenesUsecase(almacenRepository: getIt<AlmacenRepository>()),
  );

  getIt.registerLazySingleton<ToggleAlmacenActivoUsecase>(
    () => ToggleAlmacenActivoUsecase(getIt<AlmacenRepository>()),
  );

  getIt.registerLazySingleton<CreateAlmacenUsecase>(
    () => CreateAlmacenUsecase(getIt<AlmacenRepository>()),
  );

  getIt.registerLazySingleton<UpdateAlmacenUsecase>(
    () => UpdateAlmacenUsecase(getIt<AlmacenRepository>()),
  );

  getIt.registerLazySingleton<DeleteAlmacenUsecase>(
    () => DeleteAlmacenUsecase(getIt<AlmacenRepository>()),
  );

  // ============================================================================
  // BLoCs - Almacenes
  // ============================================================================
  getIt.registerFactory<AlmacenBloc>(
    () => AlmacenBloc(
      getAlmacenesUsecase: getIt<GetAlmacenesUseCase>(),
      getAlmacenByIdUsecase: getIt<GetAlmacenByIdUseCase>(),
      createAlmacenUsecase: getIt<CreateAlmacenUsecase>(),
      updateAlmacenUsecase: getIt<UpdateAlmacenUsecase>(),
      deleteAlmacenUsecase: getIt<DeleteAlmacenUsecase>(),
      getAlmacenByCodigoUsecase: getIt<GetAlmacenByCodigoUsecase>(),
      getAlmacenPrincipalUsecase: getIt<GetAlmacenPrincipalUsecase>(),
      getAlmacenesActivosUsecase: getIt<GetAlmacenesActivosUsecase>(),
      getAlmacenesByTiendaUsecase: getIt<GetAlmacenesByTiendaUsecase>(),
      getAlmacenesByTipoUsecase: getIt<GetAlmacenesByTipoUsecase>(),
      searchAlmacenesUsecase: getIt<SearchAlmacenesUsecase>(),
      toggleAlmacenActivoUsecase: getIt<ToggleAlmacenActivoUsecase>(),
    ),
  );

  // ============================================================================
  // Data sources - Tiendas (Local)
  // ============================================================================

  getIt.registerLazySingleton<TiendaDao>(() => getIt<AppDatabase>().tiendaDao);

  // ============================================================================
  // Repositories - Tiendas
  // ============================================================================

  getIt.registerLazySingleton<TiendaRepository>(
    () => TiendaRepositoryImpl(
      remoteDataSource: getIt<TiendaRemoteDataSource>(),
      tiendaDao: getIt<TiendaDao>(),
      networkInfo: getIt<NetworkInfo>(),
      syncManager: getIt<SyncManager>(),
    ),
  );

  // ============================================================================
  // Use Cases - Tiendas
  // ============================================================================
  getIt.registerLazySingleton<GetTiendasUsecase>(
    () => GetTiendasUsecase(tiendaRepository: getIt<TiendaRepository>()),
  );

  getIt.registerLazySingleton<ToggleTiendaActivaUsecase>(
    () =>
        ToggleTiendaActivaUsecase(tiendaRepository: getIt<TiendaRepository>()),
  );

  getIt.registerLazySingleton<CreateTiendaUsecase>(
    () => CreateTiendaUsecase(tiendaRepository: getIt<TiendaRepository>()),
  );

  getIt.registerLazySingleton<UpdateTiendaUsecase>(
    () => UpdateTiendaUsecase(tiendaRepository: getIt<TiendaRepository>()),
  );

  getIt.registerLazySingleton<DeleteTiendaUsecase>(
    () => DeleteTiendaUsecase(tiendaRepository: getIt<TiendaRepository>()),
  );

  getIt.registerLazySingleton<GetTiendaByCodigoUsecase>(
    () => GetTiendaByCodigoUsecase(tiendaRepository: getIt<TiendaRepository>()),
  );

  getIt.registerLazySingleton<GetTiendaByIdUsecase>(
    () => GetTiendaByIdUsecase(tiendaRepository: getIt<TiendaRepository>()),
  );

  getIt.registerLazySingleton<GetTiendasActivasUsecase>(
    () => GetTiendasActivasUsecase(tiendaRepository: getIt<TiendaRepository>()),
  );

  getIt.registerLazySingleton<GetTiendasByCiudadUsecase>(
    () =>
        GetTiendasByCiudadUsecase(tiendaRepository: getIt<TiendaRepository>()),
  );
  getIt.registerLazySingleton<GetTiendasByDepartamentoUsecase>(
    () => GetTiendasByDepartamentoUsecase(
      tiendaRepository: getIt<TiendaRepository>(),
    ),
  );

  // ============================================================================
  // BLoCs - Tiendas
  // ============================================================================

  getIt.registerFactory<TiendaBloc>(
    () => TiendaBloc(
      getTiendasUsecase: getIt<GetTiendasUsecase>(),
      toggleTiendaActivaUsecase: getIt<ToggleTiendaActivaUsecase>(),
      createTiendaUsecase: getIt<CreateTiendaUsecase>(),
      updateTiendaUsecase: getIt<UpdateTiendaUsecase>(),
      deleteTiendaUsecase: getIt<DeleteTiendaUsecase>(),
      getTiendaByCodigoUsecase: getIt<GetTiendaByCodigoUsecase>(),
      getTiendaByIdUsecase: getIt<GetTiendaByIdUsecase>(),
      getTiendasActivasUsecase: getIt<GetTiendasActivasUsecase>(),
      getTiendasByCiudadUsecase: getIt<GetTiendasByCiudadUsecase>(),
      getTiendasByDepartamentoUsecase: getIt<GetTiendasByDepartamentoUsecase>(),
    ),
  );

  // ============================================================================
  // Data sources - Proveedores (Local)
  // ============================================================================

  getIt.registerLazySingleton<ProveedorDao>(
    () => getIt<AppDatabase>().proveedorDao,
  );

  // ============================================================================
  // Repositories - Proveedores
  // ============================================================================
  getIt.registerLazySingleton<ProveedorRepository>(
    () => ProveedorRepositoryImpl(
      remoteDataSource: getIt<ProveedorRemoteDataSource>(),
      proveedorDao: getIt<ProveedorDao>(),
      networkInfo: getIt<NetworkInfo>(),
      syncManager: getIt<SyncManager>(),
    ),
  );

  // ============================================================================
  // Use Cases - Proveedores
  // ============================================================================

  getIt.registerLazySingleton<GetProveedoresUsecase>(
    () => GetProveedoresUsecase(
      proveedorRepository: getIt<ProveedorRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetProveedoresActivosUsecase>(
    () => GetProveedoresActivosUsecase(
      proveedorRepository: getIt<ProveedorRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetProveedorByIdUsecase>(
    () => GetProveedorByIdUsecase(
      proveedorRepository: getIt<ProveedorRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetProveedorByNitUsecase>(
    () => GetProveedorByNitUsecase(
      proveedorRepository: getIt<ProveedorRepository>(),
    ),
  );

  getIt.registerLazySingleton<SearchProveedoresUsecase>(
    () => SearchProveedoresUsecase(
      proveedorRepository: getIt<ProveedorRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetProveedoresByCiudadUsecase>(
    () => GetProveedoresByCiudadUsecase(
      proveedorRepository: getIt<ProveedorRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetProveedoresByTipoMaterialUsecase>(
    () => GetProveedoresByTipoMaterialUsecase(
      proveedorRepository: getIt<ProveedorRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetProveedoresConCreditoUsecase>(
    () => GetProveedoresConCreditoUsecase(
      proveedorRepository: getIt<ProveedorRepository>(),
    ),
  );

  getIt.registerLazySingleton<CreateProveedorUsecase>(
    () => CreateProveedorUsecase(getIt<ProveedorRepository>()),
  );

  getIt.registerLazySingleton<UpdateProveedorUsecase>(
    () => UpdateProveedorUsecase(
      proveedorRepository: getIt<ProveedorRepository>(),
    ),
  );

  getIt.registerLazySingleton<DeleteProveedorUsecase>(
    () => DeleteProveedorUsecase(getIt<ProveedorRepository>()),
  );

  getIt.registerLazySingleton<ToggleProveedorActivoUsecase>(
    () => ToggleProveedorActivoUsecase(
      proveedorRepository: getIt<ProveedorRepository>(),
    ),
  );

  // ============================================================================
  // BLoCs - Proveedores
  // ============================================================================

  getIt.registerFactory<ProveedorBloc>(
    () => ProveedorBloc(
      getProveedores: getIt<GetProveedoresUsecase>(),
      getProveedoresActivos: getIt<GetProveedoresActivosUsecase>(),
      getProveedorById: getIt<GetProveedorByIdUsecase>(),
      getProveedorByNit: getIt<GetProveedorByNitUsecase>(),
      searchProveedores: getIt<SearchProveedoresUsecase>(),
      getProveedoresByCiudad: getIt<GetProveedoresByCiudadUsecase>(),
      getProveedoresByTipoMaterial:
          getIt<GetProveedoresByTipoMaterialUsecase>(),
      getProveedoresConCredito: getIt<GetProveedoresConCreditoUsecase>(),
      createProveedor: getIt<CreateProveedorUsecase>(),
      updateProveedor: getIt<UpdateProveedorUsecase>(),
      deleteProveedor: getIt<DeleteProveedorUsecase>(),
      toggleProveedorActivo: getIt<ToggleProveedorActivoUsecase>(),
    ),
  );

  // ============================================================================
  // Data sources - Lotes (Local)
  // ============================================================================

  getIt.registerLazySingleton<LoteDao>(() => getIt<AppDatabase>().loteDao);

  // ============================================================================
  // Repositories - Lotes
  // ============================================================================
  getIt.registerLazySingleton<LoteRepository>(
    () => LoteRepositoryImpl(
      remoteDataSource: getIt<LoteRemoteDataSource>(),
      loteDao: getIt<LoteDao>(),
      networkInfo: getIt<NetworkInfo>(),
      syncManager: getIt<SyncManager>(),
    ),
  );

  // ============================================================================
  // Use Cases - Lotes
  // ============================================================================

  getIt.registerLazySingleton<GetLotesUsecase>(
    () => GetLotesUsecase(getIt<LoteRepository>()),
  );

  getIt.registerLazySingleton<GetLoteByIdUsecase>(
    () => GetLoteByIdUsecase(getIt<LoteRepository>()),
  );

  getIt.registerLazySingleton<GetLoteByNumeroUsecase>(
    () => GetLoteByNumeroUsecase(getIt<LoteRepository>()),
  );

  getIt.registerLazySingleton<SearchLotesUsecase>(
    () => SearchLotesUsecase(getIt<LoteRepository>()),
  );

  getIt.registerLazySingleton<GetLotesByProductoUsecase>(
    () => GetLotesByProductoUsecase(getIt<LoteRepository>()),
  );

  getIt.registerLazySingleton<GetLotesByProveedorUsecase>(
    () => GetLotesByProveedorUsecase(getIt<LoteRepository>()),
  );

  getIt.registerLazySingleton<GetLotesByFacturaUsecase>(
    () => GetLotesByFacturaUsecase(getIt<LoteRepository>()),
  );

  getIt.registerLazySingleton<GetLotesConStockUsecase>(
    () => GetLotesConStockUsecase(getIt<LoteRepository>()),
  );

  getIt.registerLazySingleton<GetLotesVaciosUsecase>(
    () => GetLotesVaciosUsecase(getIt<LoteRepository>()),
  );

  getIt.registerLazySingleton<GetLotesVencidosUsecase>(
    () => GetLotesVencidosUsecase(getIt<LoteRepository>()),
  );

  getIt.registerLazySingleton<GetLotesPorVencerUsecase>(
    () => GetLotesPorVencerUsecase(getIt<LoteRepository>()),
  );

  getIt.registerLazySingleton<GetLotesConCertificadoUsecase>(
    () => GetLotesConCertificadoUsecase(getIt<LoteRepository>()),
  );

  getIt.registerLazySingleton<CreateLoteUsecase>(
    () => CreateLoteUsecase(getIt<LoteRepository>()),
  );

  getIt.registerLazySingleton<UpdateLoteUsecase>(
    () => UpdateLoteUsecase(getIt<LoteRepository>()),
  );

  getIt.registerLazySingleton<UpdateCantidadLoteUsecase>(
    () => UpdateCantidadLoteUsecase(getIt<LoteRepository>()),
  );

  getIt.registerLazySingleton<DeleteLoteUsecase>(
    () => DeleteLoteUsecase(getIt<LoteRepository>()),
  );

  // ============================================================================
  // BLoCs - Lotes
  // ============================================================================

  getIt.registerFactory<LoteBloc>(
    () => LoteBloc(
      getLotes: getIt<GetLotesUsecase>(),
      getLoteById: getIt<GetLoteByIdUsecase>(),
      getLoteByNumero: getIt<GetLoteByNumeroUsecase>(),
      searchLotes: getIt<SearchLotesUsecase>(),
      getLotesByProducto: getIt<GetLotesByProductoUsecase>(),
      getLotesByProveedor: getIt<GetLotesByProveedorUsecase>(),
      getLotesByFactura: getIt<GetLotesByFacturaUsecase>(),
      getLotesConStock: getIt<GetLotesConStockUsecase>(),
      getLotesVacios: getIt<GetLotesVaciosUsecase>(),
      getLotesVencidos: getIt<GetLotesVencidosUsecase>(),
      getLotesPorVencer: getIt<GetLotesPorVencerUsecase>(),
      getLotesConCertificado: getIt<GetLotesConCertificadoUsecase>(),
      createLote: getIt<CreateLoteUsecase>(),
      updateLote: getIt<UpdateLoteUsecase>(),
      updateCantidadLote: getIt<UpdateCantidadLoteUsecase>(),
      deleteLote: getIt<DeleteLoteUsecase>(),
    ),
  );

  // ============================================================================
  // Data sources - Inventarios (Local)
  // ============================================================================

  getIt.registerLazySingleton<InventarioDao>(
    () => getIt<AppDatabase>().inventarioDao,
  );

  // ============================================================================
  // Repositories - Inventarios
  // ============================================================================
  getIt.registerLazySingleton<InventarioRepository>(
    () => InventarioRepositoryImpl(
      remoteDataSource: getIt<InventarioRemoteDataSource>(),
      inventarioDao: getIt<InventarioDao>(),
      networkInfo: getIt<NetworkInfo>(),
      syncManager: getIt<SyncManager>(),
    ),
  );

  // ============================================================================
  // Use Cases - Inventarios
  // ============================================================================

  getIt.registerLazySingleton<GetInventariosUsecase>(
    () => GetInventariosUsecase(getIt<InventarioRepository>()),
  );

  getIt.registerLazySingleton<GetInventarioByIdUsecase>(
    () => GetInventarioByIdUsecase(getIt<InventarioRepository>()),
  );

  getIt.registerLazySingleton<GetInventariosByProductoUsecase>(
    () => GetInventariosByProductoUsecase(getIt<InventarioRepository>()),
  );

  getIt.registerLazySingleton<GetInventariosByAlmacenUsecase>(
    () => GetInventariosByAlmacenUsecase(getIt<InventarioRepository>()),
  );

  getIt.registerLazySingleton<GetInventariosByLoteUsecase>(
    () => GetInventariosByLoteUsecase(getIt<InventarioRepository>()),
  );

  getIt.registerLazySingleton<GetInventariosByTiendaUsecase>(
    () => GetInventariosByTiendaUsecase(getIt<InventarioRepository>()),
  );

  getIt.registerLazySingleton<GetInventariosDisponiblesUsecase>(
    () => GetInventariosDisponiblesUsecase(getIt<InventarioRepository>()),
  );

  getIt.registerLazySingleton<GetInventariosStockBajoUsecase>(
    () => GetInventariosStockBajoUsecase(getIt<InventarioRepository>()),
  );

  getIt.registerLazySingleton<CreateInventarioUsecase>(
    () => CreateInventarioUsecase(getIt<InventarioRepository>()),
  );

  getIt.registerLazySingleton<UpdateInventarioUsecase>(
    () => UpdateInventarioUsecase(getIt<InventarioRepository>()),
  );

  getIt.registerLazySingleton<UpdateStockUsecase>(
    () => UpdateStockUsecase(getIt<InventarioRepository>()),
  );

  getIt.registerLazySingleton<ReservarStockUsecase>(
    () => ReservarStockUsecase(getIt<InventarioRepository>()),
  );

  getIt.registerLazySingleton<LiberarStockUsecase>(
    () => LiberarStockUsecase(getIt<InventarioRepository>()),
  );

  getIt.registerLazySingleton<DeleteInventarioUsecase>(
    () => DeleteInventarioUsecase(getIt<InventarioRepository>()),
  );

  getIt.registerLazySingleton<AjustarInventarioUsecase>(
    () => AjustarInventarioUsecase(getIt<InventarioRepository>()),
  );

  // ============================================================================
  // BLoCs - Inventarios
  // ============================================================================

  getIt.registerFactory<InventarioBloc>(
    () => InventarioBloc(
      getInventarios: getIt<GetInventariosUsecase>(),
      getInventarioById: getIt<GetInventarioByIdUsecase>(),
      getInventariosByProducto: getIt<GetInventariosByProductoUsecase>(),
      getInventariosByAlmacen: getIt<GetInventariosByAlmacenUsecase>(),
      getInventariosByLote: getIt<GetInventariosByLoteUsecase>(),
      getInventariosByTienda: getIt<GetInventariosByTiendaUsecase>(),
      getInventariosDisponibles: getIt<GetInventariosDisponiblesUsecase>(),
      getInventariosStockBajo: getIt<GetInventariosStockBajoUsecase>(),
      createInventario: getIt<CreateInventarioUsecase>(),
      updateInventario: getIt<UpdateInventarioUsecase>(),
      updateStockInventario: getIt<UpdateStockUsecase>(),
      reservarStockInventario: getIt<ReservarStockUsecase>(),
      liberarStockInventario: getIt<LiberarStockUsecase>(),
      deleteInventario: getIt<DeleteInventarioUsecase>(),
      ajustarInventario: getIt<AjustarInventarioUsecase>(),
    ),
  );

  // ============================================================================
  // Data sources - Movimientos (Local)
  // ============================================================================

  getIt.registerLazySingleton<MovimientoDao>(
    () => getIt<AppDatabase>().movimientoDao,
  );

  // ============================================================================
  // Repositories - Movimientos
  // ============================================================================

  getIt.registerLazySingleton<MovimientoRepository>(
    () => MovimientoRepositoryImpl(
      movimientoDao: getIt<MovimientoDao>(),
      remoteDataSource: getIt<MovimientoRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
      syncManager: getIt<SyncManager>(),
    ),
  );

  // ============================================================================
  // Use Cases - Movimientos
  // ============================================================================

  getIt.registerLazySingleton<GetMovimientosUsecase>(
    () => GetMovimientosUsecase(
      movimientoRepository: getIt<MovimientoRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetMovimientoByIdUsecase>(
    () => GetMovimientoByIdUsecase(
      movimientoRepository: getIt<MovimientoRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetMovimientoByNumeroUsecase>(
    () => GetMovimientoByNumeroUsecase(
      movimientoRepository: getIt<MovimientoRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetMovimientosByProductoUsecase>(
    () => GetMovimientosByProductoUsecase(
      movimientoRepository: getIt<MovimientoRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetMovimientosByTiendaUsecase>(
    () => GetMovimientosByTiendaUsecase(
      movimientoRepository: getIt<MovimientoRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetMovimientosByUsuarioUsecase>(
    () => GetMovimientosByUsuarioUsecase(
      movimientoRepository: getIt<MovimientoRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetMovimientosByTipoUsecase>(
    () => GetMovimientosByTipoUsecase(
      movimientoRepository: getIt<MovimientoRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetMovimientosByEstadoUsecase>(
    () => GetMovimientosByEstadoUsecase(
      movimientoRepository: getIt<MovimientoRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetMovimientosByFechaRangoUsecase>(
    () => GetMovimientosByFechaRangoUsecase(
      movimientoRepository: getIt<MovimientoRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetMovimientosPendientesUsecase>(
    () => GetMovimientosPendientesUsecase(
      movimientoRepository: getIt<MovimientoRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetMovimientosEnTransitoUsecase>(
    () => GetMovimientosEnTransitoUsecase(
      movimientoRepository: getIt<MovimientoRepository>(),
    ),
  );

  getIt.registerLazySingleton<CreateCompraUsecase>(
    () => CreateCompraUsecase(
      movimientoRepository: getIt<MovimientoRepository>(),
      getCurrentUserUsecase: getIt<GetCurrentUserUsecase>(),
    ),
  );

  getIt.registerLazySingleton<CreateVentaUsecase>(
    () => CreateVentaUsecase(
      movimientoRepository: getIt<MovimientoRepository>(),
      getCurrentUserUsecase: getIt<GetCurrentUserUsecase>(),
    ),
  );

  getIt.registerLazySingleton<CreateTransferenciaUsecase>(
    () => CreateTransferenciaUsecase(
      movimientoRepository: getIt<MovimientoRepository>(),
      getCurrentUserUsecase: getIt<GetCurrentUserUsecase>(),
    ),
  );

  getIt.registerLazySingleton<CreateAjusteUsecase>(
    () => CreateAjusteUsecase(
      movimientoRepository: getIt<MovimientoRepository>(),
      getCurrentUserUsecase: getIt<GetCurrentUserUsecase>(),
    ),
  );

  getIt.registerLazySingleton<CreateDevolucionUsecase>(
    () => CreateDevolucionUsecase(
      movimientoRepository: getIt<MovimientoRepository>(),
      getCurrentUserUsecase: getIt<GetCurrentUserUsecase>(),
    ),
  );

  getIt.registerLazySingleton<CreateMermaUsecase>(
    () => CreateMermaUsecase(
      movimientoRepository: getIt<MovimientoRepository>(),
      getCurrentUserUsecase: getIt<GetCurrentUserUsecase>(),
    ),
  );

  getIt.registerLazySingleton<UpdateMovimientoUsecase>(
    () => UpdateMovimientoUsecase(
      movimientoRepository: getIt<MovimientoRepository>(),
    ),
  );

  getIt.registerLazySingleton<CompletarMovimientoUsecase>(
    () => CompletarMovimientoUsecase(
      movimientoRepository: getIt<MovimientoRepository>(),
    ),
  );

  getIt.registerLazySingleton<CancelarMovimientoUsecase>(
    () => CancelarMovimientoUsecase(
      movimientoRepository: getIt<MovimientoRepository>(),
    ),
  );

  // ============================================================================
  // BLoCs - Movimientos
  // ============================================================================

  getIt.registerFactory<MovimientoBloc>(
    () => MovimientoBloc(
      getMovimientos: getIt<GetMovimientosUsecase>(),
      getMovimientoById: getIt<GetMovimientoByIdUsecase>(),
      getMovimientoByNumero: getIt<GetMovimientoByNumeroUsecase>(),
      getMovimientosByProducto: getIt<GetMovimientosByProductoUsecase>(),
      getMovimientosByTienda: getIt<GetMovimientosByTiendaUsecase>(),
      getMovimientosByUsuario: getIt<GetMovimientosByUsuarioUsecase>(),
      getMovimientosByTipo: getIt<GetMovimientosByTipoUsecase>(),
      getMovimientosByEstado: getIt<GetMovimientosByEstadoUsecase>(),
      getMovimientosByFechaRango: getIt<GetMovimientosByFechaRangoUsecase>(),
      getMovimientosPendientes: getIt<GetMovimientosPendientesUsecase>(),
      getMovimientosEnTransito: getIt<GetMovimientosEnTransitoUsecase>(),
      createCompra: getIt<CreateCompraUsecase>(),
      createVenta: getIt<CreateVentaUsecase>(),
      createTransferencia: getIt<CreateTransferenciaUsecase>(),
      createAjuste: getIt<CreateAjusteUsecase>(),
      createDevolucion: getIt<CreateDevolucionUsecase>(),
      createMerma: getIt<CreateMermaUsecase>(),
      updateMovimiento: getIt<UpdateMovimientoUsecase>(),
      completarMovimiento: getIt<CompletarMovimientoUsecase>(),
      cancelarMovimiento: getIt<CancelarMovimientoUsecase>(),
    ),
  );
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}
