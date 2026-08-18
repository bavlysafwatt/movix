import 'package:movix/core/helpers/shared_pref_helper.dart';
import 'package:movix/core/utils/constants.dart';

abstract class OnboardingLocalDataSource {
  Future<void> markAsCompleted();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  @override
  Future<void> markAsCompleted() {
    return SharedPrefHelper.setData(
      key: Constants.onboardingCompletedKey,
      value: true,
    );
  }
}
