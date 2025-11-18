import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/repositories/tienda_repository.dart';

class DeleteTiendaUsecase {
  final TiendaRepository tiendaRepository;

  DeleteTiendaUsecase({required this.tiendaRepository});

  Future<Either<Failure, void>> call(String tiendaId) {
    return tiendaRepository.deleteTienda(tiendaId);
  }
}
