import 'package:equatable/equatable.dart';
import '../../../domain/entities/lote.dart';

abstract class LoteEvent extends Equatable {
  const LoteEvent();

  @override
  List<Object?> get props => [];
}

// ==================== Read Operations ====================

/// Load all lotes
class LoadLotes extends LoteEvent {
  const LoadLotes();
}

/// Load lote by ID
class LoadLoteById extends LoteEvent {
  final String id;
  const LoadLoteById(this.id);
  
  @override
  List<Object?> get props => [id];
}

/// Load lote by numero
class LoadLoteByNumero extends LoteEvent {
  final String numero;
  const LoadLoteByNumero(this.numero);
  
  @override
  List<Object?> get props => [numero];
}

/// Search lotes by query (numeroLote, observaciones)
class SearchLotes extends LoteEvent {
  final String query;
  const SearchLotes(this.query);
  
  @override
  List<Object?> get props => [query];
}

// ==================== Filter Operations ====================

/// Load lotes by producto
class LoadLotesByProducto extends LoteEvent {
  final String productoId;
  const LoadLotesByProducto(this.productoId);
  
  @override
  List<Object?> get props => [productoId];
}

/// Load lotes by proveedor
class LoadLotesByProveedor extends LoteEvent {
  final String proveedorId;
  const LoadLotesByProveedor(this.proveedorId);
  
  @override
  List<Object?> get props => [proveedorId];
}

/// Load lotes by factura
class LoadLotesByFactura extends LoteEvent {
  final String facturaId;
  const LoadLotesByFactura(this.facturaId);
  
  @override
  List<Object?> get props => [facturaId];
}

/// Load lotes con stock (cantidadActual > 0)
class LoadLotesConStock extends LoteEvent {
  const LoadLotesConStock();
}

/// Load lotes vacios (cantidadActual = 0)
class LoadLotesVacios extends LoteEvent {
  const LoadLotesVacios();
}

/// Load lotes vencidos
class LoadLotesVencidos extends LoteEvent {
  const LoadLotesVencidos();
}

/// Load lotes por vencer (within 30 days)
class LoadLotesPorVencer extends LoteEvent {
  const LoadLotesPorVencer();
}

/// Load lotes con certificado de calidad
class LoadLotesConCertificado extends LoteEvent {
  const LoadLotesConCertificado();
}

// ==================== Write Operations ====================

/// Create a new lote
class CreateLote extends LoteEvent {
  final Lote lote;
  const CreateLote(this.lote);
  
  @override
  List<Object?> get props => [lote];
}

/// Update an existing lote
class UpdateLote extends LoteEvent {
  final Lote lote;
  const UpdateLote(this.lote);
  
  @override
  List<Object?> get props => [lote];
}

/// Update cantidad of a lote
class UpdateCantidadLote extends LoteEvent {
  final String id;
  final int nuevaCantidad;
  const UpdateCantidadLote({
    required this.id,
    required this.nuevaCantidad,
  });
  
  @override
  List<Object?> get props => [id, nuevaCantidad];
}

/// Delete a lote
class DeleteLote extends LoteEvent {
  final String id;
  const DeleteLote(this.id);
  
  @override
  List<Object?> get props => [id];
}
