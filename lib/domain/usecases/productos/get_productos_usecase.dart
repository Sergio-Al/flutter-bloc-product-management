import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/producto.dart';
import 'package:flutter_management_system/domain/repositories/producto_repository.dart';

class GetProductosUsecase {
  final ProductoRepository productoRepository;

  GetProductosUsecase(this.productoRepository);

  Future<Either<Failure, List<Producto>>> call({
    String? searchTerm,
    int? limit,
  }) {
    return productoRepository.searchProductos(searchTerm ?? '');
  }
}
