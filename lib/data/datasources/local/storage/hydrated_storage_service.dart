import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import '../../../../core/utils/logger.dart';

/// Servicio para gestionar el almacenamiento persistente de los BLoCs
/// Utiliza HydratedBloc para persistir y restaurar el estado de los BLoCs
/// automáticamente entre sesiones de la aplicación.
class HydratedStorageService {
  static HydratedStorage? _storage;
  
  /// Inicializa el almacenamiento persistente de HydratedBloc
  /// 
  /// Debe ser llamado antes de inicializar cualquier BLoC que use HydratedBloc.
  /// Típicamente se llama en el método main() antes de runApp().
  /// 
  /// Example:
  /// ```dart
  /// await HydratedStorageService.init();
  /// ```
  /// 
  /// Returns: Future<void>
  /// Throws: Exception si no se puede inicializar el almacenamiento
  static Future<void> init() async {
    try {
      AppLogger.info('Inicializando HydratedStorage...');
      
      final storageDirectory = await _getStorageDirectory();
      
      _storage = await HydratedStorage.build(
        storageDirectory: storageDirectory,
      );
      
      HydratedBloc.storage = _storage!;
      
      AppLogger.info('✅ HydratedStorage inicializado correctamente');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al inicializar HydratedStorage',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Obtiene el directorio de almacenamiento para HydratedBloc
  /// 
  /// Returns: Directorio donde se almacenarán los datos persistentes
  static Future<Directory> _getStorageDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final storageDir = Directory(
      path.join(directory.path, 'hydrated_storage'),
    );
    
    // Crear el directorio si no existe
    if (!await storageDir.exists()) {
      await storageDir.create(recursive: true);
      AppLogger.debug('Directorio de almacenamiento creado: ${storageDir.path}');
    }
    
    return storageDir;
  }

  /// Limpia todo el almacenamiento persistente
  /// 
  /// Elimina todos los datos guardados de los BLoCs.
  /// Útil para funciones de logout o reset de la aplicación.
  /// 
  /// Example:
  /// ```dart
  /// await HydratedStorageService.clear();
  /// ```
  /// 
  /// Returns: Future<void>
  static Future<void> clear() async {
    try {
      AppLogger.warning('Limpiando HydratedStorage...');
      
      if (_storage != null) {
        await _storage!.clear();
        AppLogger.info('✅ HydratedStorage limpiado correctamente');
      } else {
        AppLogger.warning('No hay storage para limpiar');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al limpiar HydratedStorage',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Elimina el almacenamiento de un BLoC específico por su key
  /// 
  /// [key] - El identificador único del BLoC cuyo estado se quiere eliminar
  /// 
  /// Example:
  /// ```dart
  /// await HydratedStorageService.delete('auth_bloc');
  /// ```
  /// 
  /// Returns: Future<void>
  static Future<void> delete(String key) async {
    try {
      AppLogger.debug('Eliminando storage key: $key');
      
      if (_storage != null) {
        await _storage!.delete(key);
        AppLogger.info('✅ Storage key eliminado: $key');
      } else {
        AppLogger.warning('No hay storage disponible');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al eliminar storage key: $key',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Obtiene el tamaño del almacenamiento en bytes
  /// 
  /// Returns: Tamaño total del almacenamiento persistente
  static Future<int> getStorageSize() async {
    try {
      final storageDirectory = await _getStorageDirectory();
      
      if (!await storageDirectory.exists()) {
        return 0;
      }
      
      int totalSize = 0;
      
      await for (final entity in storageDirectory.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
      
      AppLogger.debug('Tamaño de HydratedStorage: ${_formatBytes(totalSize)}');
      return totalSize;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al obtener tamaño de storage',
        e,
        stackTrace,
      );
      return 0;
    }
  }

  /// Verifica si el almacenamiento está inicializado
  /// 
  /// Returns: true si el storage está listo para usar
  static bool get isInitialized => _storage != null;

  /// Obtiene el directorio de almacenamiento actual
  /// 
  /// Returns: Path del directorio de almacenamiento o null si no está inicializado
  static Future<String?> getStoragePath() async {
    try {
      if (!isInitialized) {
        return null;
      }
      
      final directory = await _getStorageDirectory();
      return directory.path;
    } catch (e) {
      AppLogger.error('Error al obtener path de storage', e);
      return null;
    }
  }

  /// Verifica la integridad del almacenamiento
  /// 
  /// Comprueba que el directorio existe y es accesible.
  /// 
  /// Returns: true si el almacenamiento está en buen estado
  static Future<bool> checkIntegrity() async {
    try {
      final storageDirectory = await _getStorageDirectory();
      
      // Verificar que el directorio existe
      if (!await storageDirectory.exists()) {
        AppLogger.warning('Directorio de storage no existe');
        return false;
      }
      
      // Verificar permisos de lectura/escritura
      final testFile = File(path.join(storageDirectory.path, '.test'));
      await testFile.writeAsString('test');
      final content = await testFile.readAsString();
      await testFile.delete();
      
      if (content != 'test') {
        AppLogger.error('No se puede leer/escribir en el directorio de storage');
        return false;
      }
      
      AppLogger.info('✅ Integridad de HydratedStorage verificada');
      return true;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al verificar integridad de storage',
        e,
        stackTrace,
      );
      return false;
    }
  }

  /// Realiza una copia de seguridad del almacenamiento
  /// 
  /// [backupPath] - Path donde se guardará el backup (opcional)
  /// 
  /// Returns: Path del archivo de backup creado
  static Future<String?> backup({String? backupPath}) async {
    try {
      AppLogger.info('Creando backup de HydratedStorage...');
      
      final storageDirectory = await _getStorageDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      final backupDir = backupPath != null
          ? Directory(backupPath)
          : await getApplicationDocumentsDirectory();
      
      final backupFile = File(
        path.join(backupDir.path, 'hydrated_backup_$timestamp.bak'),
      );
      
      // Crear un archivo tar o zip con el contenido
      // Por simplicidad, copiamos el directorio completo
      final List<int> bytes = [];
      
      await for (final entity in storageDirectory.list(recursive: true)) {
        if (entity is File) {
          bytes.addAll(await entity.readAsBytes());
        }
      }
      
      await backupFile.writeAsBytes(bytes);
      
      AppLogger.info('✅ Backup creado: ${backupFile.path}');
      return backupFile.path;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al crear backup',
        e,
        stackTrace,
      );
      return null;
    }
  }

  /// Restaura el almacenamiento desde un backup
  /// 
  /// [backupPath] - Path del archivo de backup
  /// 
  /// Returns: true si la restauración fue exitosa
  static Future<bool> restore(String backupPath) async {
    try {
      AppLogger.info('Restaurando HydratedStorage desde backup...');
      
      final backupFile = File(backupPath);
      
      if (!await backupFile.exists()) {
        AppLogger.error('Archivo de backup no existe: $backupPath');
        return false;
      }
      
      // Limpiar storage actual
      await clear();
      
      // Restaurar desde backup
      final storageDirectory = await _getStorageDirectory();
      final bytes = await backupFile.readAsBytes();
      
      // Escribir bytes en el nuevo storage
      // Esta es una implementación simplificada
      final restoredFile = File(
        path.join(storageDirectory.path, 'restored_data'),
      );
      await restoredFile.writeAsBytes(bytes);
      
      // Re-inicializar storage
      await init();
      
      AppLogger.info('✅ HydratedStorage restaurado desde: $backupPath');
      return true;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al restaurar backup',
        e,
        stackTrace,
      );
      return false;
    }
  }

  /// Formatea bytes a una representación legible
  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  /// Obtiene estadísticas del almacenamiento
  /// 
  /// Returns: Map con información sobre el storage
  static Future<Map<String, dynamic>> getStatistics() async {
    try {
      final storageDirectory = await _getStorageDirectory();
      final size = await getStorageSize();
      final path = await getStoragePath();
      final integrity = await checkIntegrity();
      
      int fileCount = 0;
      
      if (await storageDirectory.exists()) {
        await for (final entity in storageDirectory.list(recursive: false)) {
          if (entity is File) {
            fileCount++;
          }
        }
      }
      
      return {
        'initialized': isInitialized,
        'path': path,
        'size_bytes': size,
        'size_formatted': _formatBytes(size),
        'file_count': fileCount,
        'integrity_ok': integrity,
        'last_checked': DateTime.now().toIso8601String(),
      };
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al obtener estadísticas',
        e,
        stackTrace,
      );
      return {
        'error': e.toString(),
      };
    }
  }
}
