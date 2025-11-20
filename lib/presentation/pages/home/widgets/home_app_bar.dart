import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onNotificationsPressed;
  final VoidCallback onSyncPressed;
  final VoidCallback onSettingsPressed;
  final VoidCallback onLogoutPressed;

  const HomeAppBar({
    Key? key,
    required this.onNotificationsPressed,
    required this.onSyncPressed,
    required this.onSettingsPressed,
    required this.onLogoutPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Inicio'),
      elevation: 2,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: onNotificationsPressed,
          tooltip: 'Notificaciones',
        ),
        IconButton(
          icon: const Icon(Icons.sync),
          onPressed: onSyncPressed,
          tooltip: 'Sincronizar con servidor',
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: onSettingsPressed,
          tooltip: 'Configuración',
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: onLogoutPressed,
          tooltip: 'Cerrar Sesión',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
