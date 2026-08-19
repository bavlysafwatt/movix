import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';
import 'package:movix/features/settings/domain/repositories/settings_repository.dart';

class GetRegion implements UseCase<String, NoParams> {
  const GetRegion(this._repository);
  final SettingsRepository _repository;
  @override
  Future<Either<GenericException, String>> call(NoParams params) async =>
      Right(await _repository.getRegion());
}