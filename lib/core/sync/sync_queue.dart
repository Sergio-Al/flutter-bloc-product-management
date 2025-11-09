// Cola de sincronización para operaciones pendientes
import 'dart:collection';

enum SyncOperation { create, update, delete }

class SyncQueueItem {
  final String id;
  final String entityType;
  final String entityId;
  final SyncOperation operation;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final int priority;
  int retryCount;

  SyncQueueItem({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.data,
    required this.timestamp,
    this.priority = 2,
    this.retryCount = 0,
  });
}

class SyncQueue {
  final Queue<SyncQueueItem> _queue = Queue();

  /// Agrega un item a la cola de sincronización
  void enqueue(SyncQueueItem item) {
    _queue.add(item);
    _sortByPriority();
  }

  /// Obtiene el siguiente item de la cola sin removerlo
  SyncQueueItem? peek() {
    return _queue.isEmpty ? null : _queue.first;
  }

  /// Remueve y retorna el siguiente item de la cola
  SyncQueueItem? dequeue() {
    return _queue.isEmpty ? null : _queue.removeFirst();
  }

  /// Remueve un item específico de la cola
  void remove(String id) {
    _queue.removeWhere((item) => item.id == id);
  }

  /// Retorna todos los items de la cola
  List<SyncQueueItem> getAll() {
    return _queue.toList();
  }

  /// Retorna items de un tipo de entidad específico
  List<SyncQueueItem> getByEntityType(String entityType) {
    return _queue.where((item) => item.entityType == entityType).toList();
  }

  /// Limpia la cola
  void clear() {
    _queue.clear();
  }

  /// Retorna el tamaño de la cola
  int get size => _queue.length;

  /// Verifica si la cola está vacía
  bool get isEmpty => _queue.isEmpty;

  /// Ordena la cola por prioridad
  void _sortByPriority() {
    final items = _queue.toList();
    items.sort((a, b) {
      final priorityCompare = a.priority.compareTo(b.priority);
      if (priorityCompare != 0) return priorityCompare;
      return a.timestamp.compareTo(b.timestamp);
    });
    _queue.clear();
    _queue.addAll(items);
  }
}
