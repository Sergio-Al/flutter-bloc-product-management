import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/sync/sync_manager.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';

// Menu Item Model
class MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final bool isImplemented;
  final List<String> allowedRoles; // Roles que pueden ver este item

  const MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    this.isImplemented = true,
    this.allowedRoles = const ['Administrador', 'Gerente', 'Almacenero', 'Vendedor'],
  });

  /// Verifica si el usuario tiene permiso para ver este item
  bool isAllowedForRole(String? roleName) {
    if (roleName == null) return false;
    return allowedRoles.contains(roleName);
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // Centralized menu configuration with role-based access
  static const List<MenuItem> _menuItems = [
    // ✅ Productos - Administrador, Gerente, Almacenero (lectura), Vendedor (lectura)
    MenuItem(
      icon: Icons.inventory_2,
      title: 'Productos',
      subtitle: 'Gestionar productos',
      route: '/productos',
      allowedRoles: ['Administrador', 'Gerente', 'Almacenero', 'Vendedor'],
    ),
    // ✅ Almacenes - Administrador, Gerente, Almacenero
    MenuItem(
      icon: Icons.warehouse,
      title: 'Almacenes',
      subtitle: 'Gestionar almacenes',
      route: '/almacenes',
      allowedRoles: ['Administrador', 'Gerente', 'Almacenero'],
    ),
    // ✅ Tiendas - Todos pueden ver (lectura), solo Admin puede gestionar
    MenuItem(
      icon: Icons.store,
      title: 'Tiendas',
      subtitle: 'Gestionar tiendas',
      route: '/tiendas',
      allowedRoles: ['Administrador', 'Gerente', 'Almacenero', 'Vendedor'],
    ),
    // ✅ Proveedores - Administrador, Gerente, Almacenero (lectura)
    MenuItem(
      icon: Icons.contact_page,
      title: 'Proveedores',
      subtitle: 'Gestionar proveedores',
      route: '/proveedores',
      allowedRoles: ['Administrador', 'Gerente', 'Almacenero'],
    ),
    // ✅ Lotes - Administrador, Gerente, Almacenero, Vendedor (lectura)
    MenuItem(
      icon: Icons.all_inbox,
      title: 'Lotes',
      subtitle: 'Gestionar lotes',
      route: '/lotes',
      allowedRoles: ['Administrador', 'Gerente', 'Almacenero', 'Vendedor'],
    ),
    // ✅ Inventarios - Todos
    MenuItem(
      icon: Icons.inventory,
      title: 'Inventarios',
      subtitle: 'Gestionar inventarios',
      route: '/inventarios',
      allowedRoles: ['Administrador', 'Gerente', 'Almacenero', 'Vendedor'],
    ),
    // ✅ Movimientos - Todos (Vendedor puede registrar ventas)
    MenuItem(
      icon: Icons.swap_horiz,
      title: 'Movimientos',
      subtitle: 'Gestionar movimientos',
      route: '/movimientos',
      allowedRoles: ['Administrador', 'Gerente', 'Almacenero', 'Vendedor'],
    ),
    // 🔒 Reportes - Administrador, Gerente, Almacenero (algunos), Vendedor (limitado)
    MenuItem(
      icon: Icons.assessment,
      title: 'Reportes',
      subtitle: 'Ver estadísticas',
      route: '/reportes',
      isImplemented: false,
      allowedRoles: ['Administrador', 'Gerente', 'Almacenero', 'Vendedor'],
    ),
    // 🔒 Usuarios - Solo Administrador y Gerente (lectura)
    MenuItem(
      icon: Icons.people,
      title: 'Usuarios',
      subtitle: 'Gestionar usuarios',
      route: '/usuarios',
      isImplemented: false,
      allowedRoles: ['Administrador', 'Gerente'],
    ),
    // 🔒 Análisis - Administrador, Gerente
    MenuItem(
      icon: Icons.trending_up,
      title: 'Análisis',
      subtitle: 'Dashboard analítico',
      route: '/analisis',
      isImplemented: false,
      allowedRoles: ['Administrador', 'Gerente'],
    ),
    // 🔒 Alertas - Todos
    MenuItem(
      icon: Icons.notifications,
      title: 'Alertas',
      subtitle: 'Notificaciones',
      route: '/alertas',
      isImplemented: false,
      allowedRoles: ['Administrador', 'Gerente', 'Almacenero', 'Vendedor'],
    ),
    // 🔒 Configuración - Solo Administrador
    MenuItem(
      icon: Icons.settings,
      title: 'Configuración',
      subtitle: 'Ajustes del sistema',
      route: '/configuracion',
      isImplemented: false,
      allowedRoles: ['Administrador'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          _redirectToLogin(context);
          return const _LoadingScaffold();
        }

        return Scaffold(
          appBar: _buildAppBar(context),
          drawer: _buildDrawer(context, state.user),
          body: _buildBody(context, state.user),
        );
      },
    );
  }

  /// Extrae el nombre del rol del usuario
  /// Usa el rolId del usuario para mapear al nombre del rol
  String? _getUserRoleName(dynamic user) {
    // El user es una entidad Usuario que tiene rolId (UUID string)
    final rolId = user.rolId;
    
    if (rolId == null) return null;
    
    // Mapear UUID del rol a nombre conocido
    switch (rolId) {
      case '00000000-0000-0000-0000-000000000001':
        return 'Administrador';
      case '00000000-0000-0000-0000-000000000002':
        return 'Gerente';
      case '00000000-0000-0000-0000-000000000003':
        return 'Almacenero';
      case '00000000-0000-0000-0000-000000000004':
        return 'Vendedor';
      default:
        // Si el UUID no coincide, intentar detectar por patrón
        // Esto es útil si los UUIDs son diferentes en tu BD
        return null;
    }
  }

  /// Filtra los items del menú según el rol del usuario
  List<MenuItem> _getMenuItemsForRole(dynamic user) {
    final roleName = _getUserRoleName(user);
    
    // Debug: ver qué rol se detectó
    print('🔍 DEBUG - Rol detectado: $roleName');
    
    // Si no se detecta el rol, mostrar items básicos (para evitar pantalla vacía)
    if (roleName == null) {
      print('⚠️ WARNING - No se pudo detectar el rol, mostrando items básicos');
      // Mostrar solo items implementados y seguros
      return _menuItems.where((item) => 
        item.isImplemented && 
        ['Productos', 'Inventarios', 'Movimientos'].contains(item.title)
      ).toList();
    }
    
    final filtered = _menuItems.where((item) => item.isAllowedForRole(roleName)).toList();
    print('🔍 DEBUG - Items filtrados: ${filtered.length} de ${_menuItems.length}');
    
    return filtered;
  }

  void _redirectToLogin(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Inicio'),
      elevation: 2,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () => _showComingSoon(context, 'Notificaciones'),
          tooltip: 'Notificaciones',
        ),
        IconButton(
          icon: const Icon(Icons.sync),
          onPressed: () => _handleSync(context),
          tooltip: 'Sincronizar con servidor',
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => _showComingSoon(context, 'Configuración'),
          tooltip: 'Configuración',
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => _showLogoutDialog(context),
          tooltip: 'Cerrar Sesión',
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, user) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(context, user),
            const SizedBox(height: 24),
            _buildQuickStats(context),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Accesos Rápidos'),
            const SizedBox(height: 16),
            _buildActionGrid(context, user),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, user) {
    // Debug: Imprimir información del usuario
    print('🔍 DEBUG - Usuario rolId: ${user.rolId}');
    print('🔍 DEBUG - Usuario completo: $user');
    
    final roleName = _getUserRoleName(user) ?? 'Usuario';
    final roleIcon = _getRoleIcon(roleName);
    final roleColor = _getRoleColor(roleName);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            _buildAvatar(context, user.nombreCompleto),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¡Bienvenido!',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.nombreCompleto,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(roleIcon, size: 16, color: roleColor),
                      const SizedBox(width: 4),
                      Text(
                        roleName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: roleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.email,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.inventory_2,
            label: 'Productos',
            value: '---',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.trending_up,
            label: 'Movimientos',
            value: '---',
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.warning_amber,
            label: 'Alertas',
            value: '---',
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildActionGrid(BuildContext context, dynamic user) {
    final allowedItems = _getMenuItemsForRole(user);
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: allowedItems.length,
      itemBuilder: (context, index) {
        final item = allowedItems[index];
        return _buildActionCard(
          context,
          item: item,
          onTap: () => _handleMenuItemTap(context, item),
        );
      },
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required MenuItem item,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    size: 48,
                    color: item.isImplemented
                        ? Theme.of(context).primaryColor
                        : Colors.grey[400],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: item.isImplemented ? null : Colors.grey[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (!item.isImplemented)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Próximo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, String name) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Theme.of(context).primaryColor,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, user) {
    final roleName = _getUserRoleName(user) ?? 'Usuario';
    final allowedItems = _getMenuItemsForRole(user);
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                user.nombreCompleto.isNotEmpty
                    ? user.nombreCompleto[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  fontSize: 32,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            accountName: Text(
              user.nombreCompleto,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.email),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    roleName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () => Navigator.pop(context),
          ),
          const Divider(),
          ...allowedItems.map((item) => ListTile(
                leading: Icon(item.icon),
                title: Text(item.title),
                trailing: !item.isImplemented
                    ? const Icon(Icons.lock_clock, size: 16, color: Colors.grey)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  _handleMenuItemTap(context, item);
                },
              )),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              Navigator.pop(context);
              _showComingSoon(context, 'Configuración');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _handleMenuItemTap(BuildContext context, MenuItem item) {
    if (item.isImplemented) {
      Navigator.pushNamed(context, item.route);
    } else {
      _showComingSoon(context, item.title);
    }
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature próximamente'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Obtiene el icono según el rol
  IconData _getRoleIcon(String roleName) {
    switch (roleName.toLowerCase()) {
      case 'administrador':
        return Icons.admin_panel_settings;
      case 'gerente':
        return Icons.business_center;
      case 'almacenero':
        return Icons.warehouse;
      case 'vendedor':
        return Icons.point_of_sale;
      default:
        return Icons.person;
    }
  }

  /// Obtiene el color según el rol
  Color _getRoleColor(String roleName) {
    switch (roleName.toLowerCase()) {
      case 'administrador':
        return Colors.red[700]!;
      case 'gerente':
        return Colors.blue[700]!;
      case 'almacenero':
        return Colors.green[700]!;
      case 'vendedor':
        return Colors.orange[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  Future<void> _handleSync(BuildContext context) async {
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

  void _showLogoutDialog(BuildContext context) {
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
