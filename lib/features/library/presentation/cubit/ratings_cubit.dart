import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movix/core/usecase/usecase.dart';
import 'package:movix/features/library/domain/usecases/get_rated_items.dart';
import 'package:movix/features/library/presentation/cubit/ratings_state.dart';

class RatingsCubit extends Cubit<RatingsState> {
  RatingsCubit(this._getRatedItems) : super(RatingsInitial());
  final GetRatedItems _getRatedItems;

  Future<void> load() async {
    emit(RatingsLoading());
    final result = await _getRatedItems(const NoParams());
    if (isClosed) return;
    result.fold(
          (error) => emit(RatingsError(message: error.message)),
          (items) => emit(RatingsLoaded(items: items)),
    );
  }
}