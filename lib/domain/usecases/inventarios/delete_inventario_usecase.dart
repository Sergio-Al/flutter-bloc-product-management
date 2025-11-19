import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/repositories/inventario_repository.dart';

class DeleteInventarioUsecase {
  final InventarioRepository repository;

  DeleteInventarioUsecase(this.repository);

  Future<Either<Failure, Unit>> call(String inventarioId) {
    return repository.deleteInventario(inventarioId);
  }
}
