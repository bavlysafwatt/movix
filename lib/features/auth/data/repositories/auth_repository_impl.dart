import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/utils/app_strings.dart';
import 'package:movix/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:movix/features/auth/data/models/auth_user_model.dart';
import 'package:movix/features/auth/domain/entities/auth_user.dart';
import 'package:movix/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Stream<AppUser?> authStateChanges() {
    return _remoteDataSource.authStateChanges().map(
          (user) => user == null ? null : AuthUserModel.fromSupabaseUser(user),
    );
  }

  @override
  Future<Either<GenericException, AppUser>> signInWithGoogle() async {
    try {
      final user = await _remoteDataSource.signInWithGoogle();
      return Right(AuthUserModel.fromSupabaseUser(user));
    } on AuthException catch (exception) {
      return Left(GenericException(message: exception.message));
    } catch (_) {
      return const Left(GenericException(message: AppStrings.authUnexpectedError));
    }
  }
}