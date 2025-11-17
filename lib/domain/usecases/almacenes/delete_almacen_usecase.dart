import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/repositories/almacen_repository.dart';

class DeleteAlmacenUsecase {
  final AlmacenRepository almacenRepository;

  DeleteAlmacenUsecase(this.almacenRepository);

  Future<Either<Failure, Unit>> call(String id) {
    return almacenRepository.deleteAlmacen(id);
  }
}
