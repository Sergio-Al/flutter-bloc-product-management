import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_management_system/core/utils/logger.dart';
import 'package:flutter_management_system/domain/usecases/almacenes/create_almacen_usecase.dart';
import 'package:flutter_management_system/domain/usecases/almacenes/delete_almacen_usecase.dart';
import 'package:flutter_management_system/domain/usecases/almacenes/get_almacen_by_codigo_usecase.dart';
import 'package:flutter_management_system/domain/usecases/almacenes/get_almacen_by_id.dart';
import 'package:flutter_management_system/domain/usecases/almacenes/get_almacen_principal_usecase.dart';
import 'package:flutter_management_system/domain/usecases/almacenes/get_almacenes_activos_usecase.dart';
import 'package:flutter_management_system/domain/usecases/almacenes/get_almacenes_by_tienda_usecase.dart';
import 'package:flutter_management_system/domain/usecases/almacenes/get_almacenes_by_tipo_usecase.dart';
import 'package:flutter_management_system/domain/usecases/almacenes/get_almacenes_usecase.dart';
import 'package:flutter_management_system/domain/usecases/almacenes/search_almacenes_usecase.dart';
import 'package:flutter_management_system/domain/usecases/almacenes/toggle_almacen_activo_usecase.dart';
import 'package:flutter_management_system/domain/usecases/almacenes/update_almacen_usecase.dart';
import 'package:flutter_management_system/presentation/blocs/almacen/almacen_event.dart';
import 'package:flutter_management_system/presentation/blocs/almacen/almacen_state.dart';

class AlmacenBloc extends Bloc<AlmacenEvent, AlmacenState> {
  final GetAlmacenesUseCase getAlmacenesUsecase;
  final GetAlmacenesActivosUsecase getAlmacenesActivosUsecase;
  final GetAlmacenesByTiendaUsecase getAlmacenesByTiendaUsecase;
  final GetAlmacenesByTipoUsecase getAlmacenesByTipoUsecase;
  final GetAlmacenByIdUseCase getAlmacenByIdUsecase;
  final GetAlmacenByCodigoUsecase getAlmacenByCodigoUsecase;
  final GetAlmacenPrincipalUsecase getAlmacenPrincipalUsecase;
  final CreateAlmacenUsecase createAlmacenUsecase;
  final UpdateAlmacenUsecase updateAlmacenUsecase;
  final DeleteAlmacenUsecase deleteAlmacenUsecase;
  final ToggleAlmacenActivoUsecase toggleAlmacenActivoUsecase;
  final SearchAlmacenesUsecase searchAlmacenesUsecase;

  AlmacenBloc({
    required this.getAlmacenesUsecase,
    required this.getAlmacenesActivosUsecase,
    required this.getAlmacenesByTiendaUsecase,
    required this.getAlmacenesByTipoUsecase,
    required this.getAlmacenByIdUsecase,
    required this.getAlmacenByCodigoUsecase,
    required this.getAlmacenPrincipalUsecase,
    required this.createAlmacenUsecase,
    required this.updateAlmacenUsecase,
    required this.deleteAlmacenUsecase,
    required this.toggleAlmacenActivoUsecase,
    required this.searchAlmacenesUsecase,
  }) : super(const AlmacenInitial()) {
    on<LoadAlmacenes>(_onLoadAlmacenes);
    on<LoadAlmacenesActivos>(_onLoadAlmacenesActivos);
    on<LoadAlmacenesByTienda>(_onLoadAlmacenesByTienda);
    on<LoadAlmacenesByTipo>(_onLoadAlmacenesByTipo);
    on<LoadAlmacenById>(_onLoadAlmacenById);
    on<LoadAlmacenByCodigo>(_onLoadAlmacenByCodigo);
    on<LoadAlmacenPrincipal>(_onLoadAlmacenPrincipal);
    on<CreateAlmacen>(_onCreateAlmacen);
    on<UpdateAlmacen>(_onUpdateAlmacen);
    on<DeleteAlmacen>(_onDeleteAlmacen);
    on<ToggleAlmacenActivo>(_onToggleAlmacenActivo);
    on<SearchAlmacenes>(_onSearchAlmacenes);
    on<ClearAlmacenSearch>(_onClearAlmacenSearch);
    on<RefreshAlmacenes>(_onRefreshAlmacenes);
    on<ResetAlmacenState>(_onResetAlmacenState);
  }

  Future<void> _onLoadAlmacenes(
    LoadAlmacenes event,
    Emitter<AlmacenState> emit,
  ) async {
    emit(const AlmacenLoading());
    final result = await getAlmacenesUsecase();
    result.fold(
      (failure) => emit(AlmacenError(message: failure.message)),
      (almacenes) {
        if (almacenes.isEmpty) {
          emit(const AlmacenEmpty());
        } else {
          emit(AlmacenLoaded(almacenes: almacenes));
        }
      },
    );
  }

  Future<void> _onLoadAlmacenesActivos(
    LoadAlmacenesActivos event,
    Emitter<AlmacenState> emit,
  ) async {
    emit(const AlmacenLoading());
    final result = await getAlmacenesActivosUsecase();
    result.fold(
      (failure) => emit(AlmacenError(message: failure.message)),
      (almacenes) {
        if (almacenes.isEmpty) {
          emit(const AlmacenEmpty());
        } else {
          emit(AlmacenLoaded(almacenes: almacenes));
        }
      },
    );
  }

  Future<void> _onLoadAlmacenesByTienda(
    LoadAlmacenesByTienda event,
    Emitter<AlmacenState> emit,
  ) async {
    emit(const AlmacenLoading());
    final result = await getAlmacenesByTiendaUsecase(event.tiendaId);
    result.fold(
      (failure) => emit(AlmacenError(message: failure.message)),
      (almacenes) {
        if (almacenes.isEmpty) {
          emit(const AlmacenEmpty());
        } else {
          emit(AlmacenLoaded(almacenes: almacenes));
        }
      },
    );
  }

  Future<void> _onLoadAlmacenesByTipo(
    LoadAlmacenesByTipo event,
    Emitter<AlmacenState> emit,
  ) async {
    emit(const AlmacenLoading());
    final result = await getAlmacenesByTipoUsecase(event.tipo);
    result.fold(
      (failure) => emit(AlmacenError(message: failure.message)),
      (almacenes) {
        if (almacenes.isEmpty) {
          emit(const AlmacenEmpty());
        } else {
          emit(AlmacenLoaded(almacenes: almacenes));
        }
      },
    );
  }

  Future<void> _onLoadAlmacenById(
    LoadAlmacenById event,
    Emitter<AlmacenState> emit,
  ) async {
    emit(const AlmacenLoading());
    final result = await getAlmacenByIdUsecase(event.id);
    result.fold(
      (failure) => emit(AlmacenError(message: failure.message)),
      (almacen) => emit(AlmacenDetailLoaded(almacen: almacen)),
    );
  }

  Future<void> _onLoadAlmacenByCodigo(
    LoadAlmacenByCodigo event,
    Emitter<AlmacenState> emit,
  ) async {
    emit(const AlmacenLoading());
    final result = await getAlmacenByCodigoUsecase(event.codigo);
    result.fold(
      (failure) => emit(AlmacenError(message: failure.message)),
      (almacen) => emit(AlmacenDetailLoaded(almacen: almacen)),
    );
  }

  Future<void> _onLoadAlmacenPrincipal(
    LoadAlmacenPrincipal event,
    Emitter<AlmacenState> emit,
  ) async {
    emit(const AlmacenLoading());
    final result = await getAlmacenPrincipalUsecase(event.tiendaId);
    result.fold(
      (failure) => emit(AlmacenError(message: failure.message)),
      (almacen) => emit(AlmacenDetailLoaded(almacen: almacen)),
    );
  }

  Future<void> _onCreateAlmacen(
    CreateAlmacen event,
    Emitter<AlmacenState> emit,
  ) async {
    emit(const AlmacenCreating());
    AppLogger.info('Creating almacen: ${event.almacen.nombre}');
    
    final result = await createAlmacenUsecase(event.almacen);
    result.fold(
      (failure) {
        AppLogger.error('Failed to create almacen: ${failure.message}');
        emit(AlmacenOperationFailure(message: failure.message));
      },
      (almacen) {
        AppLogger.info('Almacen created successfully: ${almacen.id}');
        emit(const AlmacenOperationSuccess(message: 'Almacén creado exitosamente'));
      },
    );
  }

  Future<void> _onUpdateAlmacen(
    UpdateAlmacen event,
    Emitter<AlmacenState> emit,
  ) async {
    emit(const AlmacenUpdating());
    AppLogger.info('Updating almacen: ${event.almacen.id}');
    
    final result = await updateAlmacenUsecase(event.almacen);
    result.fold(
      (failure) {
        AppLogger.error('Failed to update almacen: ${failure.message}');
        emit(AlmacenOperationFailure(message: failure.message));
      },
      (almacen) {
        AppLogger.info('Almacen updated successfully: ${almacen.id}');
        emit(const AlmacenOperationSuccess(message: 'Almacén actualizado exitosamente'));
      },
    );
  }

  Future<void> _onDeleteAlmacen(
    DeleteAlmacen event,
    Emitter<AlmacenState> emit,
  ) async {
    emit(const AlmacenDeleting());
    AppLogger.info('Deleting almacen: ${event.id}');
    
    final result = await deleteAlmacenUsecase(event.id);
    result.fold(
      (failure) {
        AppLogger.error('Failed to delete almacen: ${failure.message}');
        emit(AlmacenOperationFailure(message: failure.message));
      },
      (_) {
        AppLogger.info('Almacen deleted successfully: ${event.id}');
        emit(const AlmacenOperationSuccess(message: 'Almacén eliminado exitosamente'));
      },
    );
  }

  Future<void> _onToggleAlmacenActivo(
    ToggleAlmacenActivo event,
    Emitter<AlmacenState> emit,
  ) async {
    emit(const AlmacenUpdating());
    final result = await toggleAlmacenActivoUsecase(event.id);
    result.fold(
      (failure) => emit(AlmacenOperationFailure(message: failure.message)),
      (almacen) {
        final message = almacen.activo
            ? 'Almacén activado exitosamente'
            : 'Almacén desactivado exitosamente';
        emit(AlmacenOperationSuccess(message: message));
      },
    );
  }

  Future<void> _onSearchAlmacenes(
    SearchAlmacenes event,
    Emitter<AlmacenState> emit,
  ) async {
    emit(const AlmacenLoading());
    final result = await searchAlmacenesUsecase(event.query);
    result.fold(
      (failure) => emit(AlmacenError(message: failure.message)),
      (almacenes) {
        if (almacenes.isEmpty) {
          emit(const AlmacenEmpty());
        } else {
          emit(AlmacenLoaded(almacenes: almacenes));
        }
      },
    );
  }

  Future<void> _onClearAlmacenSearch(
    ClearAlmacenSearch event,
    Emitter<AlmacenState> emit,
  ) async {
    emit(const AlmacenLoading());
    final result = await getAlmacenesActivosUsecase();
    result.fold(
      (failure) => emit(AlmacenError(message: failure.message)),
      (almacenes) => emit(AlmacenLoaded(almacenes: almacenes)),
    );
  }

  Future<void> _onRefreshAlmacenes(
    RefreshAlmacenes event,
    Emitter<AlmacenState> emit,
  ) async {
    // Don't show loading, just refresh in background
    final result = await getAlmacenesActivosUsecase();
    result.fold(
      (failure) => emit(AlmacenError(message: failure.message)),
      (almacenes) => emit(AlmacenLoaded(almacenes: almacenes)),
    );
  }

  Future<void> _onResetAlmacenState(
    ResetAlmacenState event,
    Emitter<AlmacenState> emit,
  ) async {
    emit(const AlmacenInitial());
  }
}
