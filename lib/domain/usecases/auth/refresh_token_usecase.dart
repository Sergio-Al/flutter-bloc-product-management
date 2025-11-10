import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/auth_repository.dart';

class RefreshTokenUsecase {
  final AuthRepository repository;

  RefreshTokenUsecase(this.repository);

  Future<Either<Failure, Unit>> call() {
    return repository.refreshToken();
  }
}
