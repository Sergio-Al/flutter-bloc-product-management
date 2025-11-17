import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/almacen.dart';
import 'package:flutter_management_system/domain/repositories/almacen_repository.dart';

class ToggleAlmacenActivoUsecase {
  final AlmacenRepository almacenRepository;

  ToggleAlmacenActivoUsecase(this.almacenRepository);

  Future<Either<Failure, Almacen>> call(String almacenId) {
    return almacenRepository.toggleAlmacenActivo(almacenId);
  }
}
