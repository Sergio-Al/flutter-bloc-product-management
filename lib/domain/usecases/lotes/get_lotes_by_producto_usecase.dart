import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/lote.dart';
import 'package:flutter_management_system/domain/repositories/lote_repository.dart';

class GetLotesByProductoUsecase {
  final LoteRepository loteRepository;

  GetLotesByProductoUsecase(this.loteRepository);

  Future<Either<Failure, List<Lote>>> call(String productoId) {
    return loteRepository.getLotesByProducto(productoId);
  }
}
