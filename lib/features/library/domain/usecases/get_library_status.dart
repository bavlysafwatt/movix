import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';

import '../entities/library_item_status.dart';
import '../repositories/library_repository.dart';

class LibraryStatusParams extends Equatable {
  const LibraryStatusParams({required this.tmdbId, required this.mediaType});
  final int tmdbId;
  final String mediaType;
  @override
  List<Object?> get props => [tmdbId, mediaType];
}

class GetLibraryStatus implements UseCase<LibraryItemStatus, LibraryStatusParams> {
  const GetLibraryStatus(this._repository);
  final LibraryRepository _repository;
  @override
  Future<Either<GenericException, LibraryItemStatus>> call(LibraryStatusParams params) =>
      _repository.getStatus(tmdbId: params.tmdbId, mediaType: params.mediaType);
}