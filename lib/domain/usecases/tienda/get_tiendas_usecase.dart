import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/tienda.dart';
import 'package:flutter_management_system/domain/repositories/tienda_repository.dart';

class GetTiendasUsecase {
  final TiendaRepository tiendaRepository;

  GetTiendasUsecase({required this.tiendaRepository});

  Future<Either<Failure, List<Tienda>>> call() {
    return tiendaRepository.getTiendas();
  }
}
