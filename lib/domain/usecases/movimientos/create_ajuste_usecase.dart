import 'package:flutter_management_system/domain/repositories/movimiento_repository.dart';
import 'package:flutter_management_system/domain/usecases/auth/auth_usecases.dart';

class CreateAjusteUsecase {
  final MovimientoRepository movimientoRepository;
  final GetCurrentUserUsecase getCurrentUserUsecase;

  CreateAjusteUsecase({
    required this.movimientoRepository,
    required this.getCurrentUserUsecase,
  });

  Future<void> call({
    required String productoId,
    required String tiendaId,
    required int cantidad,
    required String motivo,
    String? observaciones,
  }) async {
    final currentUserResult = await getCurrentUserUsecase();
    currentUserResult.fold(
      (failure) {
        throw Exception('No authenticated user found');
      },
      (user) async {
        final usuarioId = user.id;
        final result = await movimientoRepository.createAjuste(
          productoId: productoId,
          tiendaId: tiendaId,
          usuarioId: usuarioId,
          cantidad: cantidad,
          motivo: motivo,
          observaciones: observaciones,
        );
        result.fold(
          (failure) {
            throw Exception('Failed to create ajuste: ${failure.message}');
          },
          (movimiento) {
            // Ajuste created successfully
          },
        );
      },
    );
  }
}
