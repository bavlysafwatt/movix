import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movix/core/usecase/usecase.dart';

import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/get_region.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/set_region.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(
      this._getCurrentUser,
      this._getRegion,
      this._setRegion,
      this._logout,
      ) : super(SettingsInitial()) {
    _init();
  }

  final GetCurrentUser _getCurrentUser;
  final GetRegion _getRegion;
  final SetRegion _setRegion;
  final Logout _logout;

  Future<void> _init() async {
    emit(SettingsLoading());
    final userResult = await _getCurrentUser(const NoParams());
    final regionResult = await _getRegion(const NoParams());
    if (isClosed) return;

    final user = userResult.getOrElse(() => null);
    final region = regionResult.getOrElse(() => 'US');
    emit(SettingsLoaded(name: user?.name, email: user?.email, region: region));
  }

  Future<void> changeRegion(String regionCode) async {
    final current = state;
    if (current is! SettingsLoaded) return;
    await _setRegion(regionCode);
    if (isClosed) return;
    emit(SettingsLoaded(name: current.name, email: current.email, region: regionCode));
  }

  Future<void> logout() async {
    final current = state;
    if (current is! SettingsLoaded) return;
    emit(SettingsLoggingOut(name: current.name, email: current.email, region: current.region));
    final result = await _logout(const NoParams());
    if (isClosed) return;
    result.fold(
          (error) => emit(SettingsActionFailure(
        name: current.name, email: current.email, region: current.region, message: error.message,
      )),
          (_) => emit(SettingsLoggedOut()),
    );
  }
}