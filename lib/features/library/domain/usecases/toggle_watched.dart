import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';

import '../repositories/library_repository.dart';

class ToggleWatchedParams extends Equatable {
  const ToggleWatchedParams({required this.tmdbId, required this.mediaType, required this.watched});
  final int tmdbId;
  final String mediaType;
  final bool watched;
  @override
  List<Object?> get props => [tmdbId, mediaType, watched];
}

class ToggleWatched implements UseCase<void, ToggleWatchedParams> {
  const ToggleWatched(this._repository);
  final LibraryRepository _repository;
  @override
  Future<Either<GenericException, void>> call(ToggleWatchedParams params) =>
      _repository.toggleWatched(tmdbId: params.tmdbId, mediaType: params.mediaType, watched: params.watched);
}