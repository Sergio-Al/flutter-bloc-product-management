import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/proveedor.dart';
import 'package:flutter_management_system/domain/repositories/proveedor_repository.dart';

class GetProveedorByIdUsecase {
  final ProveedorRepository proveedorRepository;

  GetProveedorByIdUsecase({required this.proveedorRepository});

  Future<Either<Failure, Proveedor>> call(String proveedorId) {
    return proveedorRepository.getProveedorById(proveedorId);
  }
}
