import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_management_system/core/sync/sync_manager.dart';
import 'package:flutter_management_system/core/sync/sync_queue.dart';
import 'package:flutter_management_system/data/datasources/local/database/app_database.dart';
import 'package:flutter_management_system/data/datasources/local/database/daos/almacen_dao.dart';
import 'package:flutter_management_system/data/datasources/local/database/daos/producto_dao.dart';
import 'package:flutter_management_system/data/datasources/remote/almacen_remote_datasource.dart';
import 'package:flutter_management_system/data/datasources/remote/producto_remote_datasource.dart';
import 'package:flutter_management_system/data/repositories/almacen_repository_impl.dart';
import 'package:flutter_management_system/data/repositories/producto_repository_impl.dart';
import 'package:flutter_management_system/domain/repositories/almacen_repository.dart';
import 'package:flutter_management_system/domain/repositories/producto_repository.dart';
import 'package:flutter_management_system/domain/usecases/auth/auth_usecases.dart';
import 'package:flutter_management_system/domain/usecases/productos/product_usecases.dart';
import 'package:flutter_management_system/domain/usecases/almacenes/almacen_usecases.dart';
import 'package:flutter_management_system/presentation/blocs/almacen/almacen_bloc.dart';
import 'package:flutter_management_system/presentation/blocs/producto/producto_bloc.dart';
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
    ),
  );

  // ============================================================================
  // Core - Sync System
  // ============================================================================

  // Sync Queue (persists pending operations)
  getIt.registerLazySingleton<SyncQueue>(
    () => SyncQueue(getIt<SharedPreferences>()),
  );

  // App Database (Drift)
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // Ensure default categories and units exist
  await getIt<AppDatabase>().ensureDefaultsExist();

  // Sync Manager (coordinates offline-first sync)
  getIt.registerLazySingleton<SyncManager>(
    () => SyncManager(
      localDb: getIt<AppDatabase>(),
      syncQueue: getIt<SyncQueue>(),
      networkInfo: getIt<NetworkInfo>(),
      productoRemote: getIt<ProductoRemoteDataSource>(),
      almacenRemote: getIt<AlmacenRemoteDataSource>(),
      // TODO: Add other remote datasources as they're created
    ),
  );

  // ============================================================================
  // Data sources - Productos
  // ============================================================================

  getIt.registerLazySingleton<ProductoRemoteDataSource>(
    () => ProductoRemoteDataSource(),
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

  // ========================================================================
  // Data sources - Almacenes
  // ========================================================================
  getIt.registerLazySingleton<AlmacenRemoteDataSource>(
    () => AlmacenRemoteDataSource(),
  );

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
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}
