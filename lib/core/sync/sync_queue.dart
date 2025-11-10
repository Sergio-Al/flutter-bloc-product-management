import 'dart:collection';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'sync_item.dart';

class SyncQueue {
  static const String _queueKey = 'sync_queue';
  final Queue<SyncItem> _queue = Queue<SyncItem>();
  final SharedPreferences _prefs;

  SyncQueue(this._prefs) {
    _loadQueue();
  }

  /// Agregar item a la cola
  Future<void> enqueue(SyncItem item) async {
    _queue.add(item);
    await _saveQueue();
  }

  /// Obtener siguiente item sin removerlo
  SyncItem? peek() {
    if (_queue.isEmpty) return null;
    return _queue.first;
  }

  /// Remover y obtener siguiente item
  SyncItem? dequeue() {
    if (_queue.isEmpty) return null;
    final item = _queue.removeFirst();
    _saveQueue();
    return item;
  }

  /// Remover item específico por ID
  Future<void> remove(String itemId) async {
    _queue.removeWhere((item) => item.id == itemId);
    await _saveQueue();
  }

  /// Obtener todos los items
  List<SyncItem> getAll() => _queue.toList();

  /// Obtener items por tipo de entidad
  List<SyncItem> getByEntityType(SyncEntityType entityType) {
    return _queue.where((item) => item.entityType == entityType).toList();
  }

  /// Obtener items pendientes (con menos de 3 reintentos)
  List<SyncItem> getPending() {
    return _queue.where((item) => item.retryCount < 3).toList();
  }

  /// Obtener items con errores
  List<SyncItem> getErrors() {
    return _queue.where((item) => item.error != null).toList();
  }

  /// Contar items en la cola
  int get length => _queue.length;

  /// Verificar si está vacía
  bool get isEmpty => _queue.isEmpty;

  /// Limpiar toda la cola
  Future<void> clear() async {
    _queue.clear();
    await _saveQueue();
  }

  /// Reintentar item con error
  Future<void> retry(String itemId) async {
    final index = _queue.toList().indexWhere((item) => item.id == itemId);
    if (index != -1) {
      final item = _queue.elementAt(index);
      final updated = item.copyWith(
        retryCount: item.retryCount + 1,
        error: null,
      );
      
      // Remover y agregar al final
      _queue.remove(item);
      _queue.add(updated);
      await _saveQueue();
    }
  }

  /// Marcar item con error
  Future<void> markError(String itemId, String error) async {
    final index = _queue.toList().indexWhere((item) => item.id == itemId);
    if (index != -1) {
      final item = _queue.elementAt(index);
      final updated = item.copyWith(error: error);
      
      // Reemplazar en la cola
      final list = _queue.toList();
      list[index] = updated;
      _queue.clear();
      _queue.addAll(list);
      await _saveQueue();
    }
  }

  /// Guardar cola en SharedPreferences
  Future<void> _saveQueue() async {
    final jsonList = _queue.map((item) => item.toJson()).toList();
    await _prefs.setString(_queueKey, json.encode(jsonList));
  }

  /// Cargar cola desde SharedPreferences
  void _loadQueue() {
    final jsonString = _prefs.getString(_queueKey);
    if (jsonString != null) {
      final jsonList = json.decode(jsonString) as List;
      _queue.clear();
      _queue.addAll(
        jsonList.map((json) => SyncItem.fromJson(json)),
      );
    }
  }
}
