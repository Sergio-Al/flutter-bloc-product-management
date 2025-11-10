import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/auth_repository.dart';

class ResetPasswordUsecase {
  final AuthRepository repository;

  ResetPasswordUsecase(this.repository);

  Future<Either<Failure, Unit>> call({required String email}) {
    return repository.resetPassword(email);
  }
}
