import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/almacen.dart';
import 'package:flutter_management_system/domain/repositories/almacen_repository.dart';

class GetAlmacenesByTiendaUsecase {
  final AlmacenRepository almacenRepository;

  GetAlmacenesByTiendaUsecase(this.almacenRepository);

  Future<Either<Failure, List<Almacen>>> call(String tiendaId) {
    return almacenRepository.getAlmacenesByTienda(tiendaId);
  }
}
