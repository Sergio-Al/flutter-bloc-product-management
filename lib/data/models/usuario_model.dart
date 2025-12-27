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
  final String? tiendaNombre; // Added for caching
  final String rolId;
  final String? rolNombre; // Added for caching
  final String? authUserId;
  final bool activo;
  final bool mfaEnabled; // Added for caching
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
    this.tiendaNombre,
    required this.rolId,
    this.rolNombre,
    this.authUserId,
    required this.activo,
    this.mfaEnabled = false,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.syncId,
    this.lastSync,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
      print('Parsing UsuarioModel from JSON: $json');
      // Support two shapes:
      // 1) { "user": { ... nested user fields ... }, ... }
      // 2) flat { "id": "...", "tienda_id": "...", "rol_id": "...", ... }
      final user = (json['user'] is Map<String, dynamic>) ? json['user'] as Map<String, dynamic> : json;
  
      String? tiendaId;
      String? tiendaNombre;
      final tienda = user['tienda'];
      if (tienda is Map<String, dynamic>) {
        tiendaId = tienda['id'] as String?;
        tiendaNombre = tienda['nombre'] as String?;
      } else {
        tiendaId = user['tienda_id'] as String?;
        tiendaNombre = user['tienda_nombre'] as String?; // Load from cache
      }

      String rolId = '';
      String? rolNombre;
      final rol = user['rol'];
      if (rol is Map<String, dynamic>) {
        rolId = rol['id'] as String? ?? '';
        rolNombre = rol['nombre'] as String?;
      } else {
        rolId = user['rol_id'] as String? ?? '';
        rolNombre = user['rol_nombre'] as String?; // Load from cache
      }

      return UsuarioModel(
        id: user['id'] as String,
        email: user['email'] as String,
        nombreCompleto: user['nombre_completo'] as String? ?? user['nombre'] as String? ?? '',
        telefono: user['telefono'] as String?,
        tiendaId: tiendaId,
        tiendaNombre: tiendaNombre,
        rolId: rolId,
        rolNombre: rolNombre,
        authUserId: user['auth_user_id'] as String? ?? json['access_token'] as String?,
        activo: (user['activo'] as bool?) ?? true,
        mfaEnabled: (user['mfa_enabled'] as bool?) ?? (user['mfaEnabled'] as bool?) ?? false,
        createdAt: user['created_at'] != null
            ? DateTime.parse(user['created_at'] as String)
            : DateTime.now(),
        updatedAt: user['updated_at'] != null
            ? DateTime.parse(user['updated_at'] as String)
            : DateTime.now(),
        deletedAt: user['deleted_at'] != null ? DateTime.parse(user['deleted_at'] as String) : null,
        syncId: user['sync_id'] as String? ?? json['sync_id'] as String?,
        lastSync: (user['last_sync'] != null)
            ? DateTime.parse(user['last_sync'] as String)
            : (json['last_sync'] != null ? DateTime.parse(json['last_sync'] as String) : null),
      );
    }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nombre_completo': nombreCompleto,
      'telefono': telefono,
      'tienda_id': tiendaId,
      'tienda_nombre': tiendaNombre, // Cache tienda name
      'rol_id': rolId,
      'rol_nombre': rolNombre, // Cache rol name
      'auth_user_id': authUserId,
      'activo': activo,
      'mfa_enabled': mfaEnabled,
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
    String? tiendaNombre,
    String? rolId,
    String? rolNombre,
    String? authUserId,
    bool? activo,
    bool? mfaEnabled,
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
      tiendaNombre: tiendaNombre ?? this.tiendaNombre,
      rolId: rolId ?? this.rolId,
      rolNombre: rolNombre ?? this.rolNombre,
      authUserId: authUserId ?? this.authUserId,
      activo: activo ?? this.activo,
      mfaEnabled: mfaEnabled ?? this.mfaEnabled,
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
        tiendaNombre,
        rolId,
        rolNombre,
        authUserId,
        activo,
        mfaEnabled,
        createdAt,
        updatedAt,
        deletedAt,
        syncId,
        lastSync,
      ];

  @override
  String toString() => 'UsuarioModel(id: $id, email: $email, nombreCompleto: $nombreCompleto, rolNombre: $rolNombre)';

  /// Convert Model to Entity (Domain layer)
  Usuario toEntity() {
    return Usuario(
      id: id,
      email: email,
      nombreCompleto: nombreCompleto,
      telefono: telefono,
      tiendaId: tiendaId,
      tiendaNombre: tiendaNombre, // Now properly cached
      rolId: rolId,
      rolNombre: rolNombre, // Now properly cached
      authUserId: authUserId,
      activo: activo,
      mfaEnabled: mfaEnabled, // Now properly cached
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
      tiendaNombre: entity.tiendaNombre,
      rolId: entity.rolId ?? '',
      rolNombre: entity.rolNombre,
      authUserId: entity.authUserId,
      activo: entity.activo,
      mfaEnabled: entity.mfaEnabled,
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
