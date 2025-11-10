import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/usuario.dart';
import '../../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, Usuario>> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}
