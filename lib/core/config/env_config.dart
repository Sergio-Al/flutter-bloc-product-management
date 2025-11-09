// Configuración de variables de entorno
class EnvConfig {
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );
  
  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';
  static bool get isStaging => environment == 'staging';
  
  // Configuración específica por ambiente
  static String get apiUrl {
    switch (environment) {
      case 'production':
        return 'https://api.production.com';
      case 'staging':
        return 'https://api.staging.com';
      default:
        return 'http://localhost:3000';
    }
  }
}
