import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';
import 'package:movix/features/details/domain/entities/person_bundle.dart';
import 'package:movix/features/details/domain/repositories/details_repository.dart';
import 'package:movix/features/home/domain/entities/movie.dart';

import '../entities/person_details.dart';

class GetPersonBundle implements UseCase<PersonBundle, int> {
  const GetPersonBundle(this._repository);
  final DetailsRepository _repository;
  @override
  Future<Either<GenericException, PersonBundle>> call(int personId) async {
    final results = await Future.wait([
      _repository.getPersonDetails(personId),
      _repository.getPersonFilmography(personId),
    ]);
    if (results[0].isLeft()) return Left(results[0].swap().getOrElse(() => const GenericException(message: '')));

    return Right(PersonBundle(
      details: results[0].getOrElse(() => throw StateError('unreachable')) as PersonDetails,
      filmography: results[1].getOrElse(() => const <Movie>[]) as List<Movie>,
    ));
  }
}