import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'env_config.dart';

/// Configuración de Supabase para el proyecto
/// 
/// Inicializa el cliente de Supabase y proporciona acceso
/// a las funcionalidades de autenticación y base de datos
class SupabaseConfig {
  // ============================================
  // NOMBRES DE TABLAS
  // ============================================
  
  static const String rolesTable = 'roles';
  static const String tiendasTable = 'tiendas';
  static const String usuariosTable = 'usuarios';
  static const String almacenesTable = 'almacenes';
  static const String categoriasTable = 'categorias';
  static const String unidadesMedidaTable = 'unidades_medida';
  static const String proveedoresTable = 'proveedores';
  static const String productosTable = 'productos';
  static const String lotesTable = 'lotes';
  static const String inventariosTable = 'inventarios';
  static const String movimientosTable = 'movimientos';
  static const String auditoriasTable = 'auditorias';
  
  // ============================================
  // VISTAS DE BASE DE DATOS
  // ============================================
  
  static const String vwInventarioCompleto = 'vw_inventario_completo';
  static const String vwMovimientosCompletos = 'vw_movimientos_completos';
  static const String vwProductosStockBajo = 'vw_productos_stock_bajo';
  
  // ============================================
  // FUNCIONES RPC
  // ============================================
  
  static const String rpcGetDashboardStats = 'get_dashboard_stats';
  
  // ============================================
  // STORAGE BUCKETS
  // ============================================
  
  static const String productosImagesBucket = 'productos-images';
  static const String documentosBucket = 'documentos';
  static const String certificadosBucket = 'certificados';
  
  // ============================================
  // CONFIGURACIÓN DE REALTIME
  // ============================================
  
  /// Tablas habilitadas para actualizaciones en tiempo real
  static const List<String> realtimeTables = [
    productosTable,
    inventariosTable,
    movimientosTable,
  ];
  
  // ============================================
  // INICIALIZACIÓN
  // ============================================
  
  /// Inicializa Supabase con las credenciales del entorno
  static Future<void> initialize() async {
    if (!EnvConfig.isValid) {
      throw Exception(EnvConfig.validationError);
    }
    
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
      debug: EnvConfig.isDebugMode,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
        detectSessionInUri: true,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );
    
    if (EnvConfig.isDebugMode) {
      print('✓ Supabase inicializado correctamente');
      print('  URL: ${EnvConfig.supabaseUrl}');
    }
  }
  
  /// Obtiene la instancia del cliente de Supabase
  static SupabaseClient get client => Supabase.instance.client;
  
  /// Obtiene el cliente de autenticación
  static GoTrueClient get auth => client.auth;
  
  /// Obtiene el cliente de almacenamiento
  static SupabaseStorageClient get storage => client.storage;
  
  /// Obtiene el usuario actual autenticado
  static User? get currentUser => auth.currentUser;
  
  /// Indica si hay un usuario autenticado
  static bool get isAuthenticated => currentUser != null;
  
  /// Obtiene el ID del usuario actual
  static String? get currentUserId => currentUser?.id;
  
  // ============================================
  // HELPERS DE CONSULTAS
  // ============================================
  
  /// Obtiene un query builder para una tabla específica
  static SupabaseQueryBuilder table(String tableName) {
    return client.from(tableName);
  }
  
  /// Obtiene un query builder para la tabla de usuarios
  static SupabaseQueryBuilder get usuarios => table(usuariosTable);
  
  /// Obtiene un query builder para la tabla de productos
  static SupabaseQueryBuilder get productos => table(productosTable);
  
  /// Obtiene un query builder para la tabla de inventarios
  static SupabaseQueryBuilder get inventarios => table(inventariosTable);
  
  /// Obtiene un query builder para la tabla de movimientos
  static SupabaseQueryBuilder get movimientos => table(movimientosTable);
  
  /// Obtiene un query builder para la tabla de tiendas
  static SupabaseQueryBuilder get tiendas => table(tiendasTable);
  
  /// Obtiene un query builder para la tabla de almacenes
  static SupabaseQueryBuilder get almacenes => table(almacenesTable);
  
  /// Obtiene un query builder para la tabla de proveedores
  static SupabaseQueryBuilder get proveedores => table(proveedoresTable);
  
  /// Obtiene un query builder para la tabla de lotes
  static SupabaseQueryBuilder get lotes => table(lotesTable);
  
  /// Obtiene un query builder para la tabla de categorías
  static SupabaseQueryBuilder get categorias => table(categoriasTable);
  
  // ============================================
  // HELPERS DE STORAGE
  // ============================================
  
  /// Obtiene el bucket de imágenes de productos
  static SupabaseStorageClient getBucket(String bucketName) {
    return storage;
  }
  
  /// Sube una imagen de producto
  static Future<String> uploadProductoImage(
    String productId,
    String filePath,
    Uint8List fileBytes,
  ) async {
    final fileName = '$productId/${DateTime.now().millisecondsSinceEpoch}_$filePath';
    
    await storage.from(productosImagesBucket).uploadBinary(
          fileName,
          fileBytes,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: true,
          ),
        );
    
    final publicUrl = storage.from(productosImagesBucket).getPublicUrl(fileName);
    return publicUrl;
  }
  
  /// Elimina una imagen de producto
  static Future<void> deleteProductoImage(String imageUrl) async {
    final fileName = imageUrl.split('$productosImagesBucket/').last;
    await storage.from(productosImagesBucket).remove([fileName]);
  }
  
  // ============================================
  // REALTIME
  // ============================================
  
  /// Crea un canal de realtime para una tabla específica
  static RealtimeChannel createChannel(String channelName) {
    return client.channel(channelName);
  }
  
  /// Escucha cambios en una tabla específica
  static RealtimeChannel listenToTable(
    String tableName,
    void Function(PostgresChangePayload) callback, {
    PostgresChangeEvent event = PostgresChangeEvent.all,
    PostgresChangeFilter? filter,
  }) {
    final channel = createChannel('public:$tableName');
    
    channel.onPostgresChanges(
      event: event,
      schema: 'public',
      table: tableName,
      filter: filter,
      callback: callback,
    );
    
    channel.subscribe();
    return channel;
  }
  
  // ============================================
  // FUNCIONES RPC
  // ============================================
  
  /// Ejecuta una función RPC
  static Future<PostgrestResponse> rpc(
    String functionName, {
    Map<String, dynamic>? params,
  }) async {
    return await client.rpc(functionName, params: params);
  }
  
  /// Obtiene estadísticas del dashboard
  static Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await rpc(rpcGetDashboardStats);
    return response.data as Map<String, dynamic>;
  }
}
