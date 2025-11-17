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

  /// Convert Producto entity to JSON map (camelCase for local storage)
  /// Useful for local database storage or API communication
  /// Returns a Map<String, dynamic> representation of the Producto
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'codigo': codigo,
      'descripcion': descripcion,
      'categoriaId': categoriaId,
      'unidadMedidaId': unidadMedidaId,
      'proveedorPrincipalId': proveedorPrincipalId,
      'precioCompra': precioCompra,
      'precioVenta': precioVenta,
      'pesoUnitarioKg': pesoUnitarioKg,
      'volumenUnitarioM3': volumenUnitarioM3,
      'stockMinimo': stockMinimo,
      'stockMaximo': stockMaximo,
      'marca': marca,
      'gradoCalidad': gradoCalidad,
      'normaTecnica': normaTecnica,
      'requiereAlmacenCubierto': requiereAlmacenCubierto,
      'materialPeligroso': materialPeligroso,
      'imagenUrl': imagenUrl,
      'fichaTecnicaUrl': fichaTecnicaUrl,
      'activo': activo,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'syncId': syncId,
      'lastSync': lastSync?.toIso8601String(),
    };
  }

  /// Convert Producto entity to JSON map with snake_case (for Supabase remote)
  /// Matches the Supabase database schema column names
  Map<String, dynamic> toRemoteJson() {
    return {
      'id': id,
      'nombre': nombre,
      'codigo': codigo,
      'descripcion': descripcion,
      'categoria_id': categoriaId,
      'unidad_medida_id': unidadMedidaId,
      'proveedor_principal_id': proveedorPrincipalId,
      'precio_compra': precioCompra,
      'precio_venta': precioVenta,
      'peso_unitario_kg': pesoUnitarioKg,
      'volumen_unitario_m3': volumenUnitarioM3,
      'stock_minimo': stockMinimo,
      'stock_maximo': stockMaximo,
      'marca': marca,
      'grado_calidad': gradoCalidad,
      'norma_tecnica': normaTecnica,
      'requiere_almacen_cubierto': requiereAlmacenCubierto,
      'material_peligroso': materialPeligroso,
      'imagen_url': imagenUrl,
      'ficha_tecnica_url': fichaTecnicaUrl,
      'activo': activo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'sync_id': syncId,
      'last_sync': lastSync?.toIso8601String(),
    };
  } 

  /// Create Producto entity from JSON map (camelCase from local storage)
  /// Useful for local database retrieval or API communication
  /// Expects a Map<String, dynamic> representation of the Producto
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      codigo: json['codigo'] as String,
      descripcion: json['descripcion'] as String?,
      categoriaId: json['categoriaId'] as String?,
      unidadMedidaId: json['unidadMedidaId'] as String?,
      proveedorPrincipalId: json['proveedorPrincipalId'] as String?,
      precioCompra: (json['precioCompra'] as num).toDouble(),
      precioVenta: (json['precioVenta'] as num).toDouble(),
      pesoUnitarioKg: json['pesoUnitarioKg'] != null
          ? (json['pesoUnitarioKg'] as num).toDouble()
          : null,
      volumenUnitarioM3: json['volumenUnitarioM3'] != null
          ? (json['volumenUnitarioM3'] as num).toDouble()
          : null,
      stockMinimo: json['stockMinimo'] as int,
      stockMaximo: json['stockMaximo'] as int,
      marca: json['marca'] as String?,
      gradoCalidad: json['gradoCalidad'] as String?,
      normaTecnica: json['normaTecnica'] as String?,
      requiereAlmacenCubierto: json['requiereAlmacenCubierto'] as bool,
      materialPeligroso: json['materialPeligroso'] as bool,
      imagenUrl: json['imagenUrl'] as String?,
      fichaTecnicaUrl: json['fichaTecnicaUrl'] as String?,
      activo: json['activo'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
      syncId: json['syncId'] as String?,
      lastSync: json['lastSync'] != null
          ? DateTime.parse(json['lastSync'] as String)
          : null,
    );
  }

  /// Create Producto entity from JSON map with snake_case (from Supabase remote)
  /// Matches the Supabase database schema column names
  factory Producto.fromRemoteJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      codigo: json['codigo'] as String,
      descripcion: json['descripcion'] as String?,
      categoriaId: json['categoria_id'] as String?,
      unidadMedidaId: json['unidad_medida_id'] as String?,
      proveedorPrincipalId: json['proveedor_principal_id'] as String?,
      precioCompra: (json['precio_compra'] as num).toDouble(),
      precioVenta: (json['precio_venta'] as num).toDouble(),
      pesoUnitarioKg: json['peso_unitario_kg'] != null
          ? (json['peso_unitario_kg'] as num).toDouble()
          : null,
      volumenUnitarioM3: json['volumen_unitario_m3'] != null
          ? (json['volumen_unitario_m3'] as num).toDouble()
          : null,
      stockMinimo: json['stock_minimo'] as int,
      stockMaximo: json['stock_maximo'] as int,
      marca: json['marca'] as String?,
      gradoCalidad: json['grado_calidad'] as String?,
      normaTecnica: json['norma_tecnica'] as String?,
      requiereAlmacenCubierto: json['requiere_almacen_cubierto'] as bool,
      materialPeligroso: json['material_peligroso'] as bool,
      imagenUrl: json['imagen_url'] as String?,
      fichaTecnicaUrl: json['ficha_tecnica_url'] as String?,
      activo: json['activo'] as bool,
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
