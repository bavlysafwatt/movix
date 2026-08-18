import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/utils/app_strings.dart';
import 'package:movix/features/splash/data/datasources/splash_local_data_source.dart';
import 'package:movix/features/splash/data/datasources/splash_session_data_source.dart';
import 'package:movix/features/splash/domain/entities/splash_destination.dart';
import 'package:movix/features/splash/domain/repositories/splash_repository.dart';

class SplashRepositoryImpl implements SplashRepository {
  const SplashRepositoryImpl({
    required SplashLocalDataSource localDataSource,
    required SplashSessionDataSource sessionDataSource,
  })  : _localDataSource = localDataSource,
        _sessionDataSource = sessionDataSource;

  final SplashLocalDataSource _localDataSource;
  final SplashSessionDataSource _sessionDataSource;

  @override
  Future<Either<GenericException, SplashDestination>>
  getInitialDestination() async {
    try {
      final isOnboardingCompleted =
          await _localDataSource.isOnboardingCompleted();

      if (!isOnboardingCompleted) {
        return const Right(SplashDestination.onboarding);
      }

      final hasActiveSession = await _sessionDataSource.hasActiveSession();
      return Right(
        hasActiveSession ? SplashDestination.home : SplashDestination.login,
      );
    } on GenericException catch (exception) {
      return Left(exception);
    } catch (_) {
      return const Left(
        GenericException(message: AppStrings.splashInitializationError),
      );
    }
  }
}
