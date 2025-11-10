import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/auth_repository.dart';


class UpdatePasswordUsecase {
  final AuthRepository repository;

  UpdatePasswordUsecase(this.repository);

  Future<Either<Failure, Unit>> call({
    required String currentPassword,
    required String newPassword,
  }) {
    return repository.updatePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
