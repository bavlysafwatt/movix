import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';

import '../repositories/search_repository.dart';

class GetRecentSearches implements UseCase<List<String>, NoParams> {
  const GetRecentSearches(this._repository);
  final SearchRepository _repository;
  @override
  Future<Either<GenericException, List<String>>> call(NoParams params) async =>
      Right(await _repository.getRecentSearches());
}

class SaveRecentSearch implements UseCase<void, String> {
  const SaveRecentSearch(this._repository);
  final SearchRepository _repository;
  @override
  Future<Either<GenericException, void>> call(String query) async {
    await _repository.saveRecentSearch(query);
    return const Right(null);
  }
}

class ClearRecentSearches implements UseCase<void, NoParams> {
  const ClearRecentSearches(this._repository);
  final SearchRepository _repository;
  @override
  Future<Either<GenericException, void>> call(NoParams params) async {
    await _repository.clearRecentSearches();
    return const Right(null);
  }
}