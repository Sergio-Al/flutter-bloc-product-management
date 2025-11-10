import 'package:equatable/equatable.dart';

/// Modelo de datos para Unidad de Medida
class UnidadMedidaModel extends Equatable {
  final String id;
  final String nombre;
  final String abreviatura;
  final String tipo; // Peso, Volumen, Longitud, Unidad, Area
  final double? factorConversion;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UnidadMedidaModel({
    required this.id,
    required this.nombre,
    required this.abreviatura,
    required this.tipo,
    this.factorConversion,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UnidadMedidaModel.fromJson(Map<String, dynamic> json) {
    return UnidadMedidaModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      abreviatura: json['abreviatura'] as String,
      tipo: json['tipo'] as String,
      factorConversion: json['factor_conversion'] != null
          ? (json['factor_conversion'] as num).toDouble()
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'abreviatura': abreviatura,
      'tipo': tipo,
      'factor_conversion': factorConversion,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UnidadMedidaModel copyWith({
    String? id,
    String? nombre,
    String? abreviatura,
    String? tipo,
    double? factorConversion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UnidadMedidaModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      abreviatura: abreviatura ?? this.abreviatura,
      tipo: tipo ?? this.tipo,
      factorConversion: factorConversion ?? this.factorConversion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nombre,
        abreviatura,
        tipo,
        factorConversion,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() => 'UnidadMedidaModel(nombre: $nombre, abreviatura: $abreviatura)';
}
