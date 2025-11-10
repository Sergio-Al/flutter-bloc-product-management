/// Configuración general de la aplicación
/// 
/// Contiene constantes y configuraciones globales para
/// el sistema de gestión de materiales de construcción
class AppConfig {
  // ============================================
  // INFORMACIÓN DE LA APP
  // ============================================
  
  static const String appName = 'Sistema de Gestión de Materiales';
  static const String appNameShort = 'SGM';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String appDescription = 'Sistema de gestión de productos para materiales de construcción';
  
  // ============================================
  // BASE DE DATOS LOCAL (DRIFT)
  // ============================================
  
  static const String databaseName = 'materiales_construccion.db';
  static const int databaseVersion = 1;
  
  // ============================================
  // CONFIGURACIÓN DE SINCRONIZACIÓN
  // ============================================
  
  /// Intervalo automático de sincronización (cuando la app está activa)
  static const Duration syncInterval = Duration(minutes: 5);
  
  /// Tiempo de espera para operaciones de sincronización
  static const Duration syncTimeout = Duration(seconds: 30);
  
  /// Máximo número de intentos de reintento en caso de fallo
  static const int maxRetryAttempts = 3;
  
  /// Delay entre intentos de reintento
  static const Duration retryDelay = Duration(seconds: 10);
  
  /// Número máximo de registros a sincronizar por lote
  static const int syncBatchSize = 50;
  
  /// Habilitar sincronización automática en segundo plano
  static const bool enableBackgroundSync = true;
  
  /// Habilitar sincronización solo con WiFi
  static const bool syncOnlyWifi = false;
  
  // ============================================
  // CONFIGURACIÓN DE PAGINACIÓN
  // ============================================
  
  /// Número de elementos por página en listas
  static const int defaultPageSize = 20;
  
  /// Número de elementos en búsquedas
  static const int searchPageSize = 50;
  
  // ============================================
  // CONFIGURACIÓN DE CACHÉ
  // ============================================
  
  /// Duración de caché para datos de catálogo (categorías, unidades)
  static const Duration catalogCacheDuration = Duration(hours: 24);
  
  /// Duración de caché para productos
  static const Duration productsCacheDuration = Duration(hours: 1);
  
  /// Duración de caché para inventarios
  static const Duration inventoryCacheDuration = Duration(minutes: 15);
  
  // ============================================
  // VALIDACIONES Y LÍMITES
  // ============================================
  
  /// Stock mínimo por defecto
  static const int defaultStockMinimo = 10;
  
  /// Stock máximo por defecto
  static const int defaultStockMaximo = 1000;
  
  /// Días de crédito por defecto para proveedores
  static const int defaultDiasCredito = 30;
  
  /// Tamaño máximo de imagen (en bytes) - 5MB
  static const int maxImageSize = 5 * 1024 * 1024;
  
  /// Formatos de imagen permitidos
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
  
  /// Longitud mínima de contraseña
  static const int minPasswordLength = 8;
  
  /// Longitud máxima de código de producto
  static const int maxCodigoLength = 50;
  
  // ============================================
  // CONFIGURACIÓN DE LOGS
  // ============================================
  
  /// Habilitar logs detallados en desarrollo
  static const bool enableDetailedLogs = true;
  
  /// Habilitar logs de red (HTTP)
  static const bool enableNetworkLogs = true;
  
  /// Habilitar logs de base de datos
  static const bool enableDatabaseLogs = false;
  
  // ============================================
  // TIPOS DE MOVIMIENTO
  // ============================================
  
  static const List<String> tiposMovimiento = [
    'COMPRA',
    'VENTA',
    'TRANSFERENCIA',
    'AJUSTE',
    'DEVOLUCION',
    'MERMA',
  ];
  
  // ============================================
  // ESTADOS DE MOVIMIENTO
  // ============================================
  
  static const List<String> estadosMovimiento = [
    'PENDIENTE',
    'EN_TRANSITO',
    'COMPLETADO',
    'CANCELADO',
  ];
  
  // ============================================
  // TIPOS DE ALMACÉN
  // ============================================
  
  static const List<String> tiposAlmacen = [
    'Principal',
    'Obra',
    'Transito',
  ];
  
  // ============================================
  // TIPOS DE UNIDAD DE MEDIDA
  // ============================================
  
  static const List<String> tiposUnidadMedida = [
    'Peso',
    'Volumen',
    'Longitud',
    'Unidad',
    'Area',
  ];
  
  // ============================================
  // ROLES DEL SISTEMA
  // ============================================
  
  static const String rolAdministrador = 'Administrador';
  static const String rolGerente = 'Gerente';
  static const String rolAlmacenero = 'Almacenero';
  static const String rolVendedor = 'Vendedor';
  
  // ============================================
  // CONFIGURACIÓN DE UI
  // ============================================
  
  /// Tiempo de duración de mensajes toast
  static const Duration toastDuration = Duration(seconds: 3);
  
  /// Tiempo de duración de snackbars
  static const Duration snackBarDuration = Duration(seconds: 4);
  
  /// Radio de bordes por defecto
  static const double defaultBorderRadius = 8.0;
  
  /// Padding por defecto en pantallas
  static const double defaultPadding = 16.0;
  
  /// Espaciado entre elementos
  static const double defaultSpacing = 8.0;
  
  // ============================================
  // FORMATO DE FECHAS
  // ============================================
  
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String timeFormat = 'HH:mm';
  static const String monthYearFormat = 'MMMM yyyy';
  
  // ============================================
  // CONFIGURACIÓN DE REPORTES
  // ============================================
  
  /// Número máximo de días para reportes históricos
  static const int maxReportDays = 365;
  
  /// Días por defecto para reportes
  static const int defaultReportDays = 30;
  
  // ============================================
  // FEATURES FLAGS
  // ============================================
  
  /// Habilitar módulo de reportes avanzados
  static const bool enableAdvancedReports = true;
  
  /// Habilitar módulo de códigos de barras
  static const bool enableBarcodeScanner = true;
  
  /// Habilitar notificaciones push
  static const bool enablePushNotifications = false;
  
  /// Habilitar modo offline completo
  static const bool enableOfflineMode = true;
  
  /// Habilitar auditoría de cambios
  static const bool enableAuditLog = true;
  
  // ============================================
  // HELPERS
  // ============================================
  
  /// Obtiene la cadena de versión completa
  static String get fullVersion => 'v$appVersion ($appBuildNumber)';
  
  /// Indica si está en modo de desarrollo (basado en assert)
  static bool get isDebugMode {
    bool isDebug = false;
    assert(isDebug = true);
    return isDebug;
  }
  
  /// Imprime la configuración de la app
  static void printConfig() {
    print('=== Configuración de la Aplicación ===');
    print('Nombre: $appName');
    print('Versión: $fullVersion');
    print('Base de datos: $databaseName v$databaseVersion');
    print('Sincronización: ${syncInterval.inMinutes} min');
    print('Tamaño de página: $defaultPageSize');
    print('Modo offline: ${enableOfflineMode ? "✓" : "✗"}');
    print('Debug: ${isDebugMode ? "✓" : "✗"}');
    print('======================================');
  }
}
