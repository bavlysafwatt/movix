import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movix/core/usecase/usecase.dart';

import '../../domain/entities/search_filter.dart';
import '../../domain/usecases/recent_searches.dart';
import '../../domain/usecases/search_movies.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(
      this._searchMovies,
      this._getRecentSearches,
      this._saveRecentSearch,
      this._clearRecentSearches,
      ) : super(const SearchInitial()) {
    _loadRecentSearches();
  }

  final SearchMovies _searchMovies;
  final GetRecentSearches _getRecentSearches;
  final SaveRecentSearch _saveRecentSearch;
  final ClearRecentSearches _clearRecentSearches;

  Timer? _debounce;
  List<String> _recentSearches = const [];
  String _lastQuery = '';
  SearchFilter _lastFilter = SearchFilter.all;

  Future<void> _loadRecentSearches() async {
    final result = await _getRecentSearches(const NoParams());
    if (isClosed) return;
    _recentSearches = result.getOrElse(() => const []);
    emit(SearchInitial(recentSearches: _recentSearches));
  }

  void onQueryChanged(String query, SearchFilter filter) {
    _debounce?.cancel();
    _lastQuery = query;
    _lastFilter = filter;

    if (query.trim().isEmpty) {
      emit(SearchInitial(recentSearches: _recentSearches));
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () => _runSearch(query.trim(), filter));
  }

  void onFilterChanged(SearchFilter filter) {
    _lastFilter = filter;
    if (_lastQuery.trim().isNotEmpty) {
      _debounce?.cancel();
      _runSearch(_lastQuery.trim(), filter);
    }
  }

  void searchImmediately(String query, SearchFilter filter) {
    _debounce?.cancel();
    _lastQuery = query;
    _lastFilter = filter;
    _runSearch(query, filter);
  }

  void retry() {
    if (_lastQuery.trim().isNotEmpty) _runSearch(_lastQuery.trim(), _lastFilter);
  }

  Future<void> _runSearch(String query, SearchFilter filter) async {
    emit(SearchLoading());
    final result = await _searchMovies(SearchParams(query: query, filter: filter));
    if (isClosed) return;

    result.fold(
          (error) => emit(SearchError(message: error.message)),
          (movies) {
        emit(movies.isEmpty ? SearchEmpty() : SearchSuccess(results: movies));
        _persistRecentSearch(query);
      },
    );
  }

  Future<void> _persistRecentSearch(String query) async {
    await _saveRecentSearch(query);
    final result = await _getRecentSearches(const NoParams());
    if (!isClosed) _recentSearches = result.getOrElse(() => _recentSearches);
  }

  Future<void> clearRecentSearches() async {
    await _clearRecentSearches(const NoParams());
    if (isClosed) return;
    _recentSearches = const [];
    if (state is SearchInitial) emit(SearchInitial(recentSearches: _recentSearches));
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}