import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';
import '../entities/library_item.dart';
import '../repositories/library_repository.dart';

class ToggleWatchedParams extends Equatable {
  const ToggleWatchedParams({required this.item, required this.watched});
  final LibraryItem item;
  final bool watched;
  @override
  List<Object?> get props => [item.tmdbId, item.mediaType, watched];
}

class ToggleWatched implements UseCase<void, ToggleWatchedParams> {
  const ToggleWatched(this._repository);
  final LibraryRepository _repository;
  @override
  Future<Either<GenericException, void>> call(ToggleWatchedParams params) =>
      _repository.toggleWatched(params.item, watched: params.watched);
}