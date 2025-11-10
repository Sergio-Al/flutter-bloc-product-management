import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuración de variables de entorno
/// 
/// Carga variables desde el archivo .env usando flutter_dotenv
class EnvConfig {
  // ============================================
  // INICIALIZACIÓN
  // ============================================
  
  /// Inicializa el archivo .env
  /// Debe llamarse antes de usar cualquier variable
  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
  }
  
  // ============================================
  // VARIABLES DE ENTORNO
  // ============================================
  
  /// URL del proyecto Supabase
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  
  /// Clave anónima de Supabase (pública)
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  
  /// Modo de depuración
  static String get debugMode => dotenv.env['DEBUG_MODE'] ?? 'true';
  
  /// Entorno de ejecución
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';
  
  // ============================================
  // GETTERS DE CONFIGURACIÓN
  // ============================================
  
  /// Indica si está en modo de depuración
  static bool get isDebugMode => debugMode.toLowerCase() == 'true';
  
  /// Indica si está en ambiente de desarrollo
  static bool get isDevelopment => environment == 'development';
  
  /// Indica si está en ambiente de producción
  static bool get isProduction => environment == 'production';
  
  /// Indica si está en ambiente de staging
  static bool get isStaging => environment == 'staging';
  
  // ============================================
  // VALIDACIÓN
  // ============================================
  
  /// Valida que las variables de entorno requeridas estén configuradas
  static bool get isValid {
    return supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  }
  
  /// Mensaje de error si la configuración no es válida
  static String get validationError {
    if (supabaseUrl.isEmpty) {
      return 'SUPABASE_URL no está configurada. Verifica tu archivo .env';
    }
    if (supabaseAnonKey.isEmpty) {
      return 'SUPABASE_ANON_KEY no está configurada. Verifica tu archivo .env';
    }
    return '';
  }
  
  /// Imprime la configuración actual (sin datos sensibles)
  static void printConfig() {
    print('=== Configuración de Entorno ===');
    print('Environment: $environment');
    print('Debug Mode: $isDebugMode');
    print('Supabase URL: ${supabaseUrl.isNotEmpty ? "✓ Configurada" : "✗ No configurada"}');
    print('Supabase Key: ${supabaseAnonKey.isNotEmpty ? "✓ Configurada" : "✗ No configurada"}');
    print('Valid: ${isValid ? "✓" : "✗"}');
    print('================================');
  }
}
