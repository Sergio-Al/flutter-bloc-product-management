import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/lotes/lote_usecases.dart';
import 'lote_event.dart';
import 'lote_state.dart';

class LoteBloc extends Bloc<LoteEvent, LoteState> {
  // Usecases
  final GetLotesUsecase getLotes;
  final GetLoteByIdUsecase getLoteById;
  final GetLoteByNumeroUsecase getLoteByNumero;
  final SearchLotesUsecase searchLotes;
  final GetLotesByProductoUsecase getLotesByProducto;
  final GetLotesByProveedorUsecase getLotesByProveedor;
  final GetLotesByFacturaUsecase getLotesByFactura;
  final GetLotesConStockUsecase getLotesConStock;
  final GetLotesVaciosUsecase getLotesVacios;
  final GetLotesVencidosUsecase getLotesVencidos;
  final GetLotesPorVencerUsecase getLotesPorVencer;
  final GetLotesConCertificadoUsecase getLotesConCertificado;
  final CreateLoteUsecase createLote;
  final UpdateLoteUsecase updateLote;
  final UpdateCantidadLoteUsecase updateCantidadLote;
  final DeleteLoteUsecase deleteLote;

  LoteBloc({
    required this.getLotes,
    required this.getLoteById,
    required this.getLoteByNumero,
    required this.searchLotes,
    required this.getLotesByProducto,
    required this.getLotesByProveedor,
    required this.getLotesByFactura,
    required this.getLotesConStock,
    required this.getLotesVacios,
    required this.getLotesVencidos,
    required this.getLotesPorVencer,
    required this.getLotesConCertificado,
    required this.createLote,
    required this.updateLote,
    required this.updateCantidadLote,
    required this.deleteLote,
  }) : super(const LoteInitial()) {
    // Register event handlers
    on<LoadLotes>(_onLoadLotes);
    on<LoadLoteById>(_onLoadLoteById);
    on<LoadLoteByNumero>(_onLoadLoteByNumero);
    on<SearchLotes>(_onSearchLotes);
    on<LoadLotesByProducto>(_onLoadLotesByProducto);
    on<LoadLotesByProveedor>(_onLoadLotesByProveedor);
    on<LoadLotesByFactura>(_onLoadLotesByFactura);
    on<LoadLotesConStock>(_onLoadLotesConStock);
    on<LoadLotesVacios>(_onLoadLotesVacios);
    on<LoadLotesVencidos>(_onLoadLotesVencidos);
    on<LoadLotesPorVencer>(_onLoadLotesPorVencer);
    on<LoadLotesConCertificado>(_onLoadLotesConCertificado);
    on<CreateLote>(_onCreateLote);
    on<UpdateLote>(_onUpdateLote);
    on<UpdateCantidadLote>(_onUpdateCantidadLote);
    on<DeleteLote>(_onDeleteLote);
  }

  // ==================== Read Operations ====================

  Future<void> _onLoadLotes(
    LoadLotes event,
    Emitter<LoteState> emit,
  ) async {
    emit(const LoteLoading());
    
    final result = await getLotes();
    
    result.fold(
      (failure) => emit(LoteError(failure.message)),
      (lotes) => emit(LoteLoaded(lotes)),
    );
  }

  Future<void> _onLoadLoteById(
    LoadLoteById event,
    Emitter<LoteState> emit,
  ) async {
    emit(const LoteLoading());
    
    final result = await getLoteById(event.id);
    
    result.fold(
      (failure) => emit(LoteError(failure.message)),
      (lote) => emit(LoteLoaded([lote])),
    );
  }

  Future<void> _onLoadLoteByNumero(
    LoadLoteByNumero event,
    Emitter<LoteState> emit,
  ) async {
    emit(const LoteLoading());
    
    final result = await getLoteByNumero(event.numero);
    
    result.fold(
      (failure) => emit(LoteError(failure.message)),
      (lote) => emit(LoteLoaded([lote])),
    );
  }

  Future<void> _onSearchLotes(
    SearchLotes event,
    Emitter<LoteState> emit,
  ) async {
    emit(const LoteLoading());
    
    final result = await searchLotes(event.query);
    
    result.fold(
      (failure) => emit(LoteError(failure.message)),
      (lotes) => emit(LoteLoaded(lotes)),
    );
  }

  Future<void> _onLoadLotesByProducto(
    LoadLotesByProducto event,
    Emitter<LoteState> emit,
  ) async {
    emit(const LoteLoading());
    
    final result = await getLotesByProducto(event.productoId);
    
    result.fold(
      (failure) => emit(LoteError(failure.message)),
      (lotes) => emit(LoteLoaded(lotes)),
    );
  }

  Future<void> _onLoadLotesByProveedor(
    LoadLotesByProveedor event,
    Emitter<LoteState> emit,
  ) async {
    emit(const LoteLoading());
    
    final result = await getLotesByProveedor(event.proveedorId);
    
    result.fold(
      (failure) => emit(LoteError(failure.message)),
      (lotes) => emit(LoteLoaded(lotes)),
    );
  }

  Future<void> _onLoadLotesByFactura(
    LoadLotesByFactura event,
    Emitter<LoteState> emit,
  ) async {
    emit(const LoteLoading());
    
    final result = await getLotesByFactura(event.facturaId);
    
    result.fold(
      (failure) => emit(LoteError(failure.message)),
      (lotes) => emit(LoteLoaded(lotes)),
    );
  }

  Future<void> _onLoadLotesConStock(
    LoadLotesConStock event,
    Emitter<LoteState> emit,
  ) async {
    emit(const LoteLoading());
    
    final result = await getLotesConStock();
    
    result.fold(
      (failure) => emit(LoteError(failure.message)),
      (lotes) => emit(LoteLoaded(lotes)),
    );
  }

  Future<void> _onLoadLotesVacios(
    LoadLotesVacios event,
    Emitter<LoteState> emit,
  ) async {
    emit(const LoteLoading());
    
    final result = await getLotesVacios();
    
    result.fold(
      (failure) => emit(LoteError(failure.message)),
      (lotes) => emit(LoteLoaded(lotes)),
    );
  }

  Future<void> _onLoadLotesVencidos(
    LoadLotesVencidos event,
    Emitter<LoteState> emit,
  ) async {
    emit(const LoteLoading());
    
    final result = await getLotesVencidos();
    
    result.fold(
      (failure) => emit(LoteError(failure.message)),
      (lotes) => emit(LoteLoaded(lotes)),
    );
  }

  Future<void> _onLoadLotesPorVencer(
    LoadLotesPorVencer event,
    Emitter<LoteState> emit,
  ) async {
    emit(const LoteLoading());
    
    final result = await getLotesPorVencer();
    
    result.fold(
      (failure) => emit(LoteError(failure.message)),
      (lotes) => emit(LoteLoaded(lotes)),
    );
  }

  Future<void> _onLoadLotesConCertificado(
    LoadLotesConCertificado event,
    Emitter<LoteState> emit,
  ) async {
    emit(const LoteLoading());
    
    final result = await getLotesConCertificado();
    
    result.fold(
      (failure) => emit(LoteError(failure.message)),
      (lotes) => emit(LoteLoaded(lotes)),
    );
  }

  // ==================== Write Operations ====================

  Future<void> _onCreateLote(
    CreateLote event,
    Emitter<LoteState> emit,
  ) async {
    emit(const LoteLoading());
    
    final result = await createLote(event.lote);
    
    await result.fold(
      (failure) async => emit(LoteError(failure.message)),
      (lote) async {
        // Reload list after creation
        final listResult = await getLotes();
        listResult.fold(
          (failure) => emit(LoteError(failure.message)),
          (lotes) => emit(LoteOperationSuccess(
            message: 'Lote creado exitosamente',
            lotes: lotes,
          )),
        );
      },
    );
  }

  Future<void> _onUpdateLote(
    UpdateLote event,
    Emitter<LoteState> emit,
  ) async {
    emit(const LoteLoading());
    
    final result = await updateLote(event.lote);
    
    await result.fold(
      (failure) async => emit(LoteError(failure.message)),
      (lote) async {
        // Reload list after update
        final listResult = await getLotes();
        listResult.fold(
          (failure) => emit(LoteError(failure.message)),
          (lotes) => emit(LoteOperationSuccess(
            message: 'Lote actualizado exitosamente',
            lotes: lotes,
          )),
        );
      },
    );
  }

  Future<void> _onUpdateCantidadLote(
    UpdateCantidadLote event,
    Emitter<LoteState> emit,
  ) async {
    emit(const LoteLoading());
    
    final result = await updateCantidadLote(event.id, event.nuevaCantidad);
    
    await result.fold(
      (failure) async => emit(LoteError(failure.message)),
      (lote) async {
        // Reload list after update
        final listResult = await getLotes();
        listResult.fold(
          (failure) => emit(LoteError(failure.message)),
          (lotes) => emit(LoteOperationSuccess(
            message: 'Cantidad actualizada exitosamente',
            lotes: lotes,
          )),
        );
      },
    );
  }

  Future<void> _onDeleteLote(
    DeleteLote event,
    Emitter<LoteState> emit,
  ) async {
    emit(const LoteLoading());
    
    final result = await deleteLote(event.id);
    
    await result.fold(
      (failure) async => emit(LoteError(failure.message)),
      (_) async {
        // Reload list after deletion
        final listResult = await getLotes();
        listResult.fold(
          (failure) => emit(LoteError(failure.message)),
          (lotes) => emit(LoteOperationSuccess(
            message: 'Lote eliminado exitosamente',
            lotes: lotes,
          )),
        );
      },
    );
  }
}
