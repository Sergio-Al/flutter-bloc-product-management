import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class MenuConfig {
  /// Valid backend roles: Administrador, Gerente, Almacenero, Vendedor
  /// Permissions based on PERMISOS.md from NestJS backend
  static const List<MenuItem> menuItems = [
    // ✅ Productos - Todos los roles (todos tienen al menos lectura)
    // Admin: 📖, Gerente: ✅ CRU, Almacenero: 📖, Vendedor: 📖
    MenuItem(
      icon: Icons.inventory_2,
      title: 'Productos',
      subtitle: 'Gestionar productos',
      route: '/productos',
      allowedRoles: ['Administrador', 'Gerente', 'Almacenero', 'Vendedor'],
    ),
    // ✅ Almacenes - Todos los roles (todos tienen al menos lectura)
    // Admin: 📖, Gerente: ✅, Almacenero: ✏️, Vendedor: 📖
    MenuItem(
      icon: Icons.warehouse,
      title: 'Almacenes',
      subtitle: 'Gestionar almacenes',
      route: '/almacenes',
      allowedRoles: ['Administrador', 'Gerente', 'Almacenero', 'Vendedor'],
    ),
    // ✅ Tiendas - Todos los roles (todos tienen al menos lectura)
    // Admin: ✅, Gerente: ✏️, Almacenero: 📖, Vendedor: 📖
    MenuItem(
      icon: Icons.store,
      title: 'Tiendas',
      subtitle: 'Gestionar tiendas',
      route: '/tiendas',
      allowedRoles: ['Administrador', 'Gerente', 'Almacenero', 'Vendedor'],
    ),
    // ✅ Proveedores - Sin acceso para Vendedor
    // Admin: 📖, Gerente: ✅, Almacenero: 📖, Vendedor: ❌
    MenuItem(
      icon: Icons.contact_page,
      title: 'Proveedores',
      subtitle: 'Gestionar proveedores',
      route: '/proveedores',
      allowedRoles: ['Administrador', 'Gerente', 'Almacenero'],
    ),
    // ✅ Lotes - Todos los roles (todos tienen al menos lectura)
    // Admin: 📖, Gerente: ✅, Almacenero: ✏️, Vendedor: 📖
    MenuItem(
      icon: Icons.all_inbox,
      title: 'Lotes',
      subtitle: 'Gestionar lotes',
      route: '/lotes',
      allowedRoles: ['Administrador', 'Gerente', 'Almacenero', 'Vendedor'],
    ),
    // ✅ Inventarios - Todos los roles (todos tienen al menos lectura)
    // Admin: 📖, Gerente: ✅, Almacenero: ✏️, Vendedor: 📖
    MenuItem(
      icon: Icons.inventory,
      title: 'Inventarios',
      subtitle: 'Gestionar inventarios',
      route: '/inventarios',
      allowedRoles: ['Administrador', 'Gerente', 'Almacenero', 'Vendedor'],
    ),
    // ✅ Movimientos - Todos los roles (todos tienen al menos lectura)
    // Admin: 📖, Gerente: ✅, Almacenero: ✏️, Vendedor: 📝 (solo ventas)
    MenuItem(
      icon: Icons.swap_horiz,
      title: 'Movimientos',
      subtitle: 'Gestionar movimientos',
      route: '/movimientos',
      allowedRoles: ['Administrador', 'Gerente', 'Almacenero', 'Vendedor'],
    ),
    // 🔒 Reportes - Todos los roles con diferentes niveles
    // Admin: 📖, Gerente: ✅, Almacenero: parcial, Vendedor: 📖 limitado
    MenuItem(
      icon: Icons.assessment,
      title: 'Reportes',
      subtitle: 'Ver estadísticas',
      route: '/reportes',
      isImplemented: false,
      allowedRoles: ['Administrador', 'Gerente', 'Almacenero', 'Vendedor'],
    ),
    // 🔒 Usuarios - Solo Admin (Gerente solo lectura)
    // Admin: ✅, Gerente: 📖, Almacenero: ❌, Vendedor: ❌
    MenuItem(
      icon: Icons.people,
      title: 'Usuarios',
      subtitle: 'Gestionar usuarios',
      route: '/usuarios',
      isImplemented: false,
      allowedRoles: ['Administrador', 'Gerente'],
    ),
    // 🔒 Análisis/Dashboard - Admin y Gerente
    MenuItem(
      icon: Icons.trending_up,
      title: 'Análisis',
      subtitle: 'Dashboard analítico',
      route: '/analisis',
      isImplemented: false,
      allowedRoles: ['Administrador', 'Gerente'],
    ),
    // 🔒 Alertas - Todos los roles
    MenuItem(
      icon: Icons.notifications,
      title: 'Alertas',
      subtitle: 'Notificaciones',
      route: '/alertas',
      isImplemented: false,
      allowedRoles: ['Administrador', 'Gerente', 'Almacenero', 'Vendedor'],
    ),
    // 🔒 Configuración - Solo Administrador
    // Admin: ✏️, Gerente: ❌, Almacenero: ❌, Vendedor: ❌
    MenuItem(
      icon: Icons.settings,
      title: 'Configuración',
      subtitle: 'Ajustes del sistema',
      route: '/configuracion',
      isImplemented: false,
      allowedRoles: ['Administrador'],
    ),
  ];

  /// Filtra items según el rol del usuario
  static List<MenuItem> getMenuItemsForRole(String? roleName) {
    // Fallback para items básicos si no hay rol
    if (roleName == null) {
      return menuItems
          .where((item) =>
              item.isImplemented &&
              ['Productos', 'Inventarios', 'Movimientos'].contains(item.title))
          .toList();
    }

    return menuItems.where((item) => item.isAllowedForRole(roleName)).toList();
  }
}
