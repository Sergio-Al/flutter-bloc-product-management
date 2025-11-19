import 'package:equatable/equatable.dart';
import '../../domain/entities/usuario.dart';
import '../datasources/local/database/app_database.dart';

/// Modelo de datos para Usuario
class UsuarioModel extends Equatable {
  final String id;
  final String email;
  final String nombreCompleto;
  final String? telefono;
  final String? tiendaId;
  final String rolId;
  final String? authUserId;
  final bool activo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? syncId;
  final DateTime? lastSync;

  const UsuarioModel({
    required this.id,
    required this.email,
    required this.nombreCompleto,
    this.telefono,
    this.tiendaId,
    required this.rolId,
    this.authUserId,
    required this.activo,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.syncId,
    this.lastSync,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] as String,
      email: json['email'] as String,
      nombreCompleto: json['nombre_completo'] as String,
      telefono: json['telefono'] as String?,
      tiendaId: json['tienda_id'] as String?,
      rolId: json['rol_id'] as String,
      authUserId: json['auth_user_id'] as String?,
      activo: json['activo'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
      syncId: json['sync_id'] as String?,
      lastSync: json['last_sync'] != null
          ? DateTime.parse(json['last_sync'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nombre_completo': nombreCompleto,
      'telefono': telefono,
      'tienda_id': tiendaId,
      'rol_id': rolId,
      'auth_user_id': authUserId,
      'activo': activo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'sync_id': syncId,
      'last_sync': lastSync?.toIso8601String(),
    };
  }

  UsuarioModel copyWith({
    String? id,
    String? email,
    String? nombreCompleto,
    String? telefono,
    String? tiendaId,
    String? rolId,
    String? authUserId,
    bool? activo,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? syncId,
    DateTime? lastSync,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      email: email ?? this.email,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      telefono: telefono ?? this.telefono,
      tiendaId: tiendaId ?? this.tiendaId,
      rolId: rolId ?? this.rolId,
      authUserId: authUserId ?? this.authUserId,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncId: syncId ?? this.syncId,
      lastSync: lastSync ?? this.lastSync,
    );
  }

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
        syncId,
        lastSync,
      ];

  @override
  String toString() => 'UsuarioModel(id: $id, email: $email, nombreCompleto: $nombreCompleto)';

  /// Convert Model to Entity (Domain layer)
  Usuario toEntity() {
    return Usuario(
      id: id,
      email: email,
      nombreCompleto: nombreCompleto,
      telefono: telefono,
      tiendaId: tiendaId,
      rolId: rolId,
      authUserId: authUserId,
      activo: activo,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }

  /// Create Model from Entity (Domain layer)
  factory UsuarioModel.fromEntity(Usuario entity) {
    return UsuarioModel(
      id: entity.id,
      email: entity.email,
      nombreCompleto: entity.nombreCompleto,
      telefono: entity.telefono,
      tiendaId: entity.tiendaId,
      rolId: entity.rolId ?? '',
      authUserId: entity.authUserId,
      activo: entity.activo,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
      syncId: null,
      lastSync: null,
    );
  }

  /// Convert Model to Table (for local database)
  UsuarioTable toTable() {
    return UsuarioTable(
      id: id,
      email: email,
      nombreCompleto: nombreCompleto,
      telefono: telefono,
      tiendaId: tiendaId,
      rolId: rolId,
      activo: activo,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      syncId: syncId,
      lastSync: lastSync,
    );
  }
}
