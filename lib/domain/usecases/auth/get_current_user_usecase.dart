import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/usuario.dart';
import '../../repositories/auth_repository.dart';


class GetCurrentUserUsecase {
  final AuthRepository repository;

  GetCurrentUserUsecase(this.repository);

  Future<Either<Failure, Usuario>> call() {
    return repository.getCurrentUser();
  }
}
