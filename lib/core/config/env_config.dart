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
  
  /// URL del proyecto Supabase (legacy - mantener para migración gradual)
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  
  /// Clave anónima de Supabase (pública) (legacy)
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  
  /// URL base del API NestJS
  static String get apiUrl => dotenv.env['API_BASE_URL'] ?? '';
  
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
    return apiUrl.isNotEmpty;
  }
  
  /// Mensaje de error si la configuración no es válida
  static String get validationError {
    if (apiUrl.isEmpty) {
      return 'API_BASE_URL no está configurada. Verifica tu archivo .env';
    }
    return '';
  }
  
  /// Imprime la configuración actual (sin datos sensibles)
  static void printConfig() {
    print('=== Configuración de Entorno ===');
    print('Environment: $environment');
    print('Debug Mode: $isDebugMode');
    print('API URL: ${apiUrl.isNotEmpty ? "✓ Configurada ($apiUrl)" : "✗ No configurada"}');
    print('Supabase URL (legacy): ${supabaseUrl.isNotEmpty ? "✓ Configurada" : "⚠ No configurada"}');
    print('Supabase Key (legacy): ${supabaseAnonKey.isNotEmpty ? "✓ Configurada" : "⚠ No configurada"}');
    print('Valid: ${isValid ? "✓" : "✗"}');
    print('================================');
  }
}
