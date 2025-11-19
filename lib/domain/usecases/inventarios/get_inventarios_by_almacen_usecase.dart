import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/inventario.dart';
import 'package:flutter_management_system/domain/repositories/inventario_repository.dart';

class GetInventariosByAlmacenUsecase {
  final InventarioRepository repository;

  GetInventariosByAlmacenUsecase(this.repository);

  Future<Either<Failure, List<Inventario>>> call(String almacenId) {
    return repository.getInventariosByAlmacen(almacenId);
  }
}
