import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/inventario.dart';
import 'package:flutter_management_system/domain/repositories/inventario_repository.dart';

class ReservarStockUsecase {
	final InventarioRepository repository;

	ReservarStockUsecase(this.repository);

	Future<Either<Failure, Inventario>> call(String inventarioId, int cantidad) {
		return repository.reservarStock(inventarioId: inventarioId, cantidad: cantidad);
	}
}
