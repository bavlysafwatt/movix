import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';
import 'package:movix/features/auth/domain/entities/auth_user.dart';
import 'package:movix/features/settings/domain/repositories/settings_repository.dart';

class GetCurrentUser implements UseCase<AppUser?, NoParams> {
  const GetCurrentUser(this._repository);
  final SettingsRepository _repository;
  @override
  Future<Either<GenericException, AppUser?>> call(NoParams params) async =>
      Right(_repository.getCurrentUser());
}