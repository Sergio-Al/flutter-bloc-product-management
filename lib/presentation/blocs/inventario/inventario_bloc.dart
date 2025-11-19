import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_management_system/domain/usecases/inventarios/inventario_usecases.dart';

import 'inventario_event.dart';
import 'inventario_state.dart';

class InventarioBloc extends Bloc<InventarioEvent, InventarioState> {
  final GetInventariosUsecase getInventarios;
  final GetInventarioByIdUsecase getInventarioById;
  final GetInventariosByProductoUsecase getInventariosByProducto;
  final GetInventariosByAlmacenUsecase getInventariosByAlmacen;
  final GetInventariosByLoteUsecase getInventariosByLote;
  final GetInventariosByTiendaUsecase getInventariosByTienda;
  final GetInventariosDisponiblesUsecase getInventariosDisponibles;
  final GetInventariosStockBajoUsecase getInventariosStockBajo;
  final CreateInventarioUsecase createInventario;
  final UpdateInventarioUsecase updateInventario;
  final UpdateStockUsecase updateStockInventario;
  final ReservarStockUsecase reservarStockInventario;
  final LiberarStockUsecase liberarStockInventario;
  final DeleteInventarioUsecase deleteInventario;
  final AjustarInventarioUsecase ajustarInventario;

  InventarioBloc({
    required this.getInventarios,
    required this.getInventarioById,
    required this.getInventariosByProducto,
    required this.getInventariosByAlmacen,
    required this.getInventariosByLote,
    required this.getInventariosByTienda,
    required this.getInventariosDisponibles,
    required this.getInventariosStockBajo,
    required this.createInventario,
    required this.updateInventario,
    required this.updateStockInventario,
    required this.reservarStockInventario,
    required this.liberarStockInventario,
    required this.deleteInventario,
    required this.ajustarInventario,
  }) : super(const InventarioInitial()) {
    on<LoadInventarios>(_onLoadInventarios);
    on<LoadInventarioById>(_onLoadInventarioById);
    on<LoadInventariosByProducto>(_onLoadInventariosByProducto);
    on<LoadInventariosByAlmacen>(_onLoadInventariosByAlmacen);
    on<LoadInventariosByLote>(_onLoadInventariosByLote);
    on<LoadInventariosByTienda>(_onLoadInventariosByTienda);
    on<LoadInventariosDisponibles>(_onLoadInventariosDisponibles);
    on<LoadInventariosStockBajo>(_onLoadInventariosStockBajo);
    on<CreateInventario>(_onCreateInventario);
    on<UpdateInventario>(_onUpdateInventario);
    on<UpdateStockInventario>(_onUpdateStockInventario);
    on<ReservarStockInventario>(_onReservarStockInventario);
    on<LiberarStockInventario>(_onLiberarStockInventario);
    on<AjustarInventarioEvent>(_onAjustarInventario);
    on<DeleteInventario>(_onDeleteInventario);
  }

  Future<void> _onLoadInventarios(
    LoadInventarios event,
    Emitter<InventarioState> emit,
  ) async {
    emit(const InventarioLoading());
    final res = await getInventarios.call();
    res.fold(
      (failure) => emit(InventarioError(failure.message)),
      (data) => emit(InventariosLoaded(data)),
    );
  }

  Future<void> _onLoadInventarioById(
    LoadInventarioById event,
    Emitter<InventarioState> emit,
  ) async {
    emit(const InventarioLoading());
    final res = await getInventarioById.call(event.id);
    res.fold(
      (f) => emit(InventarioError(f.message)),
      (inv) => emit(InventarioLoaded(inv)),
    );
  }

  Future<void> _onLoadInventariosByProducto(
    LoadInventariosByProducto event,
    Emitter<InventarioState> emit,
  ) async {
    emit(const InventarioLoading());
    final res = await getInventariosByProducto.call(event.productoId);
    res.fold(
      (f) => emit(InventarioError(f.message)),
      (list) => emit(InventariosLoaded(list)),
    );
  }

  Future<void> _onLoadInventariosByAlmacen(
    LoadInventariosByAlmacen event,
    Emitter<InventarioState> emit,
  ) async {
    emit(const InventarioLoading());
    final res = await getInventariosByAlmacen.call(event.almacenId);
    res.fold(
      (f) => emit(InventarioError(f.message)),
      (list) => emit(InventariosLoaded(list)),
    );
  }

  Future<void> _onLoadInventariosByLote(
    LoadInventariosByLote event,
    Emitter<InventarioState> emit,
  ) async {
    emit(const InventarioLoading());
    final res = await getInventariosByLote.call(event.loteId);
    res.fold(
      (f) => emit(InventarioError(f.message)),
      (list) => emit(InventariosLoaded(list)),
    );
  }

  Future<void> _onLoadInventariosByTienda(
    LoadInventariosByTienda event,
    Emitter<InventarioState> emit,
  ) async {
    emit(const InventarioLoading());
    final res = await getInventariosByTienda.call(event.tiendaId);
    res.fold(
      (f) => emit(InventarioError(f.message)),
      (list) => emit(InventariosLoaded(list)),
    );
  }

  Future<void> _onLoadInventariosDisponibles(
    LoadInventariosDisponibles event,
    Emitter<InventarioState> emit,
  ) async {
    emit(const InventarioLoading());
    final res = await getInventariosDisponibles.call();
    res.fold(
      (f) => emit(InventarioError(f.message)),
      (list) => emit(InventariosLoaded(list)),
    );
  }

  Future<void> _onLoadInventariosStockBajo(
    LoadInventariosStockBajo event,
    Emitter<InventarioState> emit,
  ) async {
    emit(const InventarioLoading());
    final res = await getInventariosStockBajo.call();
    res.fold(
      (f) => emit(InventarioError(f.message)),
      (list) => emit(InventariosLoaded(list)),
    );
  }

  Future<void> _onCreateInventario(
    CreateInventario event,
    Emitter<InventarioState> emit,
  ) async {
    emit(const InventarioLoading());
    final res = await createInventario.call(event.inventario);
    res.fold(
      (f) => emit(InventarioError(f.message)),
      (_) => emit(const InventarioOperationSuccess('Inventario creado')),
    );
  }

  Future<void> _onUpdateInventario(
    UpdateInventario event,
    Emitter<InventarioState> emit,
  ) async {
    emit(const InventarioLoading());
    final res = await updateInventario.call(event.inventario);
    res.fold(
      (f) => emit(InventarioError(f.message)),
      (_) => emit(const InventarioOperationSuccess('Inventario actualizado')),
    );
  }

  Future<void> _onUpdateStockInventario(
    UpdateStockInventario event,
    Emitter<InventarioState> emit,
  ) async {
    emit(const InventarioLoading());
    final res = await updateStockInventario.call(
      event.inventarioId,
      event.cantidad,
    );
    res.fold(
      (f) => emit(InventarioError(f.message)),
      (_) => emit(const InventarioOperationSuccess('Stock actualizado')),
    );
  }

  Future<void> _onReservarStockInventario(
    ReservarStockInventario event,
    Emitter<InventarioState> emit,
  ) async {
    emit(const InventarioLoading());
    final res = await reservarStockInventario.call(
      event.inventarioId,
      event.cantidad,
    );
    res.fold(
      (f) => emit(InventarioError(f.message)),
      (_) => emit(const InventarioOperationSuccess('Stock reservado')),
    );
  }

  Future<void> _onLiberarStockInventario(
    LiberarStockInventario event,
    Emitter<InventarioState> emit,
  ) async {
    emit(const InventarioLoading());
    final res = await liberarStockInventario.call(
      event.inventarioId,
      event.cantidad,
    );
    res.fold(
      (f) => emit(InventarioError(f.message)),
      (_) => emit(const InventarioOperationSuccess('Stock liberado')),
    );
  }

  Future<void> _onAjustarInventario(
    AjustarInventarioEvent event,
    Emitter<InventarioState> emit,
  ) async {
    emit(const InventarioLoading());
    final res = await ajustarInventario.call(
      event.inventarioId,
      event.nuevaCantidad,
      event.motivo,
    );
    res.fold(
      (f) => emit(InventarioError(f.message)),
      (_) => emit(const InventarioOperationSuccess('Inventario ajustado')),
    );
  }

  Future<void> _onDeleteInventario(
    DeleteInventario event,
    Emitter<InventarioState> emit,
  ) async {
    emit(const InventarioLoading());
    final res = await deleteInventario.call(event.id);
    res.fold(
      (f) => emit(InventarioError(f.message)),
      (_) => emit(const InventarioOperationSuccess('Inventario eliminado')),
    );
  }
}
