// Configuración general de la aplicación
class AppConfig {
  static const String appName = 'Sistema de Gestión de Productos';
  static const String appVersion = '1.0.0';
  
  // Configuración de la base de datos
  static const String databaseName = 'product_management.db';
  static const int databaseVersion = 1;
  
  // Configuración de sincronización
  static const Duration syncInterval = Duration(minutes: 5);
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 30);
}
