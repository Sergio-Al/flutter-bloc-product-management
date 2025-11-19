import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/inventario.dart';
import 'package:flutter_management_system/domain/repositories/inventario_repository.dart';

class UpdateInventarioUsecase {
	final InventarioRepository repository;

	UpdateInventarioUsecase(this.repository);

	Future<Either<Failure, Inventario>> call(Inventario inventario) {
		return repository.updateInventario(inventario);
	}
}
