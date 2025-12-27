/// Validador de contraseñas según política de seguridad del backend
/// 
/// Requisitos:
/// - Mínimo 8 caracteres
/// - Al menos una letra mayúscula
/// - Al menos una letra minúscula
/// - Al menos un número
/// - Al menos un carácter especial (!@#$%^&*()_+-=[]{};\':"|,.<>/?)
/// - No más de 2 caracteres consecutivos repetidos
/// - No contraseñas comunes
class PasswordValidator {
  /// Lista de contraseñas comunes prohibidas
  static const List<String> _commonPasswords = [
    'password',
    'password1',
    'password123',
    '12345678',
    '123456789',
    '1234567890',
    'qwerty123',
    'qwertyuiop',
    'admin123',
    'admin1234',
    'letmein',
    'welcome',
    'welcome1',
    'monkey',
    'dragon',
    'master',
    'login',
    'abc123',
    'abc12345',
    '111111',
    '000000',
    'iloveyou',
    'trustno1',
    'sunshine',
    'princess',
    'football',
    'baseball',
    'soccer',
    'hockey',
    'batman',
    'superman',
  ];

  /// Caracteres especiales permitidos
  static const String _specialChars = r'''!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?''';
  
  /// Valida la contraseña y retorna null si es válida, o un mensaje de error
  static String? validate(String password) {
    final errors = <String>[];
    
    // Verificar longitud mínima
    if (password.length < 8) {
      errors.add('Mínimo 8 caracteres');
    }
    
    // Verificar longitud máxima
    if (password.length > 128) {
      errors.add('Máximo 128 caracteres');
    }
    
    // Verificar mayúscula
    if (!password.contains(RegExp(r'[A-Z]'))) {
      errors.add('Al menos una mayúscula');
    }
    
    // Verificar minúscula
    if (!password.contains(RegExp(r'[a-z]'))) {
      errors.add('Al menos una minúscula');
    }
    
    // Verificar número
    if (!password.contains(RegExp(r'[0-9]'))) {
      errors.add('Al menos un número');
    }
    
    // Verificar carácter especial
    if (!password.contains(RegExp('[$_specialChars]'))) {
      errors.add('Al menos un carácter especial (!@#\$%^&*...)');
    }
    
    // Verificar caracteres repetidos consecutivos (más de 2)
    if (_hasConsecutiveRepeats(password)) {
      errors.add('No más de 2 caracteres repetidos consecutivos');
    }
    
    // Verificar contraseñas comunes
    if (_isCommonPassword(password)) {
      errors.add('Contraseña muy común');
    }
    
    if (errors.isEmpty) {
      return null;
    }
    
    return errors.join('\n');
  }
  
  /// Verifica si la contraseña tiene más de 2 caracteres consecutivos repetidos
  static bool _hasConsecutiveRepeats(String password) {
    for (int i = 0; i < password.length - 2; i++) {
      if (password[i] == password[i + 1] && password[i] == password[i + 2]) {
        return true;
      }
    }
    return false;
  }
  
  /// Verifica si la contraseña está en la lista de contraseñas comunes
  static bool _isCommonPassword(String password) {
    final lowerPassword = password.toLowerCase();
    return _commonPasswords.any(
      (common) => lowerPassword.contains(common),
    );
  }
  
  /// Calcula la fortaleza de la contraseña (0-100)
  static int calculateStrength(String password) {
    if (password.isEmpty) return 0;
    
    int score = 0;
    
    // Longitud (hasta 25 puntos)
    score += (password.length * 2).clamp(0, 25);
    
    // Mayúsculas (10 puntos)
    if (password.contains(RegExp(r'[A-Z]'))) score += 10;
    
    // Minúsculas (10 puntos)
    if (password.contains(RegExp(r'[a-z]'))) score += 10;
    
    // Números (15 puntos)
    if (password.contains(RegExp(r'[0-9]'))) score += 15;
    
    // Caracteres especiales (20 puntos)
    if (password.contains(RegExp('[$_specialChars]'))) score += 20;
    
    // Variedad de caracteres (hasta 20 puntos)
    final uniqueChars = password.split('').toSet().length;
    score += (uniqueChars * 2).clamp(0, 20);
    
    // Penalización por contraseña común
    if (_isCommonPassword(password)) score -= 30;
    
    // Penalización por repeticiones
    if (_hasConsecutiveRepeats(password)) score -= 15;
    
    return score.clamp(0, 100);
  }
  
  /// Retorna el nivel de fortaleza como texto
  static String getStrengthLabel(int strength) {
    if (strength < 30) return 'Muy débil';
    if (strength < 50) return 'Débil';
    if (strength < 70) return 'Moderada';
    if (strength < 90) return 'Fuerte';
    return 'Muy fuerte';
  }
  
  /// Retorna el color asociado al nivel de fortaleza
  static int getStrengthColor(int strength) {
    if (strength < 30) return 0xFFE53935; // Red
    if (strength < 50) return 0xFFFF9800; // Orange
    if (strength < 70) return 0xFFFFC107; // Amber
    if (strength < 90) return 0xFF8BC34A; // Light Green
    return 0xFF4CAF50; // Green
  }
}
