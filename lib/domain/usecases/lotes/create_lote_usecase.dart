import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/lote.dart';
import 'package:flutter_management_system/domain/repositories/lote_repository.dart';

class CreateLoteUsecase {
  final LoteRepository loteRepository;

  CreateLoteUsecase(this.loteRepository);

  Future<Either<Failure, Lote>> call(Lote lote) {
    return loteRepository.createLote(lote);
  }
}
