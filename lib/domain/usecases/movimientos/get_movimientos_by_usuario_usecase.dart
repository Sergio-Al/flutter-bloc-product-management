import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/movimiento.dart';
import 'package:flutter_management_system/domain/repositories/movimiento_repository.dart';

class GetMovimientosByUsuarioUsecase {
	final MovimientoRepository movimientoRepository;

	GetMovimientosByUsuarioUsecase({required this.movimientoRepository});

	Future<Either<Failure, List<Movimiento>>> call(String usuarioId) async {
		return movimientoRepository.getMovimientosByUsuario(usuarioId);
	}
}

