import 'package:flutter_management_system/domain/repositories/movimiento_repository.dart';
import 'package:flutter_management_system/domain/usecases/auth/auth_usecases.dart';

class CreateCompraUsecase {
  final MovimientoRepository movimientoRepository;
  final GetCurrentUserUsecase getCurrentUserUsecase;

  CreateCompraUsecase({
    required this.movimientoRepository,
    required this.getCurrentUserUsecase,
  });

  Future<void> call({
    required String productoId,
    required String tiendaDestinoId,
    required int cantidad,
    required double costoUnitario,
    required String proveedorId,
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
        final result = await movimientoRepository.createCompra(
          productoId: productoId,
          tiendaDestinoId: tiendaDestinoId,
          usuarioId: usuarioId,
          cantidad: cantidad,
          costoUnitario: costoUnitario,
          numeroFactura: numeroFactura,
          loteId: loteId,
          observaciones: observaciones,
          proveedorId: proveedorId,
        );
        result.fold(
          (failure) {
            throw Exception('Failed to create compra: ${failure.message}');
          },
          (movimiento) {
            // Compra created successfully
          },
        );
      },
    );
  }
}
