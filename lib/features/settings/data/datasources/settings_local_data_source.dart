import 'package:movix/core/helpers/shared_pref_helper.dart';
import 'package:movix/core/utils/constants.dart';

abstract class SettingsLocalDataSource {
  Future<String> getRegion();
  Future<void> setRegion(String regionCode);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  const SettingsLocalDataSourceImpl();
  static const _defaultRegion = 'EG';

  @override
  Future<String> getRegion() async {
    final stored = SharedPrefHelper.getString(key: Constants.regionKey);
    final isUnset = stored == null || stored.isEmpty;
    if (isUnset) {
      await setRegion(_defaultRegion);
    }
    return isUnset ? _defaultRegion : stored;
  }

  @override
  Future<void> setRegion(String regionCode) {
    return SharedPrefHelper.setData(key: Constants.regionKey, value: regionCode);
  }
}