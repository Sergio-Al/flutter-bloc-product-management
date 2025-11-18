import 'package:equatable/equatable.dart';
import '../../../domain/entities/proveedor.dart';

abstract class ProveedorState extends Equatable {
  const ProveedorState();

  @override
  List<Object?> get props => [];
}

/// Initial state - no data loaded yet
class ProveedorInitial extends ProveedorState {
  const ProveedorInitial();
}

/// Loading state - fetching data
class ProveedorLoading extends ProveedorState {
  const ProveedorLoading();
}

/// Loaded state - data available
class ProveedorLoaded extends ProveedorState {
  final List<Proveedor> proveedores;
  
  const ProveedorLoaded(this.proveedores);

  @override
  List<Object?> get props => [proveedores];
}

/// Error state - something went wrong
class ProveedorError extends ProveedorState {
  final String message;
  
  const ProveedorError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Operation success - for create/update/delete feedback
/// This state is temporary and should transition back to loaded
class ProveedorOperationSuccess extends ProveedorState {
  final String message;
  final List<Proveedor> proveedores; // Updated list after operation
  
  const ProveedorOperationSuccess({
    required this.message,
    required this.proveedores,
  });

  @override
  List<Object?> get props => [message, proveedores];
}
