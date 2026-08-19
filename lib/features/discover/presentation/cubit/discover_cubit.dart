import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movix/features/discover/domain/entities/discover_filters.dart';

import '../../domain/usecases/discover_movies.dart';
import 'discover_state.dart';

class DiscoverCubit extends Cubit<DiscoverState> {
  DiscoverCubit(this._discoverMovies) : super(DiscoverInitial());
  final DiscoverMovies _discoverMovies;
  DiscoverFilters _lastFilters = const DiscoverFilters();

  Future<void> loadInitial(DiscoverFilters filters) async {
    _lastFilters = filters;
    emit(DiscoverLoading());
    final result = await _discoverMovies(DiscoverMoviesParams(filters: filters, page: 1));
    if (isClosed) return;
    result.fold(
          (error) => emit(DiscoverError(message: error.message)),
          (page) => emit(DiscoverLoaded(
        movies: page.movies,
        filters: filters,
        page: page.page,
        hasMore: page.hasMore,
      )),
    );
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! DiscoverLoaded || !current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));
    final result = await _discoverMovies(
      DiscoverMoviesParams(filters: current.filters, page: current.page + 1),
    );
    if (isClosed) return;

    result.fold(
          (_) => emit(current.copyWith()), // network hiccup on page N+1: keep what's loaded, just stop the spinner
          (page) => emit(current.copyWith(
        movies: [...current.movies, ...page.movies],
        page: page.page,
        hasMore: page.hasMore,
      )),
    );
  }

  void applyFilters(DiscoverFilters filters) => loadInitial(filters);
  void retry() => loadInitial(_lastFilters);
}