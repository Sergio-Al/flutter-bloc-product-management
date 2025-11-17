import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/almacen.dart';
import 'package:flutter_management_system/domain/repositories/almacen_repository.dart';

class GetAlmacenByCodigoUsecase {
  final AlmacenRepository almacenRepository;

  GetAlmacenByCodigoUsecase(this.almacenRepository);

  Future<Either<Failure, Almacen>> call(String codigo) {
    return almacenRepository.getAlmacenByCodigo(codigo);
  }
}
