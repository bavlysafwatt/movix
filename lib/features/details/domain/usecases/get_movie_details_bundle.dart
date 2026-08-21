import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';
import 'package:movix/features/details/domain/entities/cast_member.dart';
import 'package:movix/features/details/domain/entities/movie_details.dart';
import 'package:movix/features/details/domain/entities/watch_providers.dart';
import 'package:movix/features/home/domain/entities/movie.dart';

import '../entities/movie_details_bundle.dart';
import '../repositories/details_repository.dart';

class MovieDetailsParams extends Equatable {
  const MovieDetailsParams({required this.movieId, required this.region});
  final int movieId;
  final String region;
  @override
  List<Object?> get props => [movieId, region];
}

class GetMovieDetailsBundle implements UseCase<MovieDetailsBundle, MovieDetailsParams> {
  const GetMovieDetailsBundle(this._repository);
  final DetailsRepository _repository;

  @override
  Future<Either<GenericException, MovieDetailsBundle>> call(MovieDetailsParams params) async {
    final results = await Future.wait([
      _repository.getMovieDetails(params.movieId),
      _repository.getMovieCredits(params.movieId),
      _repository.getMovieTrailerKey(params.movieId),
      _repository.getMovieSimilar(params.movieId),
      _repository.getMovieRecommendations(params.movieId),
      _repository.getMovieWatchProviders(params.movieId, params.region),
    ]);

    for (final result in results) {
      if (result.isLeft()) {
        return Left(result.swap().getOrElse(() => const GenericException(message: '')));
      }
    }

    return Right(MovieDetailsBundle(
      details: results[0].getOrElse(() => throw StateError('unreachable')) as MovieDetails,
      cast: results[1].getOrElse(() => const <CastMember>[]) as List<CastMember>,
      trailerKey: results[2].getOrElse(() => null) as String?,
      similar: results[3].getOrElse(() => const <Movie>[]) as List<Movie>,
      recommendations: results[4].getOrElse(() => const <Movie>[]) as List<Movie>,
      watchProviders: results[5].getOrElse(() => null) as WatchProvidersInfo?,
    ));
  }
}