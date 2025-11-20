import 'package:flutter/material.dart';
import '../../../../domain/entities/usuario.dart';
import '../models/menu_item.dart';

class HomeDrawer extends StatelessWidget {
  final Usuario user;
  final String roleName;
  final List<MenuItem> menuItems;
  final Function(MenuItem) onMenuItemTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onLogoutTap;

  const HomeDrawer({
    Key? key,
    required this.user,
    required this.roleName,
    required this.menuItems,
    required this.onMenuItemTap,
    required this.onSettingsTap,
    required this.onLogoutTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(context),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () => Navigator.pop(context),
          ),
          const Divider(),
          ...menuItems.map((item) => _buildMenuItem(context, item)),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              Navigator.pop(context);
              onSettingsTap();
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              Navigator.pop(context);
              onLogoutTap();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return UserAccountsDrawerHeader(
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
    );
  }

  Widget _buildMenuItem(BuildContext context, MenuItem item) {
    return ListTile(
      leading: Icon(item.icon),
      title: Text(item.title),
      trailing: !item.isImplemented
          ? const Icon(Icons.lock_clock, size: 16, color: Colors.grey)
          : null,
      onTap: () {
        Navigator.pop(context);
        onMenuItemTap(item);
      },
    );
  }
}
