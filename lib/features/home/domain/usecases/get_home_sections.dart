import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';

import '../entities/home_sections.dart';
import '../entities/movie.dart';
import '../repositories/home_repository.dart';

class GetHomeSections implements UseCase<HomeSections, NoParams> {
  const GetHomeSections(this._repository);
  final HomeRepository _repository;

  @override
  Future<Either<GenericException, HomeSections>> call(NoParams params) async {
    final results = await Future.wait([
      _repository.getTrendingWeek(),
      _repository.getTrendingDay(),
      _repository.getPopular(),
      _repository.getTopRated(),
      _repository.getUpcoming(),
      _repository.getNowPlaying(),
      _repository.getPopularTv(),
    ]);

    for (final result in results) {
      if (result.isLeft()) {
        return Left(result.swap().getOrElse(() => const GenericException(message: '')));
      }
    }

    List<Movie> unwrap(Either<GenericException, List<Movie>> either) =>
        either.getOrElse(() => const []);

    return Right(
      HomeSections(
        heroTrending: unwrap(results[0]),
        trending: unwrap(results[1]),
        popular: unwrap(results[2]),
        topRated: unwrap(results[3]),
        upcoming: unwrap(results[4]),
        nowPlaying: unwrap(results[5]),
        popularTv: unwrap(results[6]),
      ),
    );
  }
}