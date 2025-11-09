// Utilidades para manejo de fechas
import 'package:intl/intl.dart';

class DateTimeUtils {
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _isoFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');

  /// Formatea una fecha a string
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Formatea una fecha y hora a string
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  /// Formatea solo la hora
  static String formatTime(DateTime time) {
    return _timeFormat.format(time);
  }

  /// Convierte un string a DateTime
  static DateTime? parseDate(String dateString) {
    try {
      return _dateFormat.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Convierte un string ISO a DateTime
  static DateTime? parseIsoDate(String isoString) {
    try {
      return DateTime.parse(isoString);
    } catch (e) {
      return null;
    }
  }

  /// Retorna la fecha actual sin hora
  static DateTime get today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Verifica si una fecha es hoy
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Verifica si una fecha es ayer
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Calcula la diferencia en días entre dos fechas
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  /// Retorna una descripción relativa de la fecha (ej: "Hace 2 horas")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'Hace ${years} ${years == 1 ? 'año' : 'años'}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'Hace ${months} ${months == 1 ? 'mes' : 'meses'}';
    } else if (difference.inDays > 0) {
      return 'Hace ${difference.inDays} ${difference.inDays == 1 ? 'día' : 'días'}';
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
    } else if (difference.inMinutes > 0) {
      return 'Hace ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
    } else {
      return 'Justo ahora';
    }
  }
}
