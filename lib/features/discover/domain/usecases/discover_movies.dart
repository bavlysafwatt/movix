import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';

import '../entities/discover_filters.dart';
import '../entities/discover_page.dart';
import '../repositories/discover_repository.dart';

class DiscoverMoviesParams extends Equatable {
  const DiscoverMoviesParams({required this.filters, required this.page});
  final DiscoverFilters filters;
  final int page;
  @override
  List<Object?> get props => [filters, page];
}

class DiscoverMovies implements UseCase<DiscoverPage, DiscoverMoviesParams> {
  const DiscoverMovies(this._repository);
  final DiscoverRepository _repository;
  @override
  Future<Either<GenericException, DiscoverPage>> call(DiscoverMoviesParams params) =>
      _repository.discoverMovies(filters: params.filters, page: params.page);
}