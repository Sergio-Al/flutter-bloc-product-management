import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/producto.dart';
import 'package:flutter_management_system/domain/repositories/producto_repository.dart';

class GetProductosActivosUseCase {
  final ProductoRepository repository;

  GetProductosActivosUseCase({required this.repository});

  Future<Either<Failure, List<Producto>>> call() {
    return repository.getProductosActivos();
  }
}
