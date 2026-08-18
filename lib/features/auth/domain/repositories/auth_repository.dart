import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';

import '../entities/auth_user.dart';
import '../entities/sign_up_result.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  Future<Either<GenericException, AppUser>> signInWithEmail({
    required String email,
    required String password,
  });
  Future<Either<GenericException, SignUpResult>> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<GenericException, AppUser>> signInWithGoogle();
  Future<Either<GenericException, void>> sendPasswordResetEmail(String email);
}