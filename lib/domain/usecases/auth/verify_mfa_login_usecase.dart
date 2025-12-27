import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/auth_repository.dart';

/// Use case for verifying MFA code during login
class VerifyMfaLoginUseCase {
  final AuthRepository repository;

  VerifyMfaLoginUseCase(this.repository);

  /// Verifies the MFA code and completes the login
  /// 
  /// Returns: Either with Failure or Map containing user and access_token
  Future<Either<Failure, Map<String, dynamic>>> call({
    required String token,
  }) async {
    return await repository.verifyMfaLogin(token: token);
  }
}
