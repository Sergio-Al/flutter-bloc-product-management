import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/proveedor.dart';
import 'package:flutter_management_system/domain/repositories/proveedor_repository.dart';

class GetProveedoresByCiudadUsecase {
  final ProveedorRepository proveedorRepository;

  GetProveedoresByCiudadUsecase({required this.proveedorRepository});

  Future<Either<Failure, List<Proveedor>>> call(String ciudad) {
    return proveedorRepository.getProveedoresByCiudad(ciudad);
  }
}
