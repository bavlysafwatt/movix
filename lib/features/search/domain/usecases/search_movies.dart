import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';
import 'package:movix/features/home/domain/entities/movie.dart';

import '../entities/search_filter.dart';
import '../repositories/search_repository.dart';

class SearchParams extends Equatable {
  const SearchParams({required this.query, required this.filter});
  final String query;
  final SearchFilter filter;
  @override
  List<Object?> get props => [query, filter];
}

class SearchMovies implements UseCase<List<Movie>, SearchParams> {
  const SearchMovies(this._repository);
  final SearchRepository _repository;
  @override
  Future<Either<GenericException, List<Movie>>> call(SearchParams params) =>
      _repository.search(params.query, params.filter);
}