import 'package:flutter_management_system/domain/repositories/movimiento_repository.dart';
import 'package:flutter_management_system/domain/usecases/auth/auth_usecases.dart';

class CreateDevolucionUsecase {
  final MovimientoRepository movimientoRepository;
  final GetCurrentUserUsecase getCurrentUserUsecase;

  CreateDevolucionUsecase({
    required this.movimientoRepository,
    required this.getCurrentUserUsecase,
  });

  Future<void> call({
    required String productoId,
    required String tiendaOrigenId,
    required int cantidad,
    required double costoUnitario,
    required String tiendaId,
    required String motivo,
    String? numeroFactura,
    String? observaciones,
  }) async {
    final currentUserResult = await getCurrentUserUsecase();
    currentUserResult.fold(
      (failure) {
        throw Exception('No authenticated user found');
      },
      (user) async {
        final usuarioId = user.id;
        final result = await movimientoRepository.createDevolucion(
          productoId: productoId,
          usuarioId: usuarioId,
          cantidad: cantidad,
          numeroFactura: numeroFactura,
          observaciones: observaciones,
          tiendaId: tiendaId,
          motivo: motivo,
        );
        result.fold(
          (failure) {
            throw Exception('Failed to create devolucion: ${failure.message}');
          },
          (movimiento) {
            // Devolucion created successfully
          },
        );
      },
    );
  }
}
