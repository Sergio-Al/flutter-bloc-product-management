// Constantes de base de datos
class DatabaseConstants {
  // Nombres de tablas
  static const String usuariosTable = 'usuarios';
  static const String productosTable = 'productos';
  static const String inventariosTable = 'inventarios';
  static const String movimientosTable = 'movimientos';
  static const String tiendasTable = 'tiendas';
  static const String almacenesTable = 'almacenes';
  static const String proveedoresTable = 'proveedores';
  static const String lotesTable = 'lotes';
  static const String categoriasTable = 'categorias';
  static const String rolesTable = 'roles';
  static const String unidadesMedidaTable = 'unidades_medida';
  static const String auditoriasTable = 'auditorias';
  
  // Columnas comunes
  static const String idColumn = 'id';
  static const String createdAtColumn = 'created_at';
  static const String updatedAtColumn = 'updated_at';
  static const String deletedAtColumn = 'deleted_at';
  static const String syncStatusColumn = 'sync_status';
  static const String lastSyncColumn = 'last_sync';
}
