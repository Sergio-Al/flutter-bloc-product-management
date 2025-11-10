import 'package:equatable/equatable.dart';
import '../../domain/entities/inventario.dart';

/// Modelo de datos para Inventario
class InventarioModel extends Equatable {
  final String id;
  final String productoId;
  final String almacenId;
  final String tiendaId;
  final String? loteId;
  final int cantidadActual;
  final int cantidadReservada;
  final int cantidadDisponible;
  final double valorTotal;
  final String? ubicacionFisica;
  final DateTime ultimaActualizacion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? syncId;
  final DateTime? lastSync;

  const InventarioModel({
    required this.id,
    required this.productoId,
    required this.almacenId,
    required this.tiendaId,
    this.loteId,
    required this.cantidadActual,
    required this.cantidadReservada,
    required this.cantidadDisponible,
    required this.valorTotal,
    this.ubicacionFisica,
    required this.ultimaActualizacion,
    required this.createdAt,
    required this.updatedAt,
    this.syncId,
    this.lastSync,
  });

  factory InventarioModel.fromJson(Map<String, dynamic> json) {
    return InventarioModel(
      id: json['id'] as String,
      productoId: json['producto_id'] as String,
      almacenId: json['almacen_id'] as String,
      tiendaId: json['tienda_id'] as String,
      loteId: json['lote_id'] as String?,
      cantidadActual: json['cantidad_actual'] as int,
      cantidadReservada: json['cantidad_reservada'] as int? ?? 0,
      cantidadDisponible: json['cantidad_disponible'] as int,
      valorTotal: (json['valor_total'] as num).toDouble(),
      ubicacionFisica: json['ubicacion_fisica'] as String?,
      ultimaActualizacion: DateTime.parse(json['ultima_actualizacion'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      syncId: json['sync_id'] as String?,
      lastSync: json['last_sync'] != null
          ? DateTime.parse(json['last_sync'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'producto_id': productoId,
      'almacen_id': almacenId,
      'tienda_id': tiendaId,
      'lote_id': loteId,
      'cantidad_actual': cantidadActual,
      'cantidad_reservada': cantidadReservada,
      'cantidad_disponible': cantidadDisponible,
      'valor_total': valorTotal,
      'ubicacion_fisica': ubicacionFisica,
      'ultima_actualizacion': ultimaActualizacion.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'sync_id': syncId,
      'last_sync': lastSync?.toIso8601String(),
    };
  }

  InventarioModel copyWith({
    String? id,
    String? productoId,
    String? almacenId,
    String? tiendaId,
    String? loteId,
    int? cantidadActual,
    int? cantidadReservada,
    int? cantidadDisponible,
    double? valorTotal,
    String? ubicacionFisica,
    DateTime? ultimaActualizacion,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncId,
    DateTime? lastSync,
  }) {
    return InventarioModel(
      id: id ?? this.id,
      productoId: productoId ?? this.productoId,
      almacenId: almacenId ?? this.almacenId,
      tiendaId: tiendaId ?? this.tiendaId,
      loteId: loteId ?? this.loteId,
      cantidadActual: cantidadActual ?? this.cantidadActual,
      cantidadReservada: cantidadReservada ?? this.cantidadReservada,
      cantidadDisponible: cantidadDisponible ?? this.cantidadDisponible,
      valorTotal: valorTotal ?? this.valorTotal,
      ubicacionFisica: ubicacionFisica ?? this.ubicacionFisica,
      ultimaActualizacion: ultimaActualizacion ?? this.ultimaActualizacion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncId: syncId ?? this.syncId,
      lastSync: lastSync ?? this.lastSync,
    );
  }

  @override
  List<Object?> get props => [
        id,
        productoId,
        almacenId,
        tiendaId,
        loteId,
        cantidadActual,
        cantidadReservada,
        cantidadDisponible,
        valorTotal,
        ubicacionFisica,
        ultimaActualizacion,
        createdAt,
        updatedAt,
        syncId,
        lastSync,
      ];

  @override
  String toString() => 'InventarioModel(id: $id, productoId: $productoId, cantidadActual: $cantidadActual)';

  /// Convert Model to Entity (Domain layer)
  Inventario toEntity() {
    return Inventario(
      id: id,
      productoId: productoId,
      almacenId: almacenId,
      tiendaId: tiendaId,
      loteId: loteId,
      cantidadActual: cantidadActual,
      cantidadReservada: cantidadReservada,
      cantidadDisponible: cantidadDisponible,
      valorTotal: valorTotal,
      ubicacionFisica: ubicacionFisica,
      ultimaActualizacion: ultimaActualizacion,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create Model from Entity (Domain layer)
  factory InventarioModel.fromEntity(Inventario entity) {
    return InventarioModel(
      id: entity.id,
      productoId: entity.productoId,
      almacenId: entity.almacenId,
      tiendaId: entity.tiendaId,
      loteId: entity.loteId,
      cantidadActual: entity.cantidadActual,
      cantidadReservada: entity.cantidadReservada,
      cantidadDisponible: entity.cantidadDisponible,
      valorTotal: entity.valorTotal,
      ubicacionFisica: entity.ubicacionFisica,
      ultimaActualizacion: entity.ultimaActualizacion ?? DateTime.now(),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      syncId: null,
      lastSync: null,
    );
  }
}
