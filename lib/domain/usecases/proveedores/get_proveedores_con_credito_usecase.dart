import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/domain/entities/proveedor.dart';
import 'package:flutter_management_system/domain/repositories/proveedor_repository.dart';

class GetProveedoresConCreditoUsecase {
  final ProveedorRepository proveedorRepository;

  GetProveedoresConCreditoUsecase({required this.proveedorRepository});

  Future<Either<Failure, List<Proveedor>>> call() {
    return proveedorRepository.getProveedoresConCredito();
  }
}
