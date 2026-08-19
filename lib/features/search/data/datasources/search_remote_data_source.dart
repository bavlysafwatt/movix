import 'package:movix/core/api/api_consumer.dart';
import 'package:movix/core/api/end_points.dart';
import 'package:movix/features/home/data/models/movie_model.dart';

import '../../domain/entities/search_filter.dart';

abstract class SearchRemoteDataSource {
  Future<List<MovieModel>> search(String query, SearchFilter filter);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  const SearchRemoteDataSourceImpl(this._apiConsumer);
  final ApiConsumer _apiConsumer;

  @override
  Future<List<MovieModel>> search(String query, SearchFilter filter) async {
    final path = switch (filter) {
      SearchFilter.all => EndPoints.searchMulti,
      SearchFilter.movie => EndPoints.searchMovie,
      SearchFilter.tv => EndPoints.searchTv,
    };

    final response = await _apiConsumer.get(path, queryParameters: {'query': query});
    final rawResults = (response['results'] as List).cast<Map<String, dynamic>>();

    // media_type is only present on `multi` results; for movie/tv-only endpoints we pass it explicitly.
    final mediaType = switch (filter) {
      SearchFilter.movie => 'movie',
      SearchFilter.tv => 'tv',
      SearchFilter.all => null,
    };

    return rawResults
        .where((json) => (json['media_type'] as String?) != 'person')
        .map((json) => MovieModel.fromJson(json, mediaType: mediaType))
        .toList();
  }
}