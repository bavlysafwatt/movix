import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';

import '../entities/auth_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  Future<Either<GenericException, AppUser>> signInWithGoogle();
}