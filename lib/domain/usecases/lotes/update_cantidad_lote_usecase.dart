import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/lote.dart';
import 'package:flutter_management_system/domain/repositories/lote_repository.dart';

class UpdateCantidadLoteUsecase {
  final LoteRepository repository;

  UpdateCantidadLoteUsecase(this.repository);

  Future<Either<Failure, Lote>> call(String id, int nuevaCantidad) {
    return repository.updateCantidadLote(
      loteId: id,
      cantidadNueva: nuevaCantidad,
    );
  }
}
