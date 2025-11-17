import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/almacen.dart';
import 'package:flutter_management_system/domain/repositories/almacen_repository.dart';

class GetAlmacenesByTipoUsecase {
  final AlmacenRepository almacenRepository;

  GetAlmacenesByTipoUsecase(this.almacenRepository);

  Future<Either<Failure, List<Almacen>>> call(String tipo) {
    return almacenRepository.getAlmacenesByTipo(tipo);
  }
}
