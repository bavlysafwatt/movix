import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:movix/core/usecase/usecase.dart';
import 'package:movix/features/splash/domain/usecases/get_initial_destination.dart';

import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._getInitialDestination) : super(const SplashInitial());

  static const _minimumDisplayDuration = Duration(milliseconds: 1600);

  final GetInitialDestination _getInitialDestination;

  Future<void> determineInitialDestination() async {
    emit(const SplashLoading());
    final hasInternet = await InternetConnection().hasInternetAccess;
    if(!hasInternet) {
      emit(const SplashFailure('No internet connection. Please check your connection and try again.'));
      return;
    }
    final stopwatch = Stopwatch()..start();
    final result = await _getInitialDestination(const NoParams());

    final remainingDuration =
        _minimumDisplayDuration - stopwatch.elapsed;

    if (remainingDuration.inMicroseconds > 0) {
      await Future<void>.delayed(remainingDuration);
    }

    result.fold(
      (exception) { emit(SplashFailure(exception.message)); },
      (destination) { emit(SplashReady(destination)); },
    );
  }
}
