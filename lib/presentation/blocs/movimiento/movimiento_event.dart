import 'package:equatable/equatable.dart';
import '../../../domain/entities/movimiento.dart';

abstract class MovimientoEvent extends Equatable {
  const MovimientoEvent();

  @override
  List<Object?> get props => [];
}

// Read operations
class LoadMovimientos extends MovimientoEvent {
  const LoadMovimientos();
}

class LoadMovimientoById extends MovimientoEvent {
  final String id;
  const LoadMovimientoById(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadMovimientoByNumero extends MovimientoEvent {
  final String numeroMovimiento;
  const LoadMovimientoByNumero(this.numeroMovimiento);

  @override
  List<Object?> get props => [numeroMovimiento];
}

class LoadMovimientosByProducto extends MovimientoEvent {
  final String productoId;
  const LoadMovimientosByProducto(this.productoId);

  @override
  List<Object?> get props => [productoId];
}

class LoadMovimientosByTienda extends MovimientoEvent {
  final String tiendaId;
  const LoadMovimientosByTienda(this.tiendaId);

  @override
  List<Object?> get props => [tiendaId];
}

class LoadMovimientosByUsuario extends MovimientoEvent {
  final String usuarioId;
  const LoadMovimientosByUsuario(this.usuarioId);

  @override
  List<Object?> get props => [usuarioId];
}

class LoadMovimientosByTipo extends MovimientoEvent {
  final String tipo;
  const LoadMovimientosByTipo(this.tipo);

  @override
  List<Object?> get props => [tipo];
}

class LoadMovimientosByEstado extends MovimientoEvent {
  final String estado;
  const LoadMovimientosByEstado(this.estado);

  @override
  List<Object?> get props => [estado];
}

class LoadMovimientosByFechaRango extends MovimientoEvent {
  final DateTime fechaInicio;
  final DateTime fechaFin;
  const LoadMovimientosByFechaRango({
    required this.fechaInicio,
    required this.fechaFin,
  });

  @override
  List<Object?> get props => [fechaInicio, fechaFin];
}

class LoadMovimientosPendientes extends MovimientoEvent {
  const LoadMovimientosPendientes();
}

class LoadMovimientosEnTransito extends MovimientoEvent {
  const LoadMovimientosEnTransito();
}

// Create operations
class CreateCompraEvent extends MovimientoEvent {
  final String productoId;
  final String tiendaDestinoId;
  final String proveedorId;
  final int cantidad;
  final double costoUnitario;
  final String? loteId;
  final String? numeroFactura;
  final String? observaciones;

  const CreateCompraEvent({
    required this.productoId,
    required this.tiendaDestinoId,
    required this.proveedorId,
    required this.cantidad,
    required this.costoUnitario,
    this.loteId,
    this.numeroFactura,
    this.observaciones,
  });

  @override
  List<Object?> get props => [
        productoId,
        tiendaDestinoId,
        proveedorId,
        cantidad,
        costoUnitario,
        loteId,
        numeroFactura,
        observaciones,
      ];
}

class CreateVentaEvent extends MovimientoEvent {
  final String productoId;
  final String tiendaOrigenId;
  final int cantidad;
  final double costoUnitario;
  final String? loteId;
  final String? numeroFactura;
  final String? observaciones;

  const CreateVentaEvent({
    required this.productoId,
    required this.tiendaOrigenId,
    required this.cantidad,
    required this.costoUnitario,
    this.loteId,
    this.numeroFactura,
    this.observaciones,
  });

  @override
  List<Object?> get props => [
        productoId,
        tiendaOrigenId,
        cantidad,
        costoUnitario,
        loteId,
        numeroFactura,
        observaciones,
      ];
}

class CreateTransferenciaEvent extends MovimientoEvent {
  final String productoId;
  final String tiendaOrigenId;
  final String tiendaDestinoId;
  final int cantidad;
  final String? loteId;
  final String? vehiculoPlaca;
  final String? conductor;
  final String? numeroGuiaRemision;
  final String? observaciones;

  const CreateTransferenciaEvent({
    required this.productoId,
    required this.tiendaOrigenId,
    required this.tiendaDestinoId,
    required this.cantidad,
    this.loteId,
    this.vehiculoPlaca,
    this.conductor,
    this.numeroGuiaRemision,
    this.observaciones,
  });

  @override
  List<Object?> get props => [
        productoId,
        tiendaOrigenId,
        tiendaDestinoId,
        cantidad,
        loteId,
        vehiculoPlaca,
        conductor,
        numeroGuiaRemision,
        observaciones,
      ];
}

class CreateAjusteEvent extends MovimientoEvent {
  final String productoId;
  final String tiendaId;
  final int cantidad;
  final String motivo;
  final String? observaciones;

  const CreateAjusteEvent({
    required this.productoId,
    required this.tiendaId,
    required this.cantidad,
    required this.motivo,
    this.observaciones,
  });

  @override
  List<Object?> get props => [
        productoId,
        tiendaId,
        cantidad,
        motivo,
        observaciones,
      ];
}

class CreateDevolucionEvent extends MovimientoEvent {
  final String productoId;
  final String tiendaId;
  final int cantidad;
  final String motivo;
  final String? numeroFactura;
  final String? observaciones;

  const CreateDevolucionEvent({
    required this.productoId,
    required this.tiendaId,
    required this.cantidad,
    required this.motivo,
    this.numeroFactura,
    this.observaciones,
  });

  @override
  List<Object?> get props => [
        productoId,
        tiendaId,
        cantidad,
        motivo,
        numeroFactura,
        observaciones,
      ];
}

class CreateMermaEvent extends MovimientoEvent {
  final String productoId;
  final String tiendaId;
  final int cantidad;
  final String motivo;
  final String? observaciones;

  const CreateMermaEvent({
    required this.productoId,
    required this.tiendaId,
    required this.cantidad,
    required this.motivo,
    this.observaciones,
  });

  @override
  List<Object?> get props => [
        productoId,
        tiendaId,
        cantidad,
        motivo,
        observaciones,
      ];
}

// Update operations
class UpdateMovimientoEvent extends MovimientoEvent {
  final Movimiento movimiento;
  const UpdateMovimientoEvent(this.movimiento);

  @override
  List<Object?> get props => [movimiento];
}

class CompletarMovimientoEvent extends MovimientoEvent {
  final String id;
  const CompletarMovimientoEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CancelarMovimientoEvent extends MovimientoEvent {
  final String id;
  final String motivo;
  const CancelarMovimientoEvent({
    required this.id,
    required this.motivo,
  });

  @override
  List<Object?> get props => [id, motivo];
}
