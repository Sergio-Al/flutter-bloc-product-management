import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/usuario.dart';
import '../../repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository authRepository;

  RegisterUsecase(this.authRepository);

  Future<Either<Failure, Usuario>> call({
    required String email,
    required String password,
    required String nombreCompleto,
    required String telefono,
  }) {
    return authRepository.register(
      email: email,
      password: password,
      nombreCompleto: nombreCompleto,
      telefono: telefono,
    );
  }

}
