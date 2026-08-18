import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';

abstract class OnboardingRepository {
  Future<Either<GenericException, void>> completeOnboarding();
}
