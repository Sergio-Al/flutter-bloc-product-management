import 'package:equatable/equatable.dart';

/// Modelo de datos para Rol
class RolModel extends Equatable {
  final String id;
  final String nombre;
  final String? descripcion;
  final Map<String, dynamic> permisos;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RolModel({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.permisos,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RolModel.fromJson(Map<String, dynamic> json) {
    return RolModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      permisos: json['permisos'] as Map<String, dynamic>? ?? {},
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'permisos': permisos,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Verifica si el rol tiene un permiso específico
  bool hasPermission(String permission) {
    return permisos[permission] == true;
  }

  /// Verifica si es un rol de administrador
  bool get isAdmin => nombre.toLowerCase() == 'administrador';

  /// Verifica si es un rol de gerente
  bool get isManager => nombre.toLowerCase() == 'gerente' || isAdmin;

  RolModel copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    Map<String, dynamic>? permisos,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RolModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      permisos: permisos ?? this.permisos,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nombre,
        descripcion,
        permisos,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() => 'RolModel(id: $id, nombre: $nombre)';
}
