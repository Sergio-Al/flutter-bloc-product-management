import 'package:equatable/equatable.dart';
import '../../domain/entities/producto.dart';

/// Modelo de datos para Producto
/// Maneja la serialización JSON para la API de Supabase
class ProductoModel extends Equatable {
  final String id;
  final String nombre;
  final String codigo;
  final String? descripcion;
  final String categoriaId;
  final String unidadMedidaId;
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

  const ProductoModel({
    required this.id,
    required this.nombre,
    required this.codigo,
    this.descripcion,
    required this.categoriaId,
    required this.unidadMedidaId,
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

  /// Crea un ProductoModel desde JSON (API de Supabase)
  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      codigo: json['codigo'] as String,
      descripcion: json['descripcion'] as String?,
      categoriaId: json['categoria_id'] as String,
      unidadMedidaId: json['unidad_medida_id'] as String,
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
      requiereAlmacenCubierto: json['requiere_almacen_cubierto'] as bool? ?? false,
      materialPeligroso: json['material_peligroso'] as bool? ?? false,
      imagenUrl: json['imagen_url'] as String?,
      fichaTecnicaUrl: json['ficha_tecnica_url'] as String?,
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

  /// Convierte ProductoModel a JSON para enviar a la API
  Map<String, dynamic> toJson() {
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

  /// Copia el modelo con campos actualizados
  ProductoModel copyWith({
    String? id,
    String? nombre,
    String? codigo,
    String? descripcion,
    String? categoriaId,
    String? unidadMedidaId,
    String? proveedorPrincipalId,
    double? precioCompra,
    double? precioVenta,
    double? pesoUnitarioKg,
    double? volumenUnitarioM3,
    int? stockMinimo,
    int? stockMaximo,
    String? marca,
    String? gradoCalidad,
    String? normaTecnica,
    bool? requiereAlmacenCubierto,
    bool? materialPeligroso,
    String? imagenUrl,
    String? fichaTecnicaUrl,
    bool? activo,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? syncId,
    DateTime? lastSync,
  }) {
    return ProductoModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      codigo: codigo ?? this.codigo,
      descripcion: descripcion ?? this.descripcion,
      categoriaId: categoriaId ?? this.categoriaId,
      unidadMedidaId: unidadMedidaId ?? this.unidadMedidaId,
      proveedorPrincipalId: proveedorPrincipalId ?? this.proveedorPrincipalId,
      precioCompra: precioCompra ?? this.precioCompra,
      precioVenta: precioVenta ?? this.precioVenta,
      pesoUnitarioKg: pesoUnitarioKg ?? this.pesoUnitarioKg,
      volumenUnitarioM3: volumenUnitarioM3 ?? this.volumenUnitarioM3,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      stockMaximo: stockMaximo ?? this.stockMaximo,
      marca: marca ?? this.marca,
      gradoCalidad: gradoCalidad ?? this.gradoCalidad,
      normaTecnica: normaTecnica ?? this.normaTecnica,
      requiereAlmacenCubierto: requiereAlmacenCubierto ?? this.requiereAlmacenCubierto,
      materialPeligroso: materialPeligroso ?? this.materialPeligroso,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      fichaTecnicaUrl: fichaTecnicaUrl ?? this.fichaTecnicaUrl,
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
    return 'ProductoModel(id: $id, nombre: $nombre, codigo: $codigo, activo: $activo)';
  }

  /// Convert Model to Entity (Domain layer)
  Producto toEntity() {
    return Producto(
      id: id,
      nombre: nombre,
      codigo: codigo,
      descripcion: descripcion,
      categoriaId: categoriaId,
      unidadMedidaId: unidadMedidaId,
      proveedorPrincipalId: proveedorPrincipalId,
      precioCompra: precioCompra,
      precioVenta: precioVenta,
      pesoUnitarioKg: pesoUnitarioKg,
      volumenUnitarioM3: volumenUnitarioM3,
      stockMinimo: stockMinimo,
      stockMaximo: stockMaximo,
      marca: marca,
      gradoCalidad: gradoCalidad,
      normaTecnica: normaTecnica,
      requiereAlmacenCubierto: requiereAlmacenCubierto,
      materialPeligroso: materialPeligroso,
      imagenUrl: imagenUrl,
      fichaTecnicaUrl: fichaTecnicaUrl,
      activo: activo,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }

  /// Create Model from Entity (Domain layer)
  factory ProductoModel.fromEntity(Producto entity) {
    return ProductoModel(
      id: entity.id,
      nombre: entity.nombre,
      codigo: entity.codigo,
      descripcion: entity.descripcion,
      categoriaId: entity.categoriaId ?? '',
      unidadMedidaId: entity.unidadMedidaId ?? '',
      proveedorPrincipalId: entity.proveedorPrincipalId,
      precioCompra: entity.precioCompra,
      precioVenta: entity.precioVenta,
      pesoUnitarioKg: entity.pesoUnitarioKg,
      volumenUnitarioM3: entity.volumenUnitarioM3,
      stockMinimo: entity.stockMinimo,
      stockMaximo: entity.stockMaximo,
      marca: entity.marca,
      gradoCalidad: entity.gradoCalidad,
      normaTecnica: entity.normaTecnica,
      requiereAlmacenCubierto: entity.requiereAlmacenCubierto,
      materialPeligroso: entity.materialPeligroso,
      imagenUrl: entity.imagenUrl,
      fichaTecnicaUrl: entity.fichaTecnicaUrl,
      activo: entity.activo,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
      syncId: null,
      lastSync: null,
    );
  }
}
