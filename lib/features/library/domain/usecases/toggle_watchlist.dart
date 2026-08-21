import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';

import '../entities/library_item.dart';
import '../repositories/library_repository.dart';

class ToggleWatchlistParams extends Equatable {
  const ToggleWatchlistParams({required this.item, required this.add});
  final LibraryItem item;
  final bool add;
  @override
  List<Object?> get props => [item.tmdbId, item.mediaType, add];
}

class ToggleWatchlist implements UseCase<void, ToggleWatchlistParams> {
  const ToggleWatchlist(this._repository);
  final LibraryRepository _repository;
  @override
  Future<Either<GenericException, void>> call(ToggleWatchlistParams params) =>
      _repository.toggleWatchlist(params.item, add: params.add);
}