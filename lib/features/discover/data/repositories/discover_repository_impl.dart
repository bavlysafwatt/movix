import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/utils/app_strings.dart';

import '../../domain/entities/discover_filters.dart';
import '../../domain/entities/discover_page.dart';
import '../../domain/entities/genre.dart';
import '../../domain/repositories/discover_repository.dart';
import '../datasources/discover_remote_data_source.dart';

class DiscoverRepositoryImpl implements DiscoverRepository {
  const DiscoverRepositoryImpl(this._remoteDataSource);
  final DiscoverRemoteDataSource _remoteDataSource;

  @override
  Future<Either<GenericException, List<Genre>>> getGenres() =>
      _run(() => _remoteDataSource.getGenres());

  @override
  Future<Either<GenericException, DiscoverPage>> discoverMovies({
    required DiscoverFilters filters,
    required int page,
  }) {
    return _run(() async {
      final result = await _remoteDataSource.discoverMovies(filters: filters, page: page);
      return DiscoverPage(movies: result.movies, page: result.page, totalPages: result.totalPages);
    });
  }

  Future<Either<GenericException, T>> _run<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on GenericException catch (exception) {
      return Left(exception);
    } catch (_) {
      return const Left(GenericException(message: AppStrings.unexpectedError));
    }
  }
}