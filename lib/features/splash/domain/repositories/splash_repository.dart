import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';

import '../entities/splash_destination.dart';

abstract class SplashRepository {
  Future<Either<GenericException, SplashDestination>> getInitialDestination();
}
