import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movix/core/usecase/usecase.dart';
import 'package:movix/features/library/domain/entities/library_item.dart';
import 'package:movix/features/library/domain/entities/library_item_status.dart';
import 'package:movix/features/library/domain/usecases/get_library_status.dart';
import 'package:movix/features/library/domain/usecases/rate_item.dart';
import 'package:movix/features/library/domain/usecases/toggle_favorite.dart';
import 'package:movix/features/library/domain/usecases/toggle_watched.dart';
import 'package:movix/features/library/domain/usecases/toggle_watchlist.dart';
import 'package:movix/features/settings/domain/usecases/get_region.dart';

import '../../domain/usecases/get_movie_details_bundle.dart';
import 'movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  MovieDetailsCubit(
    this._getBundle,
    this._getRegion,
    this._getStatus,
    this._toggleFavorite,
    this._toggleWatchlist,
    this._toggleWatched,
    this._rateItem,
  ) : super(MovieDetailsInitial());

  final GetMovieDetailsBundle _getBundle;
  final GetRegion _getRegion;
  final GetLibraryStatus _getStatus;
  final ToggleFavorite _toggleFavorite;
  final ToggleWatchlist _toggleWatchlist;
  final ToggleWatched _toggleWatched;
  final RateItem _rateItem;

  Future<void> load(int movieId) async {
    emit(MovieDetailsLoading());
    final regionResult = await _getRegion(const NoParams());
    if (isClosed) return;
    final region = regionResult.getOrElse(() => 'US');

    final bundleResult = await _getBundle(
      MovieDetailsParams(movieId: movieId, region: region),
    );
    if (isClosed) return;

    await bundleResult.fold(
      (error) async => emit(MovieDetailsError(message: error.message)),
      (bundle) async {
        final statusResult = await _getStatus(
          LibraryStatusParams(tmdbId: movieId, mediaType: 'movie'),
        );
        if (isClosed) return;
        emit(
          MovieDetailsLoaded(
            details: bundle.details,
            cast: bundle.cast,
            trailerKey: bundle.trailerKey,
            similar: bundle.similar,
            recommendations: bundle.recommendations,
            watchProviders: bundle.watchProviders,
            status: statusResult.getOrElse(() => const LibraryItemStatus()),
          ),
        );
      },
    );
  }

  Future<void> toggleFavorite() async {
    final current = state;
    if (current is! MovieDetailsLoaded) return;
    emit(current.copyWith(status: current.status, isUpdatingFavorite: true));

    final item = _itemFrom(current);
    final result = await _toggleFavorite(
      ToggleFavoriteParams(item: item, add: !current.status.isFavorite),
    );
    if (isClosed) return;

    result.fold(
      (_) => emit(current.copyWith(status: current.status)),
      (_) => emit(
        current.copyWith(
          status: current.status.copyWith(
            isFavorite: !current.status.isFavorite,
          ),
        ),
      ),
    );
  }

  Future<void> toggleWatchlist() async {
    final current = state;
    if (current is! MovieDetailsLoaded) return;
    emit(current.copyWith(status: current.status, isUpdatingWatchlist: true));

    final item = _itemFrom(current);
    final result = await _toggleWatchlist(
      ToggleWatchlistParams(item: item, add: !current.status.isInWatchlist),
    );
    if (isClosed) return;

    result.fold(
      (_) => emit(current.copyWith(status: current.status)),
      (_) => emit(
        current.copyWith(
          status: current.status.copyWith(
            isInWatchlist: !current.status.isInWatchlist,
          ),
        ),
      ),
    );
  }

  Future<void> toggleWatched() async {
    final current = state;
    if (current is! MovieDetailsLoaded) return;
    emit(current.copyWith(status: current.status, isUpdatingWatched: true));

    final result = await _toggleWatched(
      ToggleWatchedParams(
        item: _itemFrom(current),
        watched: !current.status.isWatched,
      ),
    );
    if (isClosed) return;

    result.fold(
      (_) => emit(current.copyWith(status: current.status)),
      (_) => emit(
        current.copyWith(
          status: current.status.copyWith(isWatched: !current.status.isWatched),
        ),
      ),
    );
  }

  Future<void> rate(double rating) async {
    final current = state;
    if (current is! MovieDetailsLoaded) return;
    emit(current.copyWith(status: current.status, isSubmittingRating: true));

    final result = await _rateItem(
      RateItemParams(
        tmdbId: current.details.id,
        mediaType: 'movie',
        rating: rating,
      ),
    );
    if (isClosed) return;

    result.fold(
      (_) => emit(current.copyWith(status: current.status)),
      (_) => emit(
        current.copyWith(status: current.status.copyWith(userRating: rating)),
      ),
    );
  }

  LibraryItem _itemFrom(MovieDetailsLoaded state) => LibraryItem(
    tmdbId: state.details.id,
    mediaType: 'movie',
    title: state.details.title,
    posterPath: state.details.posterPath,
    releaseDate: state.details.releaseDate,
  );
}
