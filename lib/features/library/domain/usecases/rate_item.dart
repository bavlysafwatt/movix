import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';

import '../repositories/library_repository.dart';

class RateItemParams extends Equatable {
  const RateItemParams({required this.tmdbId, required this.mediaType, required this.rating});
  final int tmdbId;
  final String mediaType;
  final double rating;
  @override
  List<Object?> get props => [tmdbId, mediaType, rating];
}

class RateItem implements UseCase<void, RateItemParams> {
  const RateItem(this._repository);
  final LibraryRepository _repository;
  @override
  Future<Either<GenericException, void>> call(RateItemParams params) =>
      _repository.rateItem(tmdbId: params.tmdbId, mediaType: params.mediaType, rating: params.rating);
}