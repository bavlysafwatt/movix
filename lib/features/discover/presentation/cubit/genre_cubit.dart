import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movix/core/usecase/usecase.dart';

import '../../domain/usecases/get_genres.dart';
import 'genre_state.dart';

class GenreCubit extends Cubit<GenreState> {
  GenreCubit(this._getGenres) : super(GenreInitial());
  final GetGenres _getGenres;

  Future<void> fetchGenres() async {
    emit(GenreLoading());
    final result = await _getGenres(const NoParams());
    if (isClosed) return;
    result.fold(
          (error) => emit(GenreError(message: error.message)),
          (genres) => emit(GenreSuccess(genres: genres)),
    );
  }
}