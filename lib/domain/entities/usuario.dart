import 'package:equatable/equatable.dart';

/// Usuario entity - Pure business object
/// Represents a user in the system with authentication and role-based access
class Usuario extends Equatable {
  final String id;
  final String email;
  final String nombreCompleto;
  final String? telefono;
  final String? tiendaId;
  final String? rolId;
  final String? authUserId;
  final bool activo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const Usuario({
    required this.id,
    required this.email,
    required this.nombreCompleto,
    this.telefono,
    this.tiendaId,
    this.rolId,
    this.authUserId,
    required this.activo,
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
        rolId,
        authUserId,
        activo,
        createdAt,
        updatedAt,
        deletedAt,
      ];

  /// Convert Usuario to JSON (camelCase keys for local sync queue)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nombreCompleto': nombreCompleto,
      'telefono': telefono,
      'tiendaId': tiendaId,
      'rolId': rolId,
      'authUserId': authUserId,
      'activo': activo,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  /// Create Usuario from JSON (camelCase keys)
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as String,
      email: json['email'] as String,
      nombreCompleto: json['nombreCompleto'] as String,
      telefono: json['telefono'] as String?,
      tiendaId: json['tiendaId'] as String?,
      rolId: json['rolId'] as String?,
      authUserId: json['authUserId'] as String?,
      activo: json['activo'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
    );
  }

  @override
  String toString() {
    return 'Usuario(id: $id, email: $email, nombreCompleto: $nombreCompleto, activo: $activo)';
  }
}
