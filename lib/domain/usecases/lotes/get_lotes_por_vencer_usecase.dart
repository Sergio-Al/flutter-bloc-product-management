import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/lote.dart';
import 'package:flutter_management_system/domain/repositories/lote_repository.dart';

class GetLotesPorVencerUsecase {
  final LoteRepository repository;

  GetLotesPorVencerUsecase(this.repository);

  Future<Either<Failure, List<Lote>>> call() {
    return repository.getLotesPorVencer();
  }
}
