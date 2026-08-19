import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/utils/app_strings.dart';
import 'package:movix/features/home/domain/entities/movie.dart';

import '../../domain/entities/search_filter.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_local_data_source.dart';
import '../datasources/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  const SearchRepositoryImpl(this._remote, this._local);
  final SearchRemoteDataSource _remote;
  final SearchLocalDataSource _local;

  @override
  Future<Either<GenericException, List<Movie>>> search(String query, SearchFilter filter) async {
    try {
      return Right(await _remote.search(query, filter));
    } on GenericException catch (exception) {
      return Left(exception);
    } catch (_) {
      return const Left(GenericException(message: AppStrings.unexpectedError));
    }
  }

  @override
  Future<List<String>> getRecentSearches() => _local.getRecentSearches();
  @override
  Future<void> saveRecentSearch(String query) => _local.saveRecentSearch(query);
  @override
  Future<void> clearRecentSearches() => _local.clearRecentSearches();
}