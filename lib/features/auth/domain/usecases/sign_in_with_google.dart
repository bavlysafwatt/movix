import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';

import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogle implements UseCase<AppUser, NoParams> {
  const SignInWithGoogle(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<GenericException, AppUser>> call(NoParams params) {
    return _repository.signInWithGoogle();
  }
}