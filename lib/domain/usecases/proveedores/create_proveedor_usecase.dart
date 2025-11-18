import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/proveedor.dart';
import 'package:flutter_management_system/domain/repositories/proveedor_repository.dart';

class CreateProveedorUsecase {
  final ProveedorRepository proveedorRepository;

  CreateProveedorUsecase(this.proveedorRepository);

  Future<Either<Failure, Proveedor>> call(Proveedor proveedor) {
    return proveedorRepository.createProveedor(proveedor);
  }
}
