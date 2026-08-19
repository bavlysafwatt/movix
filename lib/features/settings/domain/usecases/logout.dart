import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';
import 'package:movix/features/settings/domain/repositories/settings_repository.dart';

class Logout implements UseCase<void, NoParams> {
  const Logout(this._repository);
  final SettingsRepository _repository;
  @override
  Future<Either<GenericException, void>> call(NoParams params) =>
      _repository.logout();
}