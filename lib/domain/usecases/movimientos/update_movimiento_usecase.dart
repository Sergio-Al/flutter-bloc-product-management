import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/movimiento.dart';
import 'package:flutter_management_system/domain/repositories/movimiento_repository.dart';

class UpdateMovimientoUsecase {
	final MovimientoRepository movimientoRepository;

	UpdateMovimientoUsecase({required this.movimientoRepository});

	Future<Either<Failure, Movimiento>> call(Movimiento movimiento) async {
		return movimientoRepository.updateMovimiento(movimiento);
	}
}

