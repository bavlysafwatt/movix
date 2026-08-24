import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';
import 'package:movix/features/library/domain/entities/library_item.dart';
import 'package:movix/features/library/domain/repositories/library_repository.dart';

class GetWatchlist implements UseCase<List<LibraryItem>, NoParams> {
  const GetWatchlist(this._repository);
  final LibraryRepository _repository;
  @override
  Future<Either<GenericException, List<LibraryItem>>> call(NoParams params) => _repository.getWatchlist();
}