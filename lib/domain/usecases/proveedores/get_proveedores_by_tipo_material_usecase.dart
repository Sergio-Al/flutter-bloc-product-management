import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/proveedor.dart';
import 'package:flutter_management_system/domain/repositories/proveedor_repository.dart';

class GetProveedoresByTipoMaterialUsecase {
  final ProveedorRepository proveedorRepository;

  GetProveedoresByTipoMaterialUsecase({required this.proveedorRepository});

  Future<Either<Failure, List<Proveedor>>> call(String tipoMaterial) {
    return proveedorRepository.getProveedoresByTipoMaterial(tipoMaterial);
  }
}
