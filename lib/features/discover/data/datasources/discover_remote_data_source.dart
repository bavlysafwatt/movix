import 'package:movix/core/api/api_consumer.dart';
import 'package:movix/core/api/end_points.dart';
import 'package:movix/features/home/data/models/movie_model.dart';

import '../../domain/entities/discover_filters.dart';
import '../model/genre_model.dart';

abstract class DiscoverRemoteDataSource {
  Future<List<GenreModel>> getGenres();
  Future<({List<MovieModel> movies, int page, int totalPages})> discoverMovies({
    required DiscoverFilters filters,
    required int page,
  });
}

class DiscoverRemoteDataSourceImpl implements DiscoverRemoteDataSource {
  const DiscoverRemoteDataSourceImpl(this._apiConsumer);
  final ApiConsumer _apiConsumer;

  @override
  Future<List<GenreModel>> getGenres() async {
    final response = await _apiConsumer.get(EndPoints.movieGenres);
    final genres = (response['genres'] as List).cast<Map<String, dynamic>>();
    return genres.map(GenreModel.fromJson).toList();
  }

  @override
  Future<({List<MovieModel> movies, int page, int totalPages})> discoverMovies({
    required DiscoverFilters filters,
    required int page,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'sort_by': filters.sort.apiValue,
      if (filters.genre != null) 'with_genres': filters.genre!.id,
      if (filters.year != null) 'primary_release_year': filters.year,
      if (filters.minRating != null) 'vote_average.gte': filters.minRating,
    };

    final response = await _apiConsumer.get(EndPoints.discoverMovie, queryParameters: queryParameters);
    final results = (response['results'] as List).cast<Map<String, dynamic>>();

    return (
    movies: results.map((json) => MovieModel.fromJson(json, mediaType: 'movie')).toList(),
    page: response['page'] as int,
    totalPages: response['total_pages'] as int,
    );
  }
}