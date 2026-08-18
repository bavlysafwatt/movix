import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/utils/app_strings.dart';
import 'package:movix/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:movix/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this._localDataSource);

  final OnboardingLocalDataSource _localDataSource;

  @override
  Future<Either<GenericException, void>> completeOnboarding() async {
    try {
      await _localDataSource.markAsCompleted();
      return const Right(null);
    } on GenericException catch (exception) {
      return Left(exception);
    } catch (_) {
      return const Left(
        GenericException(message: AppStrings.onboardingSaveError),
      );
    }
  }
}
