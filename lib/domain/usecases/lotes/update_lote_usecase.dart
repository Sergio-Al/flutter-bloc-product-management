import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/lote.dart';
import 'package:flutter_management_system/domain/repositories/lote_repository.dart';


class UpdateLoteUsecase {
  final LoteRepository repository;

  UpdateLoteUsecase(this.repository);

  Future<Either<Failure, Lote>> call(Lote lote) {
    return repository.updateLote(lote);
  }
}
