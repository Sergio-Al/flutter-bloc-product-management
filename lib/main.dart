import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_management_system/presentation/blocs/almacen/almacen_bloc.dart';
import 'package:flutter_management_system/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_management_system/presentation/blocs/inventario/inventario_bloc.dart';
import 'package:flutter_management_system/presentation/blocs/lote/lote_bloc.dart';
import 'package:flutter_management_system/presentation/blocs/movimiento/movimiento_bloc.dart';
import 'package:flutter_management_system/presentation/blocs/proveedor/proveedor_bloc.dart';
import 'package:flutter_management_system/presentation/blocs/tienda/tienda_bloc.dart';
import 'package:flutter_management_system/presentation/pages/almacenes/almacenes_list_page.dart';
import 'package:flutter_management_system/presentation/pages/inventarios/inventarios_list_page.dart';
import 'package:flutter_management_system/presentation/pages/lotes/lotes_list_page.dart';
import 'package:flutter_management_system/presentation/pages/movimientos/movimientos_list_page.dart';
import 'package:flutter_management_system/presentation/pages/proveedores/proveedores_list_page.dart';
import 'package:flutter_management_system/presentation/pages/tiendas/tiendas_list_page.dart';

import 'core/config/env_config.dart';
import 'core/config/supabase_config.dart';
import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/pages/auth/forgot_password_page.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/auth/register_page.dart';
import 'presentation/pages/auth/splash_screen.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/productos/productos_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await EnvConfig.load();

  // Initialize Supabase
  await SupabaseConfig.initialize();

  // Setup dependency injection
  await setupDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>()..add(AuthCheckStatusRequested()),
      child: MaterialApp(
        title: 'Flutter Management System',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/forgot-password': (context) => const ForgotPasswordPage(),
          '/home': (context) => const HomePage(),
          '/productos': (context) => const ProductosListPage(),
          '/almacenes': (context) => BlocProvider<AlmacenBloc>(
            create: (context) => getIt<AlmacenBloc>(),
            child: const AlmacenesListPage(),
          ),
          '/tiendas': (context) => BlocProvider<TiendaBloc>(
            create: (context) => getIt<TiendaBloc>(),
            child: const TiendasListPage(),
          ),
          '/proveedores': (context) => BlocProvider<ProveedorBloc>(
            create: (context) => getIt<ProveedorBloc>(),
            child: const ProveedoresListPage(),
          ),
          '/lotes': (context) => BlocProvider<LoteBloc>(
            create: (context) => getIt<LoteBloc>(),
            child: const LotesListPage(),
          ),
          '/inventarios': (context) => BlocProvider<InventarioBloc>(
            create: (context) => getIt<InventarioBloc>(),
            child: const InventariosListPage(),
          ),
          '/movimientos': (context) => BlocProvider<MovimientoBloc>(
            create: (context) => getIt<MovimientoBloc>(),
            child: const MovimientosListPage(),
          ),
        },
      ),
    );
  }
}
