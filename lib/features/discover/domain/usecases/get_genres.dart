import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';

import '../entities/genre.dart';
import '../repositories/discover_repository.dart';

class GetGenres implements UseCase<List<Genre>, NoParams> {
  const GetGenres(this._repository);
  final DiscoverRepository _repository;
  @override
  Future<Either<GenericException, List<Genre>>> call(NoParams params) => _repository.getGenres();
}