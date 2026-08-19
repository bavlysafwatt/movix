import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';

import '../entities/discover_filters.dart';
import '../entities/discover_page.dart';
import '../entities/genre.dart';

abstract class DiscoverRepository {
  Future<Either<GenericException, List<Genre>>> getGenres();
  Future<Either<GenericException, DiscoverPage>> discoverMovies({
    required DiscoverFilters filters,
    required int page,
  });
}