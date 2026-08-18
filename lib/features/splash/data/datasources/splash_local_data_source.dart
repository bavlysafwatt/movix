import 'package:movix/core/helpers/shared_pref_helper.dart';
import 'package:movix/core/utils/constants.dart';

abstract class SplashLocalDataSource {
  Future<bool> isOnboardingCompleted();
}

class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  @override
  Future<bool> isOnboardingCompleted() async {
    return SharedPrefHelper.getBool(
          key: Constants.onboardingCompletedKey,
        ) ??
        false;
  }
}
