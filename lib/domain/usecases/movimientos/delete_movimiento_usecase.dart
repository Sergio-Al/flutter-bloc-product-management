import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/repositories/movimiento_repository.dart';

class DeleteMovimientoUsecase {
	final MovimientoRepository movimientoRepository;

	DeleteMovimientoUsecase({required this.movimientoRepository});

	Future<Either<Failure, Unit>> call(String movimientoId) async {
		return movimientoRepository.deleteMovimiento(movimientoId);
	}
}

