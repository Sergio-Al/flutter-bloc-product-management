import 'package:uuid/uuid.dart';

enum SyncOperation { create, update, delete }

enum SyncEntityType {
  producto,
  inventario,
  movimiento,
  tienda,
  almacen,
  proveedor,
  lote,
  categoria,
}

class SyncItem {
  final String id;
  final String entityId;
  final SyncEntityType entityType;
  final SyncOperation operation;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final int retryCount;
  final String? error;

  SyncItem({
    String? id,
    required this.entityId,
    required this.entityType,
    required this.operation,
    required this.data,
    DateTime? timestamp,
    this.retryCount = 0,
    this.error,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  SyncItem copyWith({
    String? id,
    String? entityId,
    SyncEntityType? entityType,
    SyncOperation? operation,
    Map<String, dynamic>? data,
    DateTime? timestamp,
    int? retryCount,
    String? error,
  }) {
    return SyncItem(
      id: id ?? this.id,
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      operation: operation ?? this.operation,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
      retryCount: retryCount ?? this.retryCount,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'entity_id': entityId,
        'entity_type': entityType.name,
        'operation': operation.name,
        'data': data,
        'timestamp': timestamp.toIso8601String(),
        'retry_count': retryCount,
        'error': error,
      };

  factory SyncItem.fromJson(Map<String, dynamic> json) => SyncItem(
        id: json['id'],
        entityId: json['entity_id'],
        entityType: SyncEntityType.values.byName(json['entity_type']),
        operation: SyncOperation.values.byName(json['operation']),
        data: Map<String, dynamic>.from(json['data']),
        timestamp: DateTime.parse(json['timestamp']),
        retryCount: json['retry_count'] ?? 0,
        error: json['error'],
      );
}
