import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/repositories/producto_repository.dart';

class DeleteProductoUsecase {
  final ProductoRepository repository;

  DeleteProductoUsecase({required this.repository});

  Future<Either<Failure, Unit>> call(String id) {
    return repository.deleteProducto(id);
  }
}
