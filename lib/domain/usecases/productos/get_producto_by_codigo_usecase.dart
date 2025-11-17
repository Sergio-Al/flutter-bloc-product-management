import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/producto.dart';
import 'package:flutter_management_system/domain/repositories/producto_repository.dart';

class GetProductoByCodigoUsecase {
  final ProductoRepository productoRepository;

  GetProductoByCodigoUsecase(this.productoRepository);

  Future<Either<Failure, Producto>> call(String codigo) {
    return productoRepository.getProductoByCodigo(codigo);
  }
}
