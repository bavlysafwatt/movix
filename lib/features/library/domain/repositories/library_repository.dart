import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';

import '../entities/library_item.dart';
import '../entities/library_item_status.dart';

abstract class LibraryRepository {
  Future<Either<GenericException, LibraryItemStatus>> getStatus({
    required int tmdbId,
    required String mediaType,
  });
  Future<Either<GenericException, void>> toggleFavorite(LibraryItem item, {required bool add});
  Future<Either<GenericException, void>> toggleWatchlist(LibraryItem item, {required bool add});
  Future<Either<GenericException, void>> toggleWatched({
    required int tmdbId,
    required String mediaType,
    required bool watched,
  });
  Future<Either<GenericException, void>> rateItem({
    required int tmdbId,
    required String mediaType,
    required double rating,
  });
}