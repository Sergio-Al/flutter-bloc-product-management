import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/movimiento.dart';
import 'package:flutter_management_system/domain/repositories/movimiento_repository.dart';

class GetMovimientosEnTransitoUsecase {
	final MovimientoRepository movimientoRepository;

	GetMovimientosEnTransitoUsecase({required this.movimientoRepository});

	Future<Either<Failure, List<Movimiento>>> call() async {
		return movimientoRepository.getMovimientosEnTransito();
	}
}

