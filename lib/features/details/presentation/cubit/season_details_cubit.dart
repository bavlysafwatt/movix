import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movix/features/details/domain/usecases/get_season_details.dart';

import 'season_details_state.dart';

class SeasonDetailsCubit extends Cubit<SeasonDetailsState> {
  SeasonDetailsCubit(this._getSeasonDetails) : super(SeasonDetailsInitial());
  final GetSeasonDetails _getSeasonDetails;

  Future<void> load(int tvId, int seasonNumber) async {
    emit(SeasonDetailsLoading());
    final result = await _getSeasonDetails((tvId: tvId, seasonNumber: seasonNumber));
    if (isClosed) return;
    result.fold(
          (error) => emit(SeasonDetailsError(message: error.message)),
          (season) => emit(SeasonDetailsLoaded(season: season)),
    );
  }
}