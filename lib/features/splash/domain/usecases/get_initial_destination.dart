import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';

import '../entities/splash_destination.dart';
import '../repositories/splash_repository.dart';

class GetInitialDestination
    implements UseCase<SplashDestination, NoParams> {
  const GetInitialDestination(this._repository);

  final SplashRepository _repository;

  @override
  Future<Either<GenericException, SplashDestination>> call(NoParams params) {
    return _repository.getInitialDestination();
  }
}
