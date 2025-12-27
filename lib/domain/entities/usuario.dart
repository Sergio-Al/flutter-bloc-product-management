import 'package:equatable/equatable.dart';

/// Usuario entity - Pure business object
/// Represents a user in the system with authentication and role-based access
class Usuario extends Equatable {
  final String id;
  final String email;
  final String nombreCompleto;
  final String? telefono;
  final String? tiendaId;
  final String? tiendaNombre;
  final String? rolId;
  final String? rolNombre;
  final String? authUserId;
  final bool activo;
  final bool mfaEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const Usuario({
    required this.id,
    required this.email,
    required this.nombreCompleto,
    this.telefono,
    this.tiendaId,
    this.tiendaNombre,
    this.rolId,
    this.rolNombre,
    this.authUserId,
    required this.activo,
    this.mfaEnabled = false,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  /// Check if user is deleted (soft delete)
  bool get isDeleted => deletedAt != null;

  /// Check if user is active and not deleted
  bool get isActiveAndNotDeleted => activo && !isDeleted;

  @override
  List<Object?> get props => [
    id,
    email,
    nombreCompleto,
    telefono,
    tiendaId,
    tiendaNombre,
    rolId,
    rolNombre,
    authUserId,
    activo,
    mfaEnabled,
    createdAt,
    updatedAt,
    deletedAt,
  ];

  @override
  String toString() {
    return 'Usuario(id: $id, email: $email, nombreCompleto: $nombreCompleto, rol: $rolNombre, activo: $activo)';
  }
}
