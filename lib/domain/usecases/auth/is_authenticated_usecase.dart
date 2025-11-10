import '../../repositories/auth_repository.dart';

class IsAuthenticatedUsecase {
  final AuthRepository repository;

  IsAuthenticatedUsecase(this.repository);

  Future<bool> call() {
    return repository.isAuthenticated();
  }
}
