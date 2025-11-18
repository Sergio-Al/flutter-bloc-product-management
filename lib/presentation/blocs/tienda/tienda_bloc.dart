import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_management_system/domain/usecases/tienda/tienda_usecases.dart';
import 'package:flutter_management_system/presentation/blocs/tienda/tienda_event.dart';
import 'package:flutter_management_system/presentation/blocs/tienda/tienda_state.dart';

class TiendaBloc extends Bloc<TiendaEvent, TiendaState> {
  final CreateTiendaUsecase createTiendaUsecase;
  final UpdateTiendaUsecase updateTiendaUsecase;
  final DeleteTiendaUsecase deleteTiendaUsecase;
  final GetTiendaByCodigoUsecase getTiendaByCodigoUsecase;
  final GetTiendaByIdUsecase getTiendaByIdUsecase;
  final GetTiendasActivasUsecase getTiendasActivasUsecase;
  final GetTiendasByCiudadUsecase getTiendasByCiudadUsecase;
  final GetTiendasByDepartamentoUsecase getTiendasByDepartamentoUsecase;
  final GetTiendasUsecase getTiendasUsecase;
  final ToggleTiendaActivaUsecase toggleTiendaActivaUsecase;

  TiendaBloc({
    required this.createTiendaUsecase,
    required this.updateTiendaUsecase,
    required this.deleteTiendaUsecase,
    required this.getTiendaByCodigoUsecase,
    required this.getTiendaByIdUsecase,
    required this.getTiendasActivasUsecase,
    required this.getTiendasByCiudadUsecase,
    required this.getTiendasByDepartamentoUsecase,
    required this.getTiendasUsecase,
    required this.toggleTiendaActivaUsecase,
  }) : super(const TiendaInitial()) {
    on<LoadTiendas>(_onLoadTiendas);
    on<LoadTiendasActivas>(_onLoadTiendasActivas);
    on<LoadTiendasByCiudad>(_onLoadTiendasByCiudad);
    on<LoadTiendasByDepartamento>(_onLoadTiendasByDepartamento);
    on<LoadTiendaById>(_onLoadTiendaById);
    on<LoadTiendaByCodigo>(_onLoadTiendaByCodigo);
    on<CreateTienda>(_onCreateTienda);
    on<UpdateTienda>(_onUpdateTienda);
    on<DeleteTienda>(_onDeleteTienda);
    on<ToggleTiendaActivo>(_onToggleTiendaActivo);
    on<SearchTiendas>(_onSearchTiendas);
    on<ClearTiendaSearch>(_onClearTiendaSearch);
    on<RefreshTiendas>(_onRefreshTiendas);
  }

  Future<void> _onLoadTiendas(
    LoadTiendas event,
    Emitter<TiendaState> emit,
  ) async {
    emit(const TiendaLoading());
    final result = await getTiendasUsecase();
    result.fold(
      (failure) {
        emit(TiendaError(message: failure.message));
      },
      (tiendas) {
        emit(TiendaLoaded(tiendas: tiendas));
      },
    );
  }

  Future<void> _onLoadTiendasActivas(
    LoadTiendasActivas event,
    Emitter<TiendaState> emit,
  ) async {
    emit(const TiendaLoading());
    final result = await getTiendasActivasUsecase();
    result.fold(
      (failure) {
        emit(TiendaError(message: failure.message));
      },
      (tiendas) {
        emit(TiendaLoaded(tiendas: tiendas));
      },
    );
  }

  Future<void> _onLoadTiendasByCiudad(
    LoadTiendasByCiudad event,
    Emitter<TiendaState> emit,
  ) async {
    emit(const TiendaLoading());
    final result = await getTiendasByCiudadUsecase(event.ciudad);
    result.fold(
      (failure) {
        emit(TiendaError(message: failure.message));
      },
      (tiendas) {
        emit(TiendaLoaded(tiendas: tiendas));
      },
    );
  }

  Future<void> _onLoadTiendasByDepartamento(
    LoadTiendasByDepartamento event,
    Emitter<TiendaState> emit,
  ) async {
    emit(const TiendaLoading());
    final result = await getTiendasByDepartamentoUsecase(event.departamento);
    result.fold(
      (failure) {
        emit(TiendaError(message: failure.message));
      },
      (tiendas) {
        emit(TiendaLoaded(tiendas: tiendas));
      },
    );
  }

  Future<void> _onLoadTiendaById(
    LoadTiendaById event,
    Emitter<TiendaState> emit,
  ) async {
    emit(const TiendaLoading());
    final result = await getTiendaByIdUsecase(event.id);
    result.fold(
      (failure) {
        emit(TiendaError(message: failure.message));
      },
      (tienda) {
        emit(TiendaLoaded(tiendas: [tienda]));
      },
    );
  }

  Future<void> _onLoadTiendaByCodigo(
    LoadTiendaByCodigo event,
    Emitter<TiendaState> emit,
  ) async {
    emit(const TiendaLoading());
    final result = await getTiendaByCodigoUsecase(event.codigo);
    result.fold(
      (failure) {
        emit(TiendaError(message: failure.message));
      },
      (tienda) {
        emit(TiendaLoaded(tiendas: [tienda]));
      },
    );
  }

  Future<void> _onCreateTienda(
    CreateTienda event,
    Emitter<TiendaState> emit,
  ) async {
    emit(const TiendaLoading());
    final result = await createTiendaUsecase(event.tiendaData);
    result.fold(
      (failure) {
        emit(TiendaOperationFailure(message: failure.message));
      },
      (tienda) {
        emit(TiendaOperationSuccess(message: 'Tienda creada exitosamente'));
      },
    );
  }

  Future<void> _onUpdateTienda(
    UpdateTienda event,
    Emitter<TiendaState> emit,
  ) async {
    emit(const TiendaLoading());
    final result = await updateTiendaUsecase(event.tiendaData);
    result.fold(
      (failure) {
        emit(TiendaOperationFailure(message: failure.message));
      },
      (tienda) {
        emit(TiendaOperationSuccess(message: 'Tienda actualizada exitosamente'));
      },
    );
  }

  Future<void> _onDeleteTienda(
    DeleteTienda event,
    Emitter<TiendaState> emit,
  ) async {
    emit(const TiendaLoading());
    final result = await deleteTiendaUsecase(event.id);
    result.fold(
      (failure) {
        emit(TiendaOperationFailure(message: failure.message));
      },
      (_) {
        emit(TiendaOperationSuccess(message: 'Tienda eliminada exitosamente'));
      },
    );
  }

  Future<void> _onToggleTiendaActivo(
    ToggleTiendaActivo event,
    Emitter<TiendaState> emit,
  ) async {
    emit(const TiendaLoading());
    final result = await toggleTiendaActivaUsecase(event.id);
    result.fold(
      (failure) {
        emit(TiendaOperationFailure(message: failure.message));
      },
      (_) {
        emit(TiendaOperationSuccess(message: 'Estado de tienda actualizado'));
      },
    );
  }

  Future<void> _onSearchTiendas(
    SearchTiendas event,
    Emitter<TiendaState> emit,
  ) async {
    // Implement search logic here
    emit(const TiendaLoading());
    final result = await getTiendasUsecase();
    result.fold(
      (failure) {
        emit(TiendaError(message: failure.message));
      },
      (tiendas) {
        final filteredTiendas = tiendas
            .where((tienda) => tienda.nombre
                .toLowerCase()
                .contains(event.query.toLowerCase()))
            .toList();
        emit(TiendaLoaded(tiendas: filteredTiendas));
      },
    );
  }

  Future<void> _onClearTiendaSearch(
    ClearTiendaSearch event,
    Emitter<TiendaState> emit,
  ) async {
    emit(const TiendaLoading());
    final result = await getTiendasUsecase();
    result.fold(
      (failure) {
        emit(TiendaError(message: failure.message));
      },
      (tiendas) {
        emit(TiendaLoaded(tiendas: tiendas));
      },
    );
  }

  Future<void> _onRefreshTiendas(
    RefreshTiendas event,
    Emitter<TiendaState> emit,
  ) async {
    emit(const TiendaLoading());
    final result = await getTiendasUsecase();
    result.fold(
      (failure) {
        emit(TiendaError(message: failure.message));
      },
      (tiendas) {
        emit(TiendaLoaded(tiendas: tiendas));
      },
    );
  }
}
