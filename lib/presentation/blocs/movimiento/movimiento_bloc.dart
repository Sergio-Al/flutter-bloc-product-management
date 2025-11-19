import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../../domain/usecases/movimientos/movimiento_usecases.dart';

import 'movimiento_event.dart';
import 'movimiento_state.dart';

class MovimientoBloc extends Bloc<MovimientoEvent, MovimientoState> {
  final GetMovimientosUsecase getMovimientos;
  final GetMovimientoByIdUsecase getMovimientoById;
  final GetMovimientoByNumeroUsecase getMovimientoByNumero;
  final GetMovimientosByProductoUsecase getMovimientosByProducto;
  final GetMovimientosByTiendaUsecase getMovimientosByTienda;
  final GetMovimientosByUsuarioUsecase getMovimientosByUsuario;
  final GetMovimientosByTipoUsecase getMovimientosByTipo;
  final GetMovimientosByEstadoUsecase getMovimientosByEstado;
  final GetMovimientosByFechaRangoUsecase getMovimientosByFechaRango;
  final GetMovimientosPendientesUsecase getMovimientosPendientes;
  final GetMovimientosEnTransitoUsecase getMovimientosEnTransito;
  final CreateCompraUsecase createCompra;
  final CreateVentaUsecase createVenta;
  final CreateTransferenciaUsecase createTransferencia;
  final CreateAjusteUsecase createAjuste;
  final CreateDevolucionUsecase createDevolucion;
  final CreateMermaUsecase createMerma;
  final UpdateMovimientoUsecase updateMovimiento;
  final CompletarMovimientoUsecase completarMovimiento;
  final CancelarMovimientoUsecase cancelarMovimiento;

  MovimientoBloc({
    required this.getMovimientos,
    required this.getMovimientoById,
    required this.getMovimientoByNumero,
    required this.getMovimientosByProducto,
    required this.getMovimientosByTienda,
    required this.getMovimientosByUsuario,
    required this.getMovimientosByTipo,
    required this.getMovimientosByEstado,
    required this.getMovimientosByFechaRango,
    required this.getMovimientosPendientes,
    required this.getMovimientosEnTransito,
    required this.createCompra,
    required this.createVenta,
    required this.createTransferencia,
    required this.createAjuste,
    required this.createDevolucion,
    required this.createMerma,
    required this.updateMovimiento,
    required this.completarMovimiento,
    required this.cancelarMovimiento,
  }) : super(const MovimientoInitial()) {
    on<LoadMovimientos>(_onLoadMovimientos);
    on<LoadMovimientoById>(_onLoadMovimientoById);
    on<LoadMovimientoByNumero>(_onLoadMovimientoByNumero);
    on<LoadMovimientosByProducto>(_onLoadMovimientosByProducto);
    on<LoadMovimientosByTienda>(_onLoadMovimientosByTienda);
    on<LoadMovimientosByUsuario>(_onLoadMovimientosByUsuario);
    on<LoadMovimientosByTipo>(_onLoadMovimientosByTipo);
    on<LoadMovimientosByEstado>(_onLoadMovimientosByEstado);
    on<LoadMovimientosByFechaRango>(_onLoadMovimientosByFechaRango);
    on<LoadMovimientosPendientes>(_onLoadMovimientosPendientes);
    on<LoadMovimientosEnTransito>(_onLoadMovimientosEnTransito);
    on<CreateCompraEvent>(_onCreateCompra);
    on<CreateVentaEvent>(_onCreateVenta);
    on<CreateTransferenciaEvent>(_onCreateTransferencia);
    on<CreateAjusteEvent>(_onCreateAjuste);
    on<CreateDevolucionEvent>(_onCreateDevolucion);
    on<CreateMermaEvent>(_onCreateMerma);
    on<UpdateMovimientoEvent>(_onUpdateMovimiento);
    on<CompletarMovimientoEvent>(_onCompletarMovimiento);
    on<CancelarMovimientoEvent>(_onCancelarMovimiento);
  }

  // Query handlers
  Future<void> _onLoadMovimientos(
    LoadMovimientos event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(const MovimientoLoading());
    final result = await getMovimientos();
    result.fold(
      (failure) => emit(MovimientoError(failure.message)),
      (movimientos) => emit(MovimientosLoaded(movimientos)),
    );
  }

  Future<void> _onLoadMovimientoById(
    LoadMovimientoById event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(const MovimientoLoading());
    final result = await getMovimientoById(event.id);
    result.fold(
      (failure) => emit(MovimientoError(failure.message)),
      (movimiento) => emit(MovimientoLoaded(movimiento)),
    );
  }

  Future<void> _onLoadMovimientoByNumero(
    LoadMovimientoByNumero event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(const MovimientoLoading());
    final result = await getMovimientoByNumero(event.numeroMovimiento);
    result.fold(
      (failure) => emit(MovimientoError(failure.message)),
      (movimiento) => emit(MovimientoLoaded(movimiento)),
    );
  }

  Future<void> _onLoadMovimientosByProducto(
    LoadMovimientosByProducto event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(const MovimientoLoading());
    final result = await getMovimientosByProducto(event.productoId);
    result.fold(
      (failure) => emit(MovimientoError(failure.message)),
      (movimientos) => emit(MovimientosLoaded(movimientos)),
    );
  }

  Future<void> _onLoadMovimientosByTienda(
    LoadMovimientosByTienda event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(const MovimientoLoading());
    final result = await getMovimientosByTienda(event.tiendaId);
    result.fold(
      (failure) => emit(MovimientoError(failure.message)),
      (movimientos) => emit(MovimientosLoaded(movimientos)),
    );
  }

  Future<void> _onLoadMovimientosByUsuario(
    LoadMovimientosByUsuario event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(const MovimientoLoading());
    final result = await getMovimientosByUsuario(event.usuarioId);
    result.fold(
      (failure) => emit(MovimientoError(failure.message)),
      (movimientos) => emit(MovimientosLoaded(movimientos)),
    );
  }

  Future<void> _onLoadMovimientosByTipo(
    LoadMovimientosByTipo event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(const MovimientoLoading());
    final result = await getMovimientosByTipo(event.tipo);
    result.fold(
      (failure) => emit(MovimientoError(failure.message)),
      (movimientos) => emit(MovimientosLoaded(movimientos)),
    );
  }

  Future<void> _onLoadMovimientosByEstado(
    LoadMovimientosByEstado event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(const MovimientoLoading());
    final result = await getMovimientosByEstado(event.estado);
    result.fold(
      (failure) => emit(MovimientoError(failure.message)),
      (movimientos) => emit(MovimientosLoaded(movimientos)),
    );
  }

  Future<void> _onLoadMovimientosByFechaRango(
    LoadMovimientosByFechaRango event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(const MovimientoLoading());
    final result = await getMovimientosByFechaRango(
      fechaInicio: event.fechaInicio,
      fechaFin: event.fechaFin,
    );
    result.fold(
      (failure) => emit(MovimientoError(failure.message)),
      (movimientos) => emit(MovimientosLoaded(movimientos)),
    );
  }

  Future<void> _onLoadMovimientosPendientes(
    LoadMovimientosPendientes event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(const MovimientoLoading());
    final result = await getMovimientosPendientes();
    result.fold(
      (failure) => emit(MovimientoError(failure.message)),
      (movimientos) => emit(MovimientosLoaded(movimientos)),
    );
  }

  Future<void> _onLoadMovimientosEnTransito(
    LoadMovimientosEnTransito event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(const MovimientoLoading());
    final result = await getMovimientosEnTransito();
    result.fold(
      (failure) => emit(MovimientoError(failure.message)),
      (movimientos) => emit(MovimientosLoaded(movimientos)),
    );
  }

  // Create handlers
  Future<void> _onCreateCompra(
    CreateCompraEvent event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(const MovimientoLoading());
    try {
      await createCompra(
        productoId: event.productoId,
        tiendaDestinoId: event.tiendaDestinoId,
        proveedorId: event.proveedorId,
        cantidad: event.cantidad,
        costoUnitario: event.costoUnitario,
        loteId: event.loteId,
        numeroFactura: event.numeroFactura,
        observaciones: event.observaciones,
      );
      emit(const MovimientoOperationSuccess('Compra creada exitosamente'));
    } catch (e) {
      emit(MovimientoError('Error al crear compra: ${e.toString()}'));
    }
  }

  Future<void> _onCreateVenta(
    CreateVentaEvent event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(const MovimientoLoading());
    try {
      await createVenta(
        productoId: event.productoId,
        tiendaOrigenId: event.tiendaOrigenId,
        cantidad: event.cantidad,
        costoUnitario: event.costoUnitario,
        loteId: event.loteId,
        numeroFactura: event.numeroFactura,
        observaciones: event.observaciones,
      );
      emit(const MovimientoOperationSuccess('Venta creada exitosamente'));
    } catch (e) {
      emit(MovimientoError('Error al crear venta: ${e.toString()}'));
    }
  }

  Future<void> _onCreateTransferencia(
    CreateTransferenciaEvent event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(const MovimientoLoading());
    try {
      await createTransferencia(
        productoId: event.productoId,
        tiendaOrigenId: event.tiendaOrigenId,
        tiendaDestinoId: event.tiendaDestinoId,
        cantidad: event.cantidad,
        loteId: event.loteId,
        vehiculoPlaca: event.vehiculoPlaca,
        conductor: event.conductor,
        numeroGuiaRemision: event.numeroGuiaRemision,
        observaciones: event.observaciones,
      );
      emit(const MovimientoOperationSuccess('Transferencia creada exitosamente'));
    } catch (e) {
      emit(MovimientoError('Error al crear transferencia: ${e.toString()}'));
    }
  }

  Future<void> _onCreateAjuste(
    CreateAjusteEvent event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(const MovimientoLoading());
    try {
      await createAjuste(
        productoId: event.productoId,
        tiendaId: event.tiendaId,
        cantidad: event.cantidad,
        motivo: event.motivo,
        observaciones: event.observaciones,
      );
      emit(const MovimientoOperationSuccess('Ajuste creado exitosamente'));
    } catch (e) {
      emit(MovimientoError('Error al crear ajuste: ${e.toString()}'));
    }
  }

  Future<void> _onCreateDevolucion(
    CreateDevolucionEvent event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(const MovimientoLoading());
    try {
      await createDevolucion(
        productoId: event.productoId,
        tiendaOrigenId: event.tiendaId,
        tiendaId: event.tiendaId,
        cantidad: event.cantidad,
        costoUnitario: 0.0,
        motivo: event.motivo,
        numeroFactura: event.numeroFactura,
        observaciones: event.observaciones,
      );
      emit(const MovimientoOperationSuccess('Devolución creada exitosamente'));
    } catch (e) {
      emit(MovimientoError('Error al crear devolución: ${e.toString()}'));
    }
  }

  Future<void> _onCreateMerma(
    CreateMermaEvent event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(const MovimientoLoading());
    try {
      await createMerma(
        productoId: event.productoId,
        tiendaId: event.tiendaId,
        cantidad: event.cantidad,
        motivo: event.motivo,
        observaciones: event.observaciones,
      );
      emit(const MovimientoOperationSuccess('Merma creada exitosamente'));
    } catch (e) {
      emit(MovimientoError('Error al crear merma: ${e.toString()}'));
    }
  }

  // Update handlers
  Future<void> _onUpdateMovimiento(
    UpdateMovimientoEvent event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(const MovimientoLoading());
    final result = await updateMovimiento(event.movimiento);
    result.fold(
      (failure) => emit(MovimientoError(failure.message)),
      (movimiento) => emit(const MovimientoOperationSuccess('Movimiento actualizado')),
    );
  }

  Future<void> _onCompletarMovimiento(
    CompletarMovimientoEvent event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(const MovimientoLoading());
    final result = await completarMovimiento(event.id);
    result.fold(
      (failure) => emit(MovimientoError(failure.message)),
      (movimiento) => emit(const MovimientoOperationSuccess('Movimiento completado')),
    );
  }

  Future<void> _onCancelarMovimiento(
    CancelarMovimientoEvent event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(const MovimientoLoading());
    final result = await cancelarMovimiento(event.id, event.motivo);
    result.fold(
      (failure) => emit(MovimientoError(failure.message)),
      (movimiento) => emit(const MovimientoOperationSuccess('Movimiento cancelado')),
    );
  }
}
