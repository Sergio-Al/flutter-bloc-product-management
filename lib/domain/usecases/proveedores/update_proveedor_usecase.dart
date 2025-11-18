import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/proveedor.dart';
import 'package:flutter_management_system/domain/repositories/proveedor_repository.dart';


class UpdateProveedorUsecase {
  final ProveedorRepository proveedorRepository;

  UpdateProveedorUsecase({required this.proveedorRepository});

  Future<Either<Failure, Proveedor>> call(Proveedor proveedor) {
    return proveedorRepository.updateProveedor(proveedor);
  }
}
