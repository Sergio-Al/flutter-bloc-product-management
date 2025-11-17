
import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/producto.dart';
import 'package:flutter_management_system/domain/repositories/producto_repository.dart';

class GetProductoByIdUsecase {
  final ProductoRepository repository;

  GetProductoByIdUsecase(this.repository);

  Future<Either<Failure, Producto>> call(String id) {
    return repository.getProductoById(id);
  }
}
