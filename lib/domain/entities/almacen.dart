import 'package:equatable/equatable.dart';

/// Almacen entity - Pure business object
/// Represents a warehouse within a store
class Almacen extends Equatable {
  final String id;
  final String nombre;
  final String codigo;
  final String tiendaId;
  final String ubicacion;
  final String tipo; // Principal, Obra, Transito
  final double? capacidadM3;
  final double? areaM2;
  final bool activo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const Almacen({
    required this.id,
    required this.nombre,
    required this.codigo,
    required this.tiendaId,
    required this.ubicacion,
    required this.tipo,
    this.capacidadM3,
    this.areaM2,
    required this.activo,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  /// Check if warehouse is deleted (soft delete)
  bool get isDeleted => deletedAt != null;

  /// Check if warehouse is active and not deleted
  bool get isActiveAndNotDeleted => activo && !isDeleted;

  /// Check if this is the main warehouse
  bool get isPrincipal => tipo?.toLowerCase() == 'principal';

  /// Get capacity utilization percentage
  double? getCapacityUtilization(double usedM3) {
    if (capacidadM3 == null || capacidadM3! <= 0) return null;
    return (usedM3 / capacidadM3!) * 100;
  }
  
  // Convert Almacen to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'codigo': codigo,
      'tiendaId': tiendaId,
      'ubicacion': ubicacion,
      'tipo': tipo,
      'capacidadM3': capacidadM3,
      'areaM2': areaM2,
      'activo': activo,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  // Convert Almacen entity to JSON map with snake_case keys (for Supabase remote)
  Map<String, dynamic> toRemoteJson() {
    return {
      'id': id,
      'nombre': nombre,
      'codigo': codigo,
      'tienda_id': tiendaId,
      'ubicacion': ubicacion,
      'tipo': tipo,
      'capacidad_m3': capacidadM3,
      'area_m2': areaM2,
      'activo': activo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  // Create fromJson local camelCase keys
  factory Almacen.fromJson(Map<String, dynamic> json) {
    return Almacen(
      id: json['id'],
      nombre: json['nombre'],
      codigo: json['codigo'],
      tiendaId: json['tiendaId'],
      ubicacion: json['ubicacion'],
      tipo: json['tipo'],
      capacidadM3: (json['capacidadM3'] as num?)?.toDouble(),
      areaM2: (json['areaM2'] as num?)?.toDouble(),
      activo: json['activo'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  // Create fromRemoteJson with snake_case keys
  factory Almacen.fromRemoteJson(Map<String, dynamic> json) {
    return Almacen(
      id: json['id'],
      nombre: json['nombre'],
      codigo: json['codigo'],
      tiendaId: json['tienda_id'],
      ubicacion: json['ubicacion'],
      tipo: json['tipo'],
      capacidadM3: (json['capacidad_m3'] as num?)?.toDouble(),
      areaM2: (json['area_m2'] as num?)?.toDouble(),
      activo: json['activo'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }


  @override
  List<Object?> get props => [
        id,
        nombre,
        codigo,
        tiendaId,
        ubicacion,
        tipo,
        capacidadM3,
        areaM2,
        activo,
        createdAt,
        updatedAt,
        deletedAt,
      ];

  @override
  String toString() {
    return 'Almacen(id: $id, nombre: $nombre, codigo: $codigo, tipo: $tipo, activo: $activo)';
  }

  


}
