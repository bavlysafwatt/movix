import 'package:movix/core/api/api_consumer.dart';
import 'package:movix/core/api/end_points.dart';
import 'package:movix/features/details/data/models/episode_model.dart';
import 'package:movix/features/details/data/models/person_details_model.dart';
import 'package:movix/features/details/data/models/watch_providers_model.dart';
import 'package:movix/features/home/data/models/movie_model.dart';

import '../models/cast_member_model.dart';
import '../models/movie_details_model.dart';
import '../models/tv_details_model.dart';

abstract class DetailsRemoteDataSource {
  Future<MovieDetailsModel> getMovieDetails(int id);
  Future<List<CastMemberModel>> getMovieCredits(int id);
  Future<String?> getMovieTrailerKey(int id);
  Future<List<MovieModel>> getMovieSimilar(int id);
  Future<List<MovieModel>> getMovieRecommendations(int id);
  Future<TvDetailsModel> getTvDetails(int id);
  Future<List<CastMemberModel>> getTvCredits(int id);
  Future<String?> getTvTrailerKey(int id);
  Future<List<MovieModel>> getTvSimilar(int id);
  Future<List<MovieModel>> getTvRecommendations(int id);
  Future<SeasonDetailsModel> getSeasonDetails(int tvId, int seasonNumber);
  Future<PersonDetailsModel> getPersonDetails(int id);
  Future<List<MovieModel>> getPersonFilmography(int id);
  Future<WatchProvidersInfoModel?> getMovieWatchProviders(int id, String region);
  Future<WatchProvidersInfoModel?> getTvWatchProviders(int id, String region);
}

class DetailsRemoteDataSourceImpl implements DetailsRemoteDataSource {
  const DetailsRemoteDataSourceImpl(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  @override
  Future<MovieDetailsModel> getMovieDetails(int id) async {
    final response = await _apiConsumer.get(EndPoints.movieDetails(id));
    return MovieDetailsModel.fromJson(response);
  }

  @override
  Future<List<CastMemberModel>> getMovieCredits(int id) async {
    final response = await _apiConsumer.get(EndPoints.movieCredits(id));
    final cast = (response['cast'] as List).cast<Map<String, dynamic>>();
    return cast.take(10).map(CastMemberModel.fromJson).toList();
  }

  @override
  Future<String?> getMovieTrailerKey(int id) async {
    final response = await _apiConsumer.get(EndPoints.movieVideos(id));
    final videos = (response['results'] as List).cast<Map<String, dynamic>>();

    final trailer = videos.firstWhere(
      (v) => v['site'] == 'YouTube' && v['type'] == 'Trailer',
      orElse: () => videos.firstWhere(
        (v) => v['site'] == 'YouTube',
        orElse: () => const {},
      ),
    );
    return trailer['key'] as String?;
  }

  @override
  Future<List<MovieModel>> getMovieSimilar(int id) =>
      _movieList(EndPoints.movieSimilar(id));

  @override
  Future<List<MovieModel>> getMovieRecommendations(int id) =>
      _movieList(EndPoints.movieRecommendations(id));

  @override
  Future<TvDetailsModel> getTvDetails(int id) async =>
      TvDetailsModel.fromJson(await _apiConsumer.get(EndPoints.tvDetails(id)));

  @override
  Future<List<CastMemberModel>> getTvCredits(int id) async {
    final response = await _apiConsumer.get(EndPoints.tvCredits(id));
    final cast = (response['cast'] as List).cast<Map<String, dynamic>>();
    return cast.take(10).map(CastMemberModel.fromJson).toList();
  }

  @override
  Future<String?> getTvTrailerKey(int id) => _trailerKeyFrom(EndPoints.tvVideos(id));

  @override
  Future<List<MovieModel>> getTvSimilar(int id) => _movieList(EndPoints.tvSimilar(id), mediaType: 'tv');
  @override
  Future<List<MovieModel>> getTvRecommendations(int id) => _movieList(EndPoints.tvRecommendations(id), mediaType: 'tv');

  @override
  Future<SeasonDetailsModel> getSeasonDetails(int tvId, int seasonNumber) async {
    final response = await _apiConsumer.get(EndPoints.tvSeasonDetails(tvId, seasonNumber));
    final episodes = (response['episodes'] as List).cast<Map<String, dynamic>>().map(EpisodeModel.fromJson).toList();
    return SeasonDetailsModel(
      seasonNumber: response['season_number'] as int,
      name: response['name'] as String? ?? 'Season $seasonNumber',
      episodes: episodes,
    );
  }

  @override
  Future<PersonDetailsModel> getPersonDetails(int id) async =>
      PersonDetailsModel.fromJson(await _apiConsumer.get(EndPoints.personDetails(id)));

  @override
  Future<List<MovieModel>> getPersonFilmography(int id) async {
    final response = await _apiConsumer.get(EndPoints.personCombinedCredits(id));
    final cast = (response['cast'] as List).take(20).cast<Map<String, dynamic>>();
    // combined_credits carries its own media_type per item — don't force-override it here.
    return cast.map((json) => MovieModel.fromJson(json)).toList();
  }

  Future<String?> _trailerKeyFrom(String path) async {
    final response = await _apiConsumer.get(path);
    final videos = (response['results'] as List).cast<Map<String, dynamic>>();
    final trailer = videos.firstWhere(
          (v) => v['site'] == 'YouTube' && v['type'] == 'Trailer',
      orElse: () => videos.firstWhere((v) => v['site'] == 'YouTube', orElse: () => const {}),
    );
    return trailer['key'] as String?;
  }

  @override
  Future<WatchProvidersInfoModel?> getMovieWatchProviders(int id, String region) =>
      _watchProviders(EndPoints.movieWatchProviders(id), region);

  @override
  Future<WatchProvidersInfoModel?> getTvWatchProviders(int id, String region) =>
      _watchProviders(EndPoints.tvWatchProviders(id), region);

  Future<WatchProvidersInfoModel?> _watchProviders(String path, String region) async {
    final response = await _apiConsumer.get(path);
    final results = response['results'] as Map<String, dynamic>?;
    final regionData = results?[region] as Map<String, dynamic>?;
    if (regionData == null) return null;
    return WatchProvidersInfoModel.fromJson(regionData);
  }

  Future<List<MovieModel>> _movieList(String path, {String? mediaType}) async {
    final response = await _apiConsumer.get(path);
    final results = (response['results'] as List).cast<Map<String, dynamic>>();
    return results.map((json) => MovieModel.fromJson(json, mediaType: mediaType)).toList();
  }
}
