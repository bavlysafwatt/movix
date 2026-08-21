import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/features/details/domain/entities/cast_member.dart';
import 'package:movix/features/details/domain/entities/episode.dart';
import 'package:movix/features/details/domain/entities/movie_details.dart';
import 'package:movix/features/details/domain/entities/tv_details.dart';
import 'package:movix/features/details/domain/entities/watch_providers.dart';
import 'package:movix/features/home/domain/entities/movie.dart';

import '../entities/person_details.dart';


abstract class DetailsRepository {
  // Movie
  Future<Either<GenericException, MovieDetails>> getMovieDetails(int id);
  Future<Either<GenericException, List<CastMember>>> getMovieCredits(int id);
  Future<Either<GenericException, String?>> getMovieTrailerKey(int id);
  Future<Either<GenericException, List<Movie>>> getMovieSimilar(int id);
  Future<Either<GenericException, List<Movie>>> getMovieRecommendations(int id);
  Future<Either<GenericException, WatchProvidersInfo?>> getMovieWatchProviders(int id, String region);

  // TV
  Future<Either<GenericException, TvDetails>> getTvDetails(int id);
  Future<Either<GenericException, List<CastMember>>> getTvCredits(int id);
  Future<Either<GenericException, String?>> getTvTrailerKey(int id);
  Future<Either<GenericException, List<Movie>>> getTvSimilar(int id);
  Future<Either<GenericException, List<Movie>>> getTvRecommendations(int id);
  Future<Either<GenericException, SeasonDetails>> getSeasonDetails(int tvId, int seasonNumber);
  Future<Either<GenericException, WatchProvidersInfo?>> getTvWatchProviders(int id, String region);

  // Person
  Future<Either<GenericException, PersonDetails>> getPersonDetails(int id);
  Future<Either<GenericException, List<Movie>>> getPersonFilmography(int id);
}