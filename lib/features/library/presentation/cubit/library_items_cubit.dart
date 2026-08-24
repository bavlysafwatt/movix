import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movix/core/usecase/usecase.dart';
import 'package:movix/features/library/domain/entities/library_item.dart';
import 'package:movix/features/library/domain/usecases/get_favorites.dart';
import 'package:movix/features/library/domain/usecases/get_watched_history.dart';
import 'package:movix/features/library/domain/usecases/get_watchlist.dart';
import 'package:movix/features/library/domain/usecases/toggle_favorite.dart';
import 'package:movix/features/library/domain/usecases/toggle_watched.dart';
import 'package:movix/features/library/domain/usecases/toggle_watchlist.dart';

import 'library_list_state.dart';

class LibraryItemsCubit extends Cubit<LibraryListState> {
  LibraryItemsCubit(
      this.kind,
      this._getFavorites,
      this._getWatchlist,
      this._getWatchedHistory,
      this._toggleFavorite,
      this._toggleWatchlist,
      this._toggleWatched,
      ) : super(LibraryListInitial());

  final LibraryListKind kind;
  final GetFavorites _getFavorites;
  final GetWatchlist _getWatchlist;
  final GetWatchedHistory _getWatchedHistory;
  final ToggleFavorite _toggleFavorite;
  final ToggleWatchlist _toggleWatchlist;
  final ToggleWatched _toggleWatched;

  Future<void> load() async {
    emit(LibraryListLoading());
    final result = switch (kind) {
      LibraryListKind.favorites => await _getFavorites(const NoParams()),
      LibraryListKind.watchlist => await _getWatchlist(const NoParams()),
      LibraryListKind.watched => await _getWatchedHistory(const NoParams()),
    };
    if (isClosed) return;
    result.fold(
          (error) => emit(LibraryListError(message: error.message)),
          (items) => emit(LibraryListLoaded(items: items)),
    );
  }

  Future<void> remove(LibraryItem item) async {
    final current = state;
    if (current is! LibraryListLoaded) return;
    final key = '${item.tmdbId}-${item.mediaType}';

    emit(LibraryListLoaded(items: current.items, removingKeys: {...current.removingKeys, key}));

    final result = switch (kind) {
      LibraryListKind.favorites => await _toggleFavorite(ToggleFavoriteParams(item: item, add: false)),
      LibraryListKind.watchlist => await _toggleWatchlist(ToggleWatchlistParams(item: item, add: false)),
      LibraryListKind.watched => await _toggleWatched(ToggleWatchedParams(item: item, watched: false)),
    };
    if (isClosed) return;

    result.fold(
      // failed: drop the "removing" flag, item stays visible
          (_) => emit(LibraryListLoaded(items: current.items)),
      // succeeded: actually remove it from the list
          (_) => emit(LibraryListLoaded(items: current.items.where((i) => '${i.tmdbId}-${i.mediaType}' != key).toList())),
    );
  }
}