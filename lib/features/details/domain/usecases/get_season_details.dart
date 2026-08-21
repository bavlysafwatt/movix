import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';
import 'package:movix/features/details/domain/entities/episode.dart';
import 'package:movix/features/details/domain/repositories/details_repository.dart';

class GetSeasonDetails implements UseCase<SeasonDetails, ({int tvId, int seasonNumber})> {
  const GetSeasonDetails(this._repository);
  final DetailsRepository _repository;
  @override
  Future<Either<GenericException, SeasonDetails>> call(({int tvId, int seasonNumber}) params) =>
      _repository.getSeasonDetails(params.tvId, params.seasonNumber);
}