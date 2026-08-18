import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movix/core/usecase/usecase.dart';
import 'package:movix/features/onboarding/domain/usecases/complete_onboarding.dart';

import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this._completeOnboarding) : super(const OnboardingState());

  final CompleteOnboarding _completeOnboarding;

  void changePage(int page) {
    emit(state.copyWith(currentPage: page, clearError: true));
  }

  Future<bool> complete() async {
    if (state.isCompleting) return false;

    emit(state.copyWith(isCompleting: true, clearError: true));
    final result = await _completeOnboarding(const NoParams());
    if (isClosed) return false;

    return result.fold(
      (exception) {
        if (!isClosed) {
          emit(
            state.copyWith(
              isCompleting: false,
              errorMessage: exception.message,
            ),
          );
        }
        return false;
      },
      (_) {
        if (!isClosed) emit(state.copyWith(isCompleting: false));
        return true;
      },
    );
  }
}
