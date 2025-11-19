import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/movimiento.dart';
import 'package:flutter_management_system/domain/repositories/movimiento_repository.dart';

class GetMovimientosByTiendaUsecase {
	final MovimientoRepository movimientoRepository;

	GetMovimientosByTiendaUsecase({required this.movimientoRepository});

	Future<Either<Failure, List<Movimiento>>> call(String tiendaId) async {
		return movimientoRepository.getMovimientosByTienda(tiendaId);
	}
}

