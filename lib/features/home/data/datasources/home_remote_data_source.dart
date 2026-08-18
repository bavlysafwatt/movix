import 'package:movix/core/api/api_consumer.dart';
import 'package:movix/core/api/end_points.dart';

import '../models/movie_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<MovieModel>> getTrendingWeek();
  Future<List<MovieModel>> getTrendingDay();
  Future<List<MovieModel>> getPopular();
  Future<List<MovieModel>> getTopRated();
  Future<List<MovieModel>> getUpcoming();
  Future<List<MovieModel>> getNowPlaying();
  Future<List<MovieModel>> getPopularTv();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl(this._apiConsumer);
  final ApiConsumer _apiConsumer;

  @override
  Future<List<MovieModel>> getTrendingWeek() => _fetch(EndPoints.trendingAllWeek);

  @override
  Future<List<MovieModel>> getTrendingDay() => _fetch(EndPoints.trendingAllDay);

  @override
  Future<List<MovieModel>> getPopular() => _fetch(EndPoints.popularMovies, mediaType: 'movie');

  @override
  Future<List<MovieModel>> getTopRated() => _fetch(EndPoints.topRatedMovies, mediaType: 'movie');

  @override
  Future<List<MovieModel>> getUpcoming() => _fetch(EndPoints.upcomingMovies, mediaType: 'movie');

  @override
  Future<List<MovieModel>> getNowPlaying() => _fetch(EndPoints.nowPlayingMovies, mediaType: 'movie');

  @override
  Future<List<MovieModel>> getPopularTv() => _fetch(EndPoints.popularTv, mediaType: 'tv');

  Future<List<MovieModel>> _fetch(String path, {String? mediaType}) async {
    final response = await _apiConsumer.get(path);
    final results = (response['results'] as List)
        .cast<Map<String, dynamic>>()
        .where((json) => (json['media_type'] as String?) != 'person');

    return results.map((json) => MovieModel.fromJson(json, mediaType: mediaType)).toList();
  }
}