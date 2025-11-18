import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/tienda.dart';
import 'package:flutter_management_system/domain/repositories/tienda_repository.dart';

class ToggleTiendaActivaUsecase {
  final TiendaRepository tiendaRepository;

  ToggleTiendaActivaUsecase({required this.tiendaRepository});

  Future<Either<Failure, Tienda>> call(String tiendaId) {
    return tiendaRepository.toggleTiendaActiva(tiendaId);
  }
}
