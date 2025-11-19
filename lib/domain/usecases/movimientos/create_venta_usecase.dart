import 'package:flutter_management_system/domain/repositories/movimiento_repository.dart';
import 'package:flutter_management_system/domain/usecases/auth/auth_usecases.dart';

class CreateVentaUsecase {
  final MovimientoRepository movimientoRepository;
  final GetCurrentUserUsecase getCurrentUserUsecase;

  CreateVentaUsecase({
    required this.movimientoRepository,
    required this.getCurrentUserUsecase,
  });

  Future<void> call({
    required String productoId,
    required String tiendaOrigenId,
    required int cantidad,
    required double costoUnitario,
    String? loteId,
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
        final result = await movimientoRepository.createVenta(
          productoId: productoId,
          usuarioId: usuarioId,
          cantidad: cantidad,
          costoUnitario: costoUnitario,
          loteId: loteId,
          numeroFactura: numeroFactura,
          observaciones: observaciones,
          tiendaOrigenId: tiendaOrigenId,
        );
        result.fold(
          (failure) {
            throw Exception('Failed to create venta: ${failure.message}');
          },
          (movimiento) {
            // Venta created successfully
          },
        );
      },
    );
  }
}
