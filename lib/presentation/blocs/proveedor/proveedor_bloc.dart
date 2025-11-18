import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/proveedores/proveedores_usecases.dart';
import 'proveedor_event.dart';
import 'proveedor_state.dart';

class ProveedorBloc extends Bloc<ProveedorEvent, ProveedorState> {
  // Usecases
  final GetProveedoresUsecase getProveedores;
  final GetProveedoresActivosUsecase getProveedoresActivos;
  final GetProveedorByIdUsecase getProveedorById;
  final GetProveedorByNitUsecase getProveedorByNit;
  final SearchProveedoresUsecase searchProveedores;
  final GetProveedoresByCiudadUsecase getProveedoresByCiudad;
  final GetProveedoresByTipoMaterialUsecase getProveedoresByTipoMaterial;
  final GetProveedoresConCreditoUsecase getProveedoresConCredito;
  final CreateProveedorUsecase createProveedor;
  final UpdateProveedorUsecase updateProveedor;
  final DeleteProveedorUsecase deleteProveedor;
  final ToggleProveedorActivoUsecase toggleProveedorActivo;

  ProveedorBloc({
    required this.getProveedores,
    required this.getProveedoresActivos,
    required this.getProveedorById,
    required this.getProveedorByNit,
    required this.searchProveedores,
    required this.getProveedoresByCiudad,
    required this.getProveedoresByTipoMaterial,
    required this.getProveedoresConCredito,
    required this.createProveedor,
    required this.updateProveedor,
    required this.deleteProveedor,
    required this.toggleProveedorActivo,
  }) : super(const ProveedorInitial()) {
    // Register event handlers
    on<LoadProveedores>(_onLoadProveedores);
    on<LoadProveedoresActivos>(_onLoadProveedoresActivos);
    on<LoadProveedorById>(_onLoadProveedorById);
    on<SearchProveedores>(_onSearchProveedores);
    on<LoadProveedoresByCiudad>(_onLoadProveedoresByCiudad);
    on<LoadProveedoresByTipoMaterial>(_onLoadProveedoresByTipoMaterial);
    on<LoadProveedoresConCredito>(_onLoadProveedoresConCredito);
    on<CreateProveedor>(_onCreateProveedor);
    on<UpdateProveedor>(_onUpdateProveedor);
    on<DeleteProveedor>(_onDeleteProveedor);
    on<ToggleProveedorActivo>(_onToggleProveedorActivo);
  }

  // ==================== Read Operations ====================

  Future<void> _onLoadProveedores(
    LoadProveedores event,
    Emitter<ProveedorState> emit,
  ) async {
    emit(const ProveedorLoading());
    
    final result = await getProveedores();
    
    result.fold(
      (failure) => emit(ProveedorError(failure.message)),
      (proveedores) => emit(ProveedorLoaded(proveedores)),
    );
  }

  Future<void> _onLoadProveedoresActivos(
    LoadProveedoresActivos event,
    Emitter<ProveedorState> emit,
  ) async {
    emit(const ProveedorLoading());
    
    final result = await getProveedoresActivos();
    
    result.fold(
      (failure) => emit(ProveedorError(failure.message)),
      (proveedores) => emit(ProveedorLoaded(proveedores)),
    );
  }

  Future<void> _onLoadProveedorById(
    LoadProveedorById event,
    Emitter<ProveedorState> emit,
  ) async {
    emit(const ProveedorLoading());
    
    final result = await getProveedorById(event.id);
    
    result.fold(
      (failure) => emit(ProveedorError(failure.message)),
      (proveedor) => emit(ProveedorLoaded([proveedor])),
    );
  }

  Future<void> _onSearchProveedores(
    SearchProveedores event,
    Emitter<ProveedorState> emit,
  ) async {
    emit(const ProveedorLoading());
    
    final result = await searchProveedores(event.query);
    
    result.fold(
      (failure) => emit(ProveedorError(failure.message)),
      (proveedores) => emit(ProveedorLoaded(proveedores)),
    );
  }

  Future<void> _onLoadProveedoresByCiudad(
    LoadProveedoresByCiudad event,
    Emitter<ProveedorState> emit,
  ) async {
    emit(const ProveedorLoading());
    
    final result = await getProveedoresByCiudad(event.ciudad);
    
    result.fold(
      (failure) => emit(ProveedorError(failure.message)),
      (proveedores) => emit(ProveedorLoaded(proveedores)),
    );
  }

  Future<void> _onLoadProveedoresByTipoMaterial(
    LoadProveedoresByTipoMaterial event,
    Emitter<ProveedorState> emit,
  ) async {
    emit(const ProveedorLoading());
    
    final result = await getProveedoresByTipoMaterial(event.tipoMaterial);
    
    result.fold(
      (failure) => emit(ProveedorError(failure.message)),
      (proveedores) => emit(ProveedorLoaded(proveedores)),
    );
  }

  Future<void> _onLoadProveedoresConCredito(
    LoadProveedoresConCredito event,
    Emitter<ProveedorState> emit,
  ) async {
    emit(const ProveedorLoading());
    
    final result = await getProveedoresConCredito();
    
    result.fold(
      (failure) => emit(ProveedorError(failure.message)),
      (proveedores) => emit(ProveedorLoaded(proveedores)),
    );
  }

  // ==================== Write Operations ====================

  Future<void> _onCreateProveedor(
    CreateProveedor event,
    Emitter<ProveedorState> emit,
  ) async {
    emit(const ProveedorLoading());
    
    final result = await createProveedor(event.proveedor);
    
    await result.fold(
      (failure) async => emit(ProveedorError(failure.message)),
      (proveedor) async {
        // Reload list after creation
        final listResult = await getProveedoresActivos();
        listResult.fold(
          (failure) => emit(ProveedorError(failure.message)),
          (proveedores) => emit(ProveedorOperationSuccess(
            message: 'Proveedor creado exitosamente',
            proveedores: proveedores,
          )),
        );
      },
    );
  }

  Future<void> _onUpdateProveedor(
    UpdateProveedor event,
    Emitter<ProveedorState> emit,
  ) async {
    emit(const ProveedorLoading());
    
    final result = await updateProveedor(event.proveedor);
    
    await result.fold(
      (failure) async => emit(ProveedorError(failure.message)),
      (proveedor) async {
        // Reload list after update
        final listResult = await getProveedoresActivos();
        listResult.fold(
          (failure) => emit(ProveedorError(failure.message)),
          (proveedores) => emit(ProveedorOperationSuccess(
            message: 'Proveedor actualizado exitosamente',
            proveedores: proveedores,
          )),
        );
      },
    );
  }

  Future<void> _onDeleteProveedor(
    DeleteProveedor event,
    Emitter<ProveedorState> emit,
  ) async {
    emit(const ProveedorLoading());
    
    final result = await deleteProveedor(event.id);
    
    await result.fold(
      (failure) async => emit(ProveedorError(failure.message)),
      (_) async {
        // Reload list after deletion
        final listResult = await getProveedoresActivos();
        listResult.fold(
          (failure) => emit(ProveedorError(failure.message)),
          (proveedores) => emit(ProveedorOperationSuccess(
            message: 'Proveedor eliminado exitosamente',
            proveedores: proveedores,
          )),
        );
      },
    );
  }

  Future<void> _onToggleProveedorActivo(
    ToggleProveedorActivo event,
    Emitter<ProveedorState> emit,
  ) async {
    emit(const ProveedorLoading());
    
    final result = await toggleProveedorActivo(event.id);
    
    await result.fold(
      (failure) async => emit(ProveedorError(failure.message)),
      (proveedor) async {
        // Reload list after toggle
        final listResult = await getProveedoresActivos();
        listResult.fold(
          (failure) => emit(ProveedorError(failure.message)),
          (proveedores) => emit(ProveedorOperationSuccess(
            message: 'Estado actualizado exitosamente',
            proveedores: proveedores,
          )),
        );
      },
    );
  }
}
