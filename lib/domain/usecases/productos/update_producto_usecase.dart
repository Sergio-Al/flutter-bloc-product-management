import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/producto.dart';
import 'package:flutter_management_system/domain/repositories/producto_repository.dart';

class UpdateProductoUseCase {
  final ProductoRepository repository;

  UpdateProductoUseCase({required this.repository});

  Future<Either<Failure, Producto>> call(Producto producto) {
    return repository.updateProducto(producto);
  }
}
