import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';
import 'package:movix/features/details/domain/entities/cast_member.dart';
import 'package:movix/features/details/domain/entities/tv_details.dart';
import 'package:movix/features/details/domain/entities/tv_details_bundle.dart';
import 'package:movix/features/details/domain/entities/watch_providers.dart';
import 'package:movix/features/home/domain/entities/movie.dart';

import '../repositories/details_repository.dart';

class TvDetailsParams extends Equatable {
  const TvDetailsParams({required this.tvId, required this.region});
  final int tvId;
  final String region;
  @override
  List<Object?> get props => [tvId, region];
}

class GetTvDetailsBundle implements UseCase<TvDetailsBundle, TvDetailsParams> {
  const GetTvDetailsBundle(this._repository);
  final DetailsRepository _repository;

  @override
  Future<Either<GenericException, TvDetailsBundle>> call(TvDetailsParams params) async {
    final results = await Future.wait([
      _repository.getTvDetails(params.tvId),
      _repository.getTvCredits(params.tvId),
      _repository.getTvTrailerKey(params.tvId),
      _repository.getTvSimilar(params.tvId),
      _repository.getTvRecommendations(params.tvId),
      _repository.getTvWatchProviders(params.tvId, params.region),
    ]);

    for (final result in results) {
      if (result.isLeft()) {
        return Left(result.swap().getOrElse(() => const GenericException(message: '')));
      }
    }

    return Right(TvDetailsBundle(
      details: results[0].getOrElse(() => throw StateError('unreachable')) as TvDetails,
      cast: results[1].getOrElse(() => const <CastMember>[]) as List<CastMember>,
      trailerKey: results[2].getOrElse(() => null) as String?,
      similar: results[3].getOrElse(() => const <Movie>[]) as List<Movie>,
      recommendations: results[4].getOrElse(() => const <Movie>[]) as List<Movie>,
      watchProviders: results[5].getOrElse(() => null) as WatchProvidersInfo?,
    ));
  }
}