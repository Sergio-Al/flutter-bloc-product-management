import 'package:flutter/material.dart';

class MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final bool isImplemented;
  final List<String> allowedRoles;

  const MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    this.isImplemented = true,
    this.allowedRoles = const [
      'Administrador',
      'Gerente',
      'Almacenero',
      'Vendedor',
    ],
  });

  /// Verifica si el usuario tiene permiso para ver este item
  bool isAllowedForRole(String? roleName) {
    if (roleName == null) return false;
    return allowedRoles.contains(roleName);
  }
}
