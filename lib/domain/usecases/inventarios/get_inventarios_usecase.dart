import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/inventario.dart';
import 'package:flutter_management_system/domain/repositories/inventario_repository.dart';

class GetInventariosUsecase {
	final InventarioRepository repository;

	GetInventariosUsecase(this.repository);

	Future<Either<Failure, List<Inventario>>> call() {
		return repository.getInventarios();
	}
}
