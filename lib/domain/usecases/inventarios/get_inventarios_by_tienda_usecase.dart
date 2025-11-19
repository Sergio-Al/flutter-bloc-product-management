import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/inventario.dart';
import 'package:flutter_management_system/domain/repositories/inventario_repository.dart';

class GetInventariosByTiendaUsecase {
	final InventarioRepository repository;

	GetInventariosByTiendaUsecase(this.repository);

	Future<Either<Failure, List<Inventario>>> call(String tiendaId) {
		return repository.getInventariosByTienda(tiendaId);
	}
}
