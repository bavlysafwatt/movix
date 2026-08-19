import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';
import 'package:movix/features/settings/domain/repositories/settings_repository.dart';

class SetRegion implements UseCase<void, String> {
  const SetRegion(this._repository);
  final SettingsRepository _repository;
  @override
  Future<Either<GenericException, void>> call(String regionCode) async {
    await _repository.setRegion(regionCode);
    return const Right(null);
  }
}