import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/lote.dart';
import 'package:flutter_management_system/domain/repositories/lote_repository.dart';


class SearchLotesUsecase {
  final LoteRepository repository;

  SearchLotesUsecase(this.repository);

  Future<Either<Failure, List<Lote>>> call(String query) {
    return repository.searchLotes(query);
  }
}
