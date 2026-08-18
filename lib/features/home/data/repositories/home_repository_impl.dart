import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/utils/app_strings.dart';

import '../../domain/entities/movie.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._remoteDataSource);
  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<Either<GenericException, List<Movie>>> getTrendingWeek() => _run(_remoteDataSource.getTrendingWeek);

  @override
  Future<Either<GenericException, List<Movie>>> getTrendingDay() => _run(_remoteDataSource.getTrendingDay);

  @override
  Future<Either<GenericException, List<Movie>>> getPopular() => _run(_remoteDataSource.getPopular);

  @override
  Future<Either<GenericException, List<Movie>>> getTopRated() => _run(_remoteDataSource.getTopRated);

  @override
  Future<Either<GenericException, List<Movie>>> getUpcoming() => _run(_remoteDataSource.getUpcoming);

  @override
  Future<Either<GenericException, List<Movie>>> getNowPlaying() => _run(_remoteDataSource.getNowPlaying);

  @override
  Future<Either<GenericException, List<Movie>>> getPopularTv() => _run(_remoteDataSource.getPopularTv);


  Future<Either<GenericException, List<Movie>>> _run(Future<List<Movie>> Function() call) async {
    try {
      return Right(await call());
    } on GenericException catch (exception) {
      return Left(exception);
    } catch (_) {
      return const Left(GenericException(message: AppStrings.unexpectedError));
    }
  }
}