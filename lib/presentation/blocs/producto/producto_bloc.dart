import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_management_system/domain/usecases/productos/create_producto_usecase.dart';
import 'package:flutter_management_system/domain/usecases/productos/delete_producto_usecase.dart';
import 'package:flutter_management_system/domain/usecases/productos/get_producto_by_codigo_usecase.dart';
import 'package:flutter_management_system/domain/usecases/productos/get_producto_by_id_usecase.dart';
import 'package:flutter_management_system/domain/usecases/productos/get_productos_activos_usecase.dart';
import 'package:flutter_management_system/domain/usecases/productos/get_productos_usecase.dart';
import 'package:flutter_management_system/domain/usecases/productos/update_producto_usecase.dart';
import 'package:flutter_management_system/presentation/blocs/producto/producto_event.dart';
import 'package:flutter_management_system/presentation/blocs/producto/producto_state.dart';

class ProductoBloc extends Bloc<ProductoEvent, ProductoState> {
  final GetProductosUsecase getProductosUsecase;
  final GetProductoByCodigoUsecase getProductoByCodigoUsecase;
  final GetProductosActivosUseCase getProductosActivosUseCase;
  final GetProductoByIdUsecase getProductoByIdUsecase;
  final CreateProductoUsecase createProductoUsecase;
  final UpdateProductoUseCase updateProductoUsecase;
  final DeleteProductoUsecase deleteProductoUsecase;

  ProductoBloc({
    required this.getProductosUsecase,
    required this.getProductoByCodigoUsecase,
    required this.getProductosActivosUseCase,
    required this.createProductoUsecase,
    required this.updateProductoUsecase,
    required this.deleteProductoUsecase,
    required this.getProductoByIdUsecase,
  }) : super(const ProductoInitial()) {
    on<LoadProductos>(_onLoadProductos);
    on<LoadProductoByCodigo>(_onLoadProductoByCodigo);
    on<LoadProductosActivos>(_onLoadProductosActivos);
    on<LoadProductosAlmacenamientoEspecial>(
      _onLoadProductosAlmacenamientoEspecial,
    );
    on<LoadProductosPeligrosos>(_onLoadProductosPeligrosos);
    on<LoadProductosStockBajo>(_onLoadProductosStockBajo);
    on<LoadProductoById>(_onLoadProductoById);
    on<LoadProductosByCategoria>(_onLoadProductosByCategoria);
    on<LoadProductosByProveedor>(_onLoadProductosByProveedor);
    on<CreateProducto>(_onCreateProducto);
    on<UpdateProducto>(_onUpdateProducto);
    on<DeleteProducto>(_onDeleteProducto);
    on<ToggleProductoActivo>(_onToggleProductoActivo);
    on<SearchProductos>(_onSearchProductos);
    on<ClearProductoSearch>(_onClearProductoSearch);
    on<FilterProductos>(_onFilterProductos);
    on<ClearProductoFilters>(_onClearProductoFilters);
    on<RefreshProductos>(_onRefreshProductos);
    on<SyncProductos>(_onSyncProductos);
    on<CheckProductoConnection>(_onCheckProductoConnection);
    on<CancelProductoSync>(_onCancelProductoSync);
    on<PauseProductoSync>(_onPauseProductoSync);
    on<ResumeProductoSync>(_onResumeProductoSync);
    on<ResolveProductoConflictLocal>(_onResolveProductoConflictLocal);
    on<ResolveProductoConflictRemote>(_onResolveProductoConflictRemote);
    on<ResolveProductoConflictMerge>(_onResolveProductoConflictMerge);
    on<ClearProductoCache>(_onClearProductoCache);
    on<ResetProductoState>(_onResetProductoState);
  }

  Future<void> _onLoadProductos(
    LoadProductos event,
    Emitter<ProductoState> emit,
  ) async {
    emit(const ProductoLoading());
    final result = await getProductosUsecase(limit: 100);
    result.fold(
      (failure) => emit(ProductoError(message: failure.message)),
      (productos) => emit(ProductoLoaded(productos: productos)),
    );
  }

  Future<void> _onLoadProductoByCodigo(
    LoadProductoByCodigo event,
    Emitter<ProductoState> emit,
  ) async {
    emit(const ProductoLoading());
    final result = await getProductoByCodigoUsecase(event.codigo);
    result.fold(
      (failure) => emit(ProductoError(message: failure.message)),
      (producto) => emit(ProductoDetailLoaded(producto: producto)),
    );
  }

  FutureOr<void> _onLoadProductosActivos(
    LoadProductosActivos event,
    Emitter<ProductoState> emit,
  ) async {
    emit(const ProductoLoading());
    final result = await getProductosActivosUseCase();
    result.fold(
      (failure) => emit(ProductoError(message: failure.message)),
      (productos) => emit(ProductoLoaded(productos: productos)),
    );
  }

  FutureOr<void> _onLoadProductosAlmacenamientoEspecial(
    LoadProductosAlmacenamientoEspecial event,
    Emitter<ProductoState> emit,
  ) {}

  FutureOr<void> _onLoadProductosByCategoria(
    LoadProductosByCategoria event,
    Emitter<ProductoState> emit,
  ) {}

  FutureOr<void> _onLoadProductosPeligrosos(
    LoadProductosPeligrosos event,
    Emitter<ProductoState> emit,
  ) {}

  FutureOr<void> _onLoadProductosStockBajo(
    LoadProductosStockBajo event,
    Emitter<ProductoState> emit,
  ) {}

  FutureOr<void> _onLoadProductoById(
    LoadProductoById event,
    Emitter<ProductoState> emit,
  ) async {
    emit(const ProductoLoading());
    final result = await getProductoByIdUsecase(event.id);
    result.fold((failure) => emit(ProductoError(message: failure.message)), (
      producto,
    ) {
      emit(ProductoDetailLoaded(producto: producto));
    });
  }

  FutureOr<void> _onLoadProductosByProveedor(
    LoadProductosByProveedor event,
    Emitter<ProductoState> emit,
  ) {}

  FutureOr<void> _onCreateProducto(
    CreateProducto event,
    Emitter<ProductoState> emit,
  ) async {
    emit(const ProductoLoading());
    final result = await createProductoUsecase(event.producto);
    result.fold(
      (failure) => emit(ProductoError(message: failure.message)),
      (producto) => emit(ProductoCreated(producto: producto)),
    );
  }

  FutureOr<void> _onUpdateProducto(
    UpdateProducto event,
    Emitter<ProductoState> emit,
  ) async {
    emit(const ProductoLoading());
    final result = await updateProductoUsecase(event.producto);
    result.fold(
      (failure) => emit(ProductoError(message: failure.message)),
      (producto) => emit(ProductoUpdated(producto: producto)),
    );
  }

  FutureOr<void> _onDeleteProducto(
    DeleteProducto event,
    Emitter<ProductoState> emit,
  ) async {
    emit(const ProductoLoading());
    final result = await deleteProductoUsecase(event.id);
    result.fold(
      (failure) => emit(ProductoError(message: failure.message)),
      (_) => emit(const ProductoInitial()),
    );
  }

  FutureOr<void> _onToggleProductoActivo(
    ToggleProductoActivo event,
    Emitter<ProductoState> emit,
  ) {}

  FutureOr<void> _onSearchProductos(
    SearchProductos event,
    Emitter<ProductoState> emit,
  ) {}

  FutureOr<void> _onClearProductoSearch(
    ClearProductoSearch event,
    Emitter<ProductoState> emit,
  ) {}

  FutureOr<void> _onFilterProductos(
    FilterProductos event,
    Emitter<ProductoState> emit,
  ) {}

  FutureOr<void> _onClearProductoFilters(
    ClearProductoFilters event,
    Emitter<ProductoState> emit,
  ) {}

  FutureOr<void> _onRefreshProductos(
    RefreshProductos event,
    Emitter<ProductoState> emit,
  ) {}

  FutureOr<void> _onSyncProductos(
    SyncProductos event,
    Emitter<ProductoState> emit,
  ) {}

  FutureOr<void> _onCheckProductoConnection(
    CheckProductoConnection event,
    Emitter<ProductoState> emit,
  ) {}

  FutureOr<void> _onCancelProductoSync(
    CancelProductoSync event,
    Emitter<ProductoState> emit,
  ) {}

  FutureOr<void> _onPauseProductoSync(
    PauseProductoSync event,
    Emitter<ProductoState> emit,
  ) {}

  FutureOr<void> _onResumeProductoSync(
    ResumeProductoSync event,
    Emitter<ProductoState> emit,
  ) {}

  FutureOr<void> _onResolveProductoConflictLocal(
    ResolveProductoConflictLocal event,
    Emitter<ProductoState> emit,
  ) {}

  FutureOr<void> _onResolveProductoConflictRemote(
    ResolveProductoConflictRemote event,
    Emitter<ProductoState> emit,
  ) {}

  FutureOr<void> _onResolveProductoConflictMerge(
    ResolveProductoConflictMerge event,
    Emitter<ProductoState> emit,
  ) {}

  FutureOr<void> _onClearProductoCache(
    ClearProductoCache event,
    Emitter<ProductoState> emit,
  ) {}

  FutureOr<void> _onResetProductoState(
    ResetProductoState event,
    Emitter<ProductoState> emit,
  ) {
    emit(const ProductoInitial());
  }
}
