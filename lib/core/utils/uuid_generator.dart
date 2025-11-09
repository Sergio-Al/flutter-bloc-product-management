// Generador de UUIDs
import 'package:uuid/uuid.dart';

class UuidGenerator {
  static const Uuid _uuid = Uuid();

  /// Genera un UUID v4
  static String generate() {
    return _uuid.v4();
  }

  /// Genera un UUID v1 (basado en tiempo)
  static String generateTimeBasedUuid() {
    return _uuid.v1();
  }

  /// Valida si un string es un UUID válido
  static bool isValid(String uuid) {
    final pattern = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    );
    return pattern.hasMatch(uuid);
  }

  /// Genera un ID único con prefijo
  static String generateWithPrefix(String prefix) {
    return '${prefix}_${generate()}';
  }
}
