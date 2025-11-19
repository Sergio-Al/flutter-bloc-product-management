import 'package:flutter_management_system/domain/repositories/movimiento_repository.dart';
import 'package:flutter_management_system/domain/usecases/auth/auth_usecases.dart';

class CreateTransferenciaUsecase {
  final MovimientoRepository movimientoRepository;
  final GetCurrentUserUsecase getCurrentUserUsecase;

  CreateTransferenciaUsecase({
    required this.movimientoRepository,
    required this.getCurrentUserUsecase,
  });

  Future<void> call({
    required String productoId,
    required String tiendaOrigenId,
    required String tiendaDestinoId,
    required int cantidad,
    String? loteId,
    String? vehiculoPlaca,
    String? conductor,
    String? numeroGuiaRemision,
    String? observaciones,
  }) async {
    final currentUserResult = await getCurrentUserUsecase();
    currentUserResult.fold(
      (failure) {
        throw Exception('No authenticated user found');
      },
      (user) async {
        final usuarioId = user.id;
        final result = await movimientoRepository.createTransferencia(
          productoId: productoId,
          tiendaOrigenId: tiendaOrigenId,
          tiendaDestinoId: tiendaDestinoId,
          usuarioId: usuarioId,
          cantidad: cantidad,
          observaciones: observaciones,
          loteId: loteId,
          vehiculoPlaca: vehiculoPlaca,
          conductor: conductor,
          numeroGuiaRemision: numeroGuiaRemision,
        );
        result.fold(
          (failure) {
            throw Exception(
              'Failed to create transferencia: ${failure.message}',
            );
          },
          (movimiento) {
            // Transferencia created successfully
          },
        );
      },
    );
  }
}
