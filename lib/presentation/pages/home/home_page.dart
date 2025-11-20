import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/sync/sync_manager.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/producto/producto_bloc.dart';
import '../../blocs/producto/producto_event.dart';
import '../../blocs/movimiento/movimiento_bloc.dart';
import '../../blocs/movimiento/movimiento_event.dart';
import 'models/menu_item.dart';
import 'utils/menu_config.dart';
import 'utils/role_utils.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_drawer.dart';
import 'widgets/welcome_card.dart';
import 'widgets/stats_section.dart';
import 'widgets/menu_grid.dart';

/// Home Page - Dashboard principal de la aplicación
///
/// Muestra información del usuario, estadísticas rápidas y accesos
/// a las diferentes secciones según el rol del usuario.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  /// Carga datos iniciales al abrir la página
  void _loadInitialData() {
    context.read<ProductoBloc>().add(LoadProductos());
    context.read<MovimientoBloc>().add(LoadMovimientos());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          _redirectToLogin();
          return const _LoadingScaffold();
        }

        final roleName = RoleUtils.getRoleNameFromId(state.user.rolId) ?? 'Usuario';
        final allowedMenuItems = MenuConfig.getMenuItemsForRole(roleName);

        return Scaffold(
          appBar: HomeAppBar(
            onNotificationsPressed: () => _showComingSoon('Notificaciones'),
            onSyncPressed: _handleSync,
            onSettingsPressed: () => _showComingSoon('Configuración'),
            onLogoutPressed: _showLogoutDialog,
          ),
          drawer: HomeDrawer(
            user: state.user,
            roleName: roleName,
            menuItems: allowedMenuItems,
            onMenuItemTap: _handleMenuItemTap,
            onSettingsTap: () => _showComingSoon('Configuración'),
            onLogoutTap: _showLogoutDialog,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WelcomeCard(user: state.user, roleName: roleName),
                  const SizedBox(height: 24),
                  const StatsSection(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Accesos Rápidos'),
                  const SizedBox(height: 16),
                  MenuGrid(
                    items: allowedMenuItems,
                    onItemTap: _handleMenuItemTap,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  void _redirectToLogin() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  void _handleMenuItemTap(MenuItem item) {
    if (item.isImplemented) {
      Navigator.pushNamed(context, item.route);
    } else {
      _showComingSoon(item.title);
    }
  }

  void _showComingSoon(String feature) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature próximamente'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleSync() async {
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    messenger.showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 16),
            Text('Sincronizando datos desde servidor...'),
          ],
        ),
        duration: Duration(seconds: 30),
      ),
    );

    try {
      final syncManager = getIt<SyncManager>();
      final result = await syncManager.syncAll();

      if (!mounted) return;
      messenger.hideCurrentSnackBar();

      result.fold(
        (failure) {
          messenger.showSnackBar(
            SnackBar(
              content: Text('Error en sincronización: ${failure.message}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        (_) {
          // Recargar datos después de sincronización exitosa
          _loadInitialData();
          
          messenger.showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 16),
                  Text('✅ Sincronización completada exitosamente'),
                ],
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text('Error inesperado: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}

class _LoadingScaffold extends StatelessWidget {
  const _LoadingScaffold();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
