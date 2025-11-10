import 'package:equatable/equatable.dart';

/// Producto entity - Pure business object
/// Represents a construction material product
class Producto extends Equatable {
  final String id;
  final String nombre;
  final String codigo;
  final String? descripcion;
  final String? categoriaId;
  final String? unidadMedidaId;
  final String? proveedorPrincipalId;
  final double precioCompra;
  final double precioVenta;
  final double? pesoUnitarioKg;
  final double? volumenUnitarioM3;
  final int stockMinimo;
  final int stockMaximo;
  final String? marca;
  final String? gradoCalidad;
  final String? normaTecnica;
  final bool requiereAlmacenCubierto;
  final bool materialPeligroso;
  final String? imagenUrl;
  final String? fichaTecnicaUrl;
  final bool activo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? syncId;
  final DateTime? lastSync;

  const Producto({
    required this.id,
    required this.nombre,
    required this.codigo,
    this.descripcion,
    this.categoriaId,
    this.unidadMedidaId,
    this.proveedorPrincipalId,
    required this.precioCompra,
    required this.precioVenta,
    this.pesoUnitarioKg,
    this.volumenUnitarioM3,
    required this.stockMinimo,
    required this.stockMaximo,
    this.marca,
    this.gradoCalidad,
    this.normaTecnica,
    required this.requiereAlmacenCubierto,
    required this.materialPeligroso,
    this.imagenUrl,
    this.fichaTecnicaUrl,
    required this.activo,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.syncId,
    this.lastSync,
  });

  /// Calculate profit margin percentage
  double get margenGanancia {
    if (precioCompra <= 0) return 0;
    return ((precioVenta - precioCompra) / precioCompra) * 100;
  }

  /// Check if product is deleted (soft delete)
  bool get isDeleted => deletedAt != null;

  /// Check if product is active and not deleted
  bool get isActiveAndNotDeleted => activo && !isDeleted;

  /// Check if product requires special storage
  bool get requiresSpecialStorage =>
      requiereAlmacenCubierto || materialPeligroso;

  /// Check if product has technical documentation
  bool get hasTechnicalDocs =>
      fichaTecnicaUrl != null && fichaTecnicaUrl!.isNotEmpty;

  /// Check if product has image
  bool get hasImage => imagenUrl != null && imagenUrl!.isNotEmpty;

  /// Get full product name with brand
  String get fullName {
    if (marca != null && marca!.isNotEmpty) {
      return '$nombre - $marca';
    }
    return nombre;
  }

  /// Check if stock level is below minimum
  bool isStockBelowMinimum(int currentStock) {
    return currentStock < stockMinimo;
  }

  /// Check if stock level is above maximum
  bool isStockAboveMaximum(int currentStock) {
    return currentStock > stockMaximo;
  }

  /// Calculate stock health percentage (0-100)
  double getStockHealthPercentage(int currentStock) {
    if (stockMaximo <= 0) return 0;
    final percentage = (currentStock / stockMaximo) * 100;
    return percentage.clamp(0, 100);
  }

  @override
  List<Object?> get props => [
        id,
        nombre,
        codigo,
        descripcion,
        categoriaId,
        unidadMedidaId,
        proveedorPrincipalId,
        precioCompra,
        precioVenta,
        pesoUnitarioKg,
        volumenUnitarioM3,
        stockMinimo,
        stockMaximo,
        marca,
        gradoCalidad,
        normaTecnica,
        requiereAlmacenCubierto,
        materialPeligroso,
        imagenUrl,
        fichaTecnicaUrl,
        activo,
        createdAt,
        updatedAt,
        deletedAt,
        syncId,
        lastSync,
      ];

  @override
  String toString() {
    return 'Producto(id: $id, nombre: $nombre, codigo: $codigo, activo: $activo)';
  }
}
