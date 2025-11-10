import 'package:equatable/equatable.dart';

/// Rol entity - Pure business object
/// Represents a user role with permissions
class Rol extends Equatable {
  final String id;
  final String nombre;
  final String? descripcion;
  final Map<String, dynamic> permisos;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Rol({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.permisos,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if this role has a specific permission
  bool hasPermission(String permissionKey) {
    return permisos[permissionKey] == true;
  }

  /// Check if this is an admin role
  bool get isAdmin => nombre.toLowerCase() == 'administrador';

  /// Check if this is a manager role (gerente or admin)
  bool get isManager =>
      nombre.toLowerCase() == 'gerente' ||
      nombre.toLowerCase() == 'administrador';

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
  String toString() {
    return 'Rol(id: $id, nombre: $nombre)';
  }
}
