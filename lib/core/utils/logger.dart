// Sistema de logging para la aplicación
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  /// Log de depuración
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log de información
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log de advertencia
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log de error
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log fatal
  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// Log de datos de red
  static void network(String message, {dynamic request, dynamic response}) {
    _logger.i('🌐 Network: $message', error: {
      'request': request,
      'response': response,
    });
  }

  /// Log de base de datos
  static void database(String message, [dynamic data]) {
    _logger.d('💾 Database: $message', error: data);
  }

  /// Log de sincronización
  static void sync(String message, [dynamic data]) {
    _logger.i('🔄 Sync: $message', error: data);
  }

  /// Log de autenticación
  static void auth(String message, [dynamic data]) {
    _logger.i('🔐 Auth: $message', error: data);
  }
}
