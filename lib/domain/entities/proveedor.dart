import 'package:equatable/equatable.dart';

/// Proveedor entity - Pure business object
/// Represents a supplier
class Proveedor extends Equatable {
  final String id;
  final String razonSocial;
  final String nit;
  final String? nombreContacto;
  final String? telefono;
  final String? email;
  final String? direccion;
  final String? ciudad;
  final String? tipoMaterial;
  final int? diasCredito;
  final bool activo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const Proveedor({
    required this.id,
    required this.razonSocial,
    required this.nit,
    this.nombreContacto,
    this.telefono,
    this.email,
    this.direccion,
    this.ciudad,
    this.tipoMaterial,
    this.diasCredito,
    required this.activo,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  /// Check if supplier is deleted (soft delete)
  bool get isDeleted => deletedAt != null;

  /// Check if supplier is active and not deleted
  bool get isActiveAndNotDeleted => activo && !isDeleted;

  /// Check if supplier offers credit
  bool get offersCredit => diasCredito != null && diasCredito! > 0;

  /// Get payment terms description
  String get paymentTerms {
    if (diasCredito == null || diasCredito! <= 0) {
      return 'Contado';
    }
    return '$diasCredito días de crédito';
  }

  @override
  List<Object?> get props => [
        id,
        razonSocial,
        nit,
        nombreContacto,
        telefono,
        email,
        direccion,
        ciudad,
        tipoMaterial,
        diasCredito,
        activo,
        createdAt,
        updatedAt,
        deletedAt,
      ];

  @override
  String toString() {
    return 'Proveedor(id: $id, razonSocial: $razonSocial, nit: $nit, activo: $activo)';
  }
}
