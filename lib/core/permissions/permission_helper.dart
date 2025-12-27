// Permission Helper - Role-based access control for UI
// Based on PERMISOS.md from NestJS backend
// 
// Legend:
// - ✅ = Full access (Create, Read, Update, Delete)
// - 📖 = Read only
// - 📝 = Create and read
// - ✏️ = Create, read and update (no delete)
// - ❌ = No access

class PermissionHelper {
  // Valid system roles
  static const String roleAdmin = 'Administrador';
  static const String roleGerente = 'Gerente';
  static const String roleAlmacenero = 'Almacenero';
  static const String roleVendedor = 'Vendedor';

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCTOS MODULE
  // Admin: 📖, Gerente: ✅ CRU, Almacenero: 📖, Vendedor: 📖
  // ═══════════════════════════════════════════════════════════════════════════
  static bool canCreateProducto(String? role) {
    return role == roleGerente;
  }

  static bool canEditProducto(String? role) {
    return role == roleGerente;
  }

  static bool canDeleteProducto(String? role) {
    // No one can delete - restricted for all roles
    return false;
  }

  static bool canActivateProducto(String? role) {
    return role == roleGerente;
  }

  static bool canViewProductoHistory(String? role) {
    return [roleAdmin, roleGerente, roleAlmacenero].contains(role);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INVENTARIOS MODULE
  // Admin: 📖, Gerente: ✅, Almacenero: ✏️, Vendedor: 📖
  // ═══════════════════════════════════════════════════════════════════════════
  static bool canCreateInventario(String? role) {
    return [roleGerente, roleAlmacenero].contains(role);
  }

  static bool canEditInventario(String? role) {
    return [roleGerente, roleAlmacenero].contains(role);
  }

  static bool canDeleteInventario(String? role) {
    // No one can delete - restricted for all roles
    return false;
  }

  static bool canAdjustInventario(String? role) {
    return [roleGerente, roleAlmacenero].contains(role);
  }

  static bool canReserveStock(String? role) {
    return [roleGerente, roleAlmacenero, roleVendedor].contains(role);
  }

  static bool canReleaseStock(String? role) {
    return [roleGerente, roleAlmacenero].contains(role);
  }

  static bool canUpdateLocation(String? role) {
    return [roleGerente, roleAlmacenero].contains(role);
  }

  static bool canViewValorization(String? role) {
    return [roleAdmin, roleGerente, roleAlmacenero].contains(role);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MOVIMIENTOS MODULE
  // Admin: 📖, Gerente: ✅, Almacenero: ✏️, Vendedor: 📝 (only sales)
  // ═══════════════════════════════════════════════════════════════════════════
  static bool canCreateMovimiento(String? role) {
    return [roleGerente, roleAlmacenero].contains(role);
  }

  static bool canCreateSale(String? role) {
    return [roleGerente, roleAlmacenero, roleVendedor].contains(role);
  }

  static bool canEditMovimiento(String? role) {
    return [roleGerente, roleAlmacenero].contains(role);
  }

  static bool canCancelMovimiento(String? role) {
    return [roleGerente, roleAlmacenero].contains(role);
  }

  static bool canCompleteMovimiento(String? role) {
    return [roleGerente, roleAlmacenero].contains(role);
  }

  static bool canViewCosts(String? role) {
    return [roleAdmin, roleGerente, roleAlmacenero].contains(role);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TIENDAS MODULE
  // Admin: ✅, Gerente: ✏️, Almacenero: 📖, Vendedor: 📖
  // ═══════════════════════════════════════════════════════════════════════════
  static bool canCreateTienda(String? role) {
    return role == roleAdmin;
  }

  static bool canEditTienda(String? role) {
    return [roleAdmin, roleGerente].contains(role);
  }

  static bool canDeleteTienda(String? role) {
    // No one can delete - restricted for all roles
    return false;
  }

  static bool canActivateTienda(String? role) {
    return role == roleAdmin;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ALMACENES MODULE
  // Admin: 📖, Gerente: ✅, Almacenero: ✏️, Vendedor: 📖
  // ═══════════════════════════════════════════════════════════════════════════
  static bool canCreateAlmacen(String? role) {
    return role == roleGerente;
  }

  static bool canEditAlmacen(String? role) {
    return [roleGerente, roleAlmacenero].contains(role);
  }

  static bool canDeleteAlmacen(String? role) {
    // No one can delete - restricted for all roles
    return false;
  }

  static bool canActivateAlmacen(String? role) {
    return role == roleGerente;
  }

  static bool canManageLocations(String? role) {
    return [roleGerente, roleAlmacenero].contains(role);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PROVEEDORES MODULE
  // Admin: 📖, Gerente: ✅, Almacenero: 📖, Vendedor: ❌
  // ═══════════════════════════════════════════════════════════════════════════
  static bool canViewProveedores(String? role) {
    return [roleAdmin, roleGerente, roleAlmacenero].contains(role);
  }

  static bool canCreateProveedor(String? role) {
    return role == roleGerente;
  }

  static bool canEditProveedor(String? role) {
    return role == roleGerente;
  }

  static bool canDeleteProveedor(String? role) {
    // No one can delete - restricted for all roles
    return false;
  }

  static bool canActivateProveedor(String? role) {
    return role == roleGerente;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOTES MODULE
  // Admin: 📖, Gerente: ✅, Almacenero: ✏️, Vendedor: 📖
  // ═══════════════════════════════════════════════════════════════════════════
  static bool canCreateLote(String? role) {
    return [roleGerente, roleAlmacenero].contains(role);
  }

  static bool canEditLote(String? role) {
    return [roleGerente, roleAlmacenero].contains(role);
  }

  static bool canDeleteLote(String? role) {
    // No one can delete - restricted for all roles
    return false;
  }

  static bool canViewLoteTraceability(String? role) {
    return [roleGerente, roleAlmacenero].contains(role);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORIAS MODULE
  // Admin: ✅ CRU, Gerente: ✅, Almacenero: 📖, Vendedor: 📖
  // ═══════════════════════════════════════════════════════════════════════════
  static bool canCreateCategoria(String? role) {
    return role == roleGerente;
  }

  static bool canEditCategoria(String? role) {
    return role == roleGerente;
  }

  static bool canDeleteCategoria(String? role) {
    // No one can delete - restricted for all roles
    return false;
  }

  static bool canActivateCategoria(String? role) {
    return role == roleGerente;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // USUARIOS MODULE
  // Admin: ✅ (except delete), Gerente: 📖, Almacenero: ❌, Vendedor: ❌
  // ═══════════════════════════════════════════════════════════════════════════
  static bool canViewUsuarios(String? role) {
    return [roleAdmin, roleGerente].contains(role);
  }

  static bool canCreateUsuario(String? role) {
    return role == roleAdmin;
  }

  static bool canEditUsuario(String? role) {
    return role == roleAdmin;
  }

  static bool canDeleteUsuario(String? role) {
    // No one can delete - restricted for all roles
    return false;
  }

  static bool canActivateUsuario(String? role) {
    return role == roleAdmin;
  }

  static bool canAssignRole(String? role) {
    return role == roleAdmin;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REPORTES MODULE
  // Admin: 📖, Gerente: ✅, Almacenero: partial, Vendedor: 📖 limited
  // ═══════════════════════════════════════════════════════════════════════════
  static bool canViewAllReports(String? role) {
    return role == roleGerente;
  }

  static bool canViewInventoryReports(String? role) {
    return [roleAdmin, roleGerente, roleAlmacenero, roleVendedor].contains(role);
  }

  static bool canViewSalesReports(String? role) {
    return [roleAdmin, roleGerente, roleVendedor].contains(role);
  }

  static bool canViewPurchaseReports(String? role) {
    return [roleAdmin, roleGerente, roleAlmacenero].contains(role);
  }

  static bool canViewValorizationReports(String? role) {
    return [roleAdmin, roleGerente].contains(role);
  }

  static bool canExportReports(String? role) {
    return [roleAdmin, roleGerente, roleAlmacenero].contains(role);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CONFIGURACION MODULE
  // Admin: ✏️, Gerente: 📖 limited, Almacenero: ❌, Vendedor: ❌
  // ═══════════════════════════════════════════════════════════════════════════
  static bool canViewConfig(String? role) {
    return [roleAdmin, roleGerente].contains(role);
  }

  static bool canEditConfig(String? role) {
    return role == roleAdmin;
  }

  static bool canManageRoles(String? role) {
    return role == roleAdmin;
  }

  static bool canManageBackup(String? role) {
    return role == roleAdmin;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SYNC MODULE
  // All roles can sync, but conflict resolution is limited
  // ═══════════════════════════════════════════════════════════════════════════
  static bool canResolveConflicts(String? role) {
    return [roleAdmin, roleGerente].contains(role);
  }

  static bool canViewSyncQueue(String? role) {
    return [roleAdmin, roleGerente, roleAlmacenero].contains(role);
  }

  static bool canConfigureSync(String? role) {
    return role == roleAdmin;
  }

  static bool canViewSyncLogs(String? role) {
    return [roleAdmin, roleGerente].contains(role);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER: Get role display name with icon
  // ═══════════════════════════════════════════════════════════════════════════
  static String getRoleDisplayName(String? role) {
    return switch (role) {
      roleAdmin => '👑 Administrador',
      roleGerente => '👨‍💼 Gerente',
      roleAlmacenero => '📦 Almacenero',
      roleVendedor => '🛒 Vendedor',
      _ => '❓ Sin rol',
    };
  }

  static String getRoleDescription(String? role) {
    return switch (role) {
      roleAdmin => 'Gestión de usuarios, configuración y auditoría',
      roleGerente => 'Gestión operativa y estratégica del negocio',
      roleAlmacenero => 'Control operativo de inventarios',
      roleVendedor => 'Ventas y consultas',
      _ => 'Rol no reconocido',
    };
  }
}
