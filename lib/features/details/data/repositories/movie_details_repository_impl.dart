import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/utils/app_strings.dart';
import 'package:movix/features/details/domain/entities/episode.dart';
import 'package:movix/features/details/domain/entities/person_details.dart';
import 'package:movix/features/details/domain/entities/tv_details.dart';
import 'package:movix/features/details/domain/entities/watch_providers.dart';
import 'package:movix/features/home/domain/entities/movie.dart';

import '../../domain/entities/cast_member.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/repositories/details_repository.dart';
import '../datasources/details_remote_data_source.dart';

class DetailsRepositoryImpl implements DetailsRepository {
  const DetailsRepositoryImpl(this._remote);
  final DetailsRemoteDataSource _remote;

  Future<Either<GenericException, T>> _run<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on GenericException catch (e) {
      return Left(e);
    } catch (_) {
      return const Left(GenericException(message: AppStrings.unexpectedError));
    }
  }

  @override
  Future<Either<GenericException, List<CastMember>>> getMovieCredits(int id) => _run(() => _remote.getMovieCredits(id));

  @override
  Future<Either<GenericException, MovieDetails>> getMovieDetails(int id) => _run(() => _remote.getMovieDetails(id));

  @override
  Future<Either<GenericException, List<Movie>>> getMovieRecommendations(int id) => _run(() => _remote.getMovieRecommendations(id));

  @override
  Future<Either<GenericException, List<Movie>>> getMovieSimilar(int id) => _run(() => _remote.getMovieSimilar(id));

  @override
  Future<Either<GenericException, String?>> getMovieTrailerKey(int id) => _run(() => _remote.getMovieTrailerKey(id));

  @override
  Future<Either<GenericException, PersonDetails>> getPersonDetails(int id) => _run(() => _remote.getPersonDetails(id));

  @override
  Future<Either<GenericException, List<Movie>>> getPersonFilmography(int id) => _run(() => _remote.getPersonFilmography(id));

  @override
  Future<Either<GenericException, SeasonDetails>> getSeasonDetails(int tvId, int seasonNumber) => _run(() => _remote.getSeasonDetails(tvId, seasonNumber));

  @override
  Future<Either<GenericException, List<CastMember>>> getTvCredits(int id) => _run(() => _remote.getTvCredits(id));

  @override
  Future<Either<GenericException, TvDetails>> getTvDetails(int id) => _run(() => _remote.getTvDetails(id));

  @override
  Future<Either<GenericException, List<Movie>>> getTvRecommendations(int id) => _run(() => _remote.getTvRecommendations(id));

  @override
  Future<Either<GenericException, List<Movie>>> getTvSimilar(int id) => _run(() => _remote.getTvSimilar(id));

  @override
  Future<Either<GenericException, String?>> getTvTrailerKey(int id) => _run(() => _remote.getTvTrailerKey(id));

  @override
  Future<Either<GenericException, WatchProvidersInfo?>> getMovieWatchProviders(int id, String region) =>
      _run(() => _remote.getMovieWatchProviders(id, region));

  @override
  Future<Either<GenericException, WatchProvidersInfo?>> getTvWatchProviders(int id, String region) =>
      _run(() => _remote.getTvWatchProviders(id, region));
}