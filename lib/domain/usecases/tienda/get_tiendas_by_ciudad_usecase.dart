import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/tienda.dart';
import 'package:flutter_management_system/domain/repositories/tienda_repository.dart';


class GetTiendasByCiudadUsecase {
  final TiendaRepository tiendaRepository;

  GetTiendasByCiudadUsecase({required this.tiendaRepository});

  Future<Either<Failure, List<Tienda>>> call(String ciudad) {
    return tiendaRepository.getTiendasByCiudad(ciudad);
  }
}
