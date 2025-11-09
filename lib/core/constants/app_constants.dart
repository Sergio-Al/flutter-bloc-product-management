// Constantes generales de la aplicación
class AppConstants {
  // Límites de paginación
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Timeouts
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration uploadTimeout = Duration(minutes: 2);
  
  // Formatos de fecha
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String timeFormat = 'HH:mm';
  
  // Validaciones
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
  
  // Storage keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
}
