
import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/almacen.dart';
import 'package:flutter_management_system/domain/repositories/almacen_repository.dart';

class GetAlmacenesActivosUsecase {
  final AlmacenRepository almacenRepository;

  GetAlmacenesActivosUsecase(this.almacenRepository);

  Future<Either<Failure, List<Almacen>>> call() {
    return almacenRepository.getAlmacenesActivos();
  }
}
