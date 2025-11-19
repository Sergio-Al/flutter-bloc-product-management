import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/movimiento.dart';
import 'package:flutter_management_system/domain/repositories/movimiento_repository.dart';

class GetMovimientoByNumeroUsecase {
	final MovimientoRepository movimientoRepository;

	GetMovimientoByNumeroUsecase({required this.movimientoRepository});

	Future<Either<Failure, Movimiento>> call(String numeroMovimiento) async {
		return movimientoRepository.getMovimientoByNumero(numeroMovimiento);
	}
}

