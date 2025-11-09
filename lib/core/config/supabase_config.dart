// Configuración de Supabase
class SupabaseConfig {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );
  
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );
  
  // Configuración de tablas
  static const String usuariosTable = 'usuarios';
  static const String productosTable = 'productos';
  static const String inventariosTable = 'inventarios';
  static const String movimientosTable = 'movimientos';
  static const String tiendasTable = 'tiendas';
  static const String almacenesTable = 'almacenes';
  static const String proveedoresTable = 'proveedores';
  static const String lotesTable = 'lotes';
  static const String categoriasTable = 'categorias';
}
