// Validadores de formularios y datos

class Validators {
  /// Valida un email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es requerido';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Ingrese un correo electrónico válido';
    }

    return null;
  }

  /// Valida una contraseña
  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }

    if (value.length < minLength) {
      return 'La contraseña debe tener al menos $minLength caracteres';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'La contraseña debe contener al menos una mayúscula';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'La contraseña debe contener al menos una minúscula';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'La contraseña debe contener al menos un número';
    }

    return null;
  }

  /// Valida un campo requerido
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Este campo'} es requerido';
    }
    return null;
  }

  /// Valida longitud mínima
  static String? minLength(String? value, int min, {String? fieldName}) {
    if (value == null || value.isEmpty) return null;

    if (value.length < min) {
      return '${fieldName ?? 'Este campo'} debe tener al menos $min caracteres';
    }
    return null;
  }

  /// Valida longitud máxima
  static String? maxLength(String? value, int max, {String? fieldName}) {
    if (value == null || value.isEmpty) return null;

    if (value.length > max) {
      return '${fieldName ?? 'Este campo'} no puede exceder $max caracteres';
    }
    return null;
  }

  /// Valida un número
  static String? number(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) return null;

    if (double.tryParse(value) == null) {
      return '${fieldName ?? 'Este campo'} debe ser un número válido';
    }
    return null;
  }

  /// Valida un número entero positivo
  static String? positiveInteger(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) return null;

    final number = int.tryParse(value);
    if (number == null || number < 0) {
      return '${fieldName ?? 'Este campo'} debe ser un número entero positivo';
    }
    return null;
  }

  /// Valida un número decimal positivo
  static String? positiveDecimal(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) return null;

    final number = double.tryParse(value);
    if (number == null || number < 0) {
      return '${fieldName ?? 'Este campo'} debe ser un número positivo';
    }
    return null;
  }

  /// Valida un teléfono
  static String? phone(String? value) {
    if (value == null || value.isEmpty) return null;

    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
      return 'Ingrese un número de teléfono válido';
    }
    return null;
  }

  /// Valida un código postal
  static String? postalCode(String? value) {
    if (value == null || value.isEmpty) return null;

    final postalCodeRegex = RegExp(r'^\d{5}$');
    if (!postalCodeRegex.hasMatch(value)) {
      return 'Ingrese un código postal válido (5 dígitos)';
    }
    return null;
  }

  /// Combina múltiples validadores
  static String? combine(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) return result;
    }
    return null;
  }
}
