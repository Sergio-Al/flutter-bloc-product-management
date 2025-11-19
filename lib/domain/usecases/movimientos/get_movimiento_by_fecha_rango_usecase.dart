import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/movimiento.dart';
import 'package:flutter_management_system/domain/repositories/movimiento_repository.dart';

class GetMovimientosByFechaRangoUsecase {
	final MovimientoRepository movimientoRepository;

	GetMovimientosByFechaRangoUsecase({required this.movimientoRepository});

	Future<Either<Failure, List<Movimiento>>> call({
		required DateTime fechaInicio,
		required DateTime fechaFin,
	}) async {
		return movimientoRepository.getMovimientosByFechaRango(
			fechaInicio: fechaInicio,
			fechaFin: fechaFin,
		);
	}
}

