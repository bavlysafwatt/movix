import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movix/core/usecase/usecase.dart';

import '../../domain/usecases/get_home_sections.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getHomeSections) : super(HomeInitial());
  final GetHomeSections _getHomeSections;

  Future<void> fetchHome() async {
    emit(HomeLoading());
    final result = await _getHomeSections(const NoParams());
    if (isClosed) return;
    result.fold(
          (exception) => emit(HomeError(message: exception.message)),
          (sections) => emit(HomeSuccess(sections: sections)),
    );
  }
}