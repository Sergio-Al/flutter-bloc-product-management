
import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/almacen.dart';
import 'package:flutter_management_system/domain/repositories/almacen_repository.dart';

class GetAlmacenByIdUseCase {
  final AlmacenRepository almacenRepository;

  GetAlmacenByIdUseCase(this.almacenRepository);

  Future<Either<Failure, Almacen>> call(String id) {
    return almacenRepository.getAlmacenById(id);
  }
}
