import 'package:equatable/equatable.dart';

/// UnidadMedida entity - Pure business object
/// Represents a unit of measurement (Bolsa, Metro, Kilo, Litro, etc.)
class UnidadMedida extends Equatable {
  final String id;
  final String nombre;
  final String abreviatura;
  final String? tipo; // Peso, Volumen, Longitud, Unidad, Area
  final double? factorConversion;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UnidadMedida({
    required this.id,
    required this.nombre,
    required this.abreviatura,
    this.tipo,
    this.factorConversion,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert quantity to base unit using conversion factor
  double? convertToBase(double quantity) {
    if (factorConversion == null) return null;
    return quantity * factorConversion!;
  }

  /// Convert quantity from base unit
  double? convertFromBase(double baseQuantity) {
    if (factorConversion == null || factorConversion == 0) return null;
    return baseQuantity / factorConversion!;
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
  String toString() {
    return 'UnidadMedida(id: $id, nombre: $nombre, abreviatura: $abreviatura)';
  }
}
