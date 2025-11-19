import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/inventario.dart';
import 'package:flutter_management_system/domain/repositories/inventario_repository.dart';

class GetInventariosByProductoUsecase {
	final InventarioRepository repository;

	GetInventariosByProductoUsecase(this.repository);

	Future<Either<Failure, List<Inventario>>> call(String productoId) {
		return repository.getInventariosByProducto(productoId);
	}
}
