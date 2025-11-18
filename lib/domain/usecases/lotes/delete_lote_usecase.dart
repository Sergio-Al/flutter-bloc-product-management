import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/lote.dart';
import 'package:flutter_management_system/domain/repositories/lote_repository.dart';

class DeleteLoteUsecase {
  final LoteRepository repository;

  DeleteLoteUsecase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteLote(id);
  }
}
