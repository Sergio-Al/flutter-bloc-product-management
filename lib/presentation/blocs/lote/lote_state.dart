import 'package:equatable/equatable.dart';
import '../../../domain/entities/lote.dart';

abstract class LoteState extends Equatable {
  const LoteState();

  @override
  List<Object?> get props => [];
}

/// Initial state - no data loaded yet
class LoteInitial extends LoteState {
  const LoteInitial();
}

/// Loading state - fetching data
class LoteLoading extends LoteState {
  const LoteLoading();
}

/// Loaded state - data available
class LoteLoaded extends LoteState {
  final List<Lote> lotes;
  
  const LoteLoaded(this.lotes);

  @override
  List<Object?> get props => [lotes];
}

/// Error state - something went wrong
class LoteError extends LoteState {
  final String message;
  
  const LoteError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Operation success - for create/update/delete feedback
/// This state is temporary and should transition back to loaded
class LoteOperationSuccess extends LoteState {
  final String message;
  final List<Lote> lotes; // Updated list after operation
  
  const LoteOperationSuccess({
    required this.message,
    required this.lotes,
  });

  @override
  List<Object?> get props => [message, lotes];
}
