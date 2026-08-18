import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';

import '../entities/movie.dart';

abstract class HomeRepository {
  Future<Either<GenericException, List<Movie>>> getTrendingWeek();
  Future<Either<GenericException, List<Movie>>> getTrendingDay();
  Future<Either<GenericException, List<Movie>>> getPopular();
  Future<Either<GenericException, List<Movie>>> getTopRated();
  Future<Either<GenericException, List<Movie>>> getUpcoming();
  Future<Either<GenericException, List<Movie>>> getNowPlaying();
  Future<Either<GenericException, List<Movie>>> getPopularTv();
}