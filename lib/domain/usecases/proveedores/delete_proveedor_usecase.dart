import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/proveedor.dart';
import 'package:flutter_management_system/domain/repositories/proveedor_repository.dart';

class DeleteProveedorUsecase {
  final ProveedorRepository proveedorRepository;

  DeleteProveedorUsecase(this.proveedorRepository);

  Future<Either<Failure, void>> call(String proveedorId) {
    return proveedorRepository.deleteProveedor(proveedorId);
  }
}
