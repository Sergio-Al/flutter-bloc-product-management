import 'package:flutter/material.dart';

class RoleUtils {
  /// Obtiene el nombre del rol del usuario
  /// Ahora usa directamente rolNombre del usuario en lugar de mapear UUIDs
  static String? getRoleNameFromUser(String? rolNombre) {
    return rolNombre;
  }

  /// Mapea un UUID de rol a su nombre (legacy - usar getRoleNameFromUser)
  @Deprecated('Use getRoleNameFromUser instead - the API now returns the role name directly')
  static String? getRoleNameFromId(String? rolId) {
    if (rolId == null) return null;

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
        return null;
    }
  }

  /// Obtiene el icono según el rol
  static IconData getRoleIcon(String roleName) {
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
  static Color getRoleColor(String roleName) {
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
}
