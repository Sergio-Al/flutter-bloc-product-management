import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/lote.dart';
import 'package:flutter_management_system/domain/repositories/lote_repository.dart';


class GetLotesVencidosUsecase {
  final LoteRepository repository;

  GetLotesVencidosUsecase(this.repository);

  Future<Either<Failure, List<Lote>>> call() {
    return repository.getLotesVencidos();
  }
}
