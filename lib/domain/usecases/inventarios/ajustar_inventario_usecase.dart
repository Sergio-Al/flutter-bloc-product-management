import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/repositories/inventario_repository.dart';

class AjustarInventarioUsecase {
  final InventarioRepository inventarioRepository;

  AjustarInventarioUsecase(this.inventarioRepository);

  Future<Either<Failure, bool>> call(
    String inventarioId,
    int nuevaCantidad,
    String motivo,
  ) async {
    final result = await inventarioRepository.ajustarInventario(
      inventarioId: inventarioId,
      cantidadNueva: nuevaCantidad,
      motivo: motivo,
    );
    return result.fold(
      (failure) => Left(failure),
      (inventario) => const Right(true),
    );
  }
}
