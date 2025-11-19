import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/repositories/inventario_repository.dart';

class GetValorTotalInventarioUsecase {
	final InventarioRepository repository;

	GetValorTotalInventarioUsecase(this.repository);

	Future<Either<Failure, double>> call(String tiendaId) {
		return repository.getValorTotalInventario(tiendaId);
	}
}
