import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_management_system/domain/usecases/auth/auth_usecases.dart';
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
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}
