import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';
import 'package:movix/features/library/domain/entities/library_item.dart';
import 'package:movix/features/library/domain/repositories/library_repository.dart';

class GetWatchedHistory implements UseCase<List<LibraryItem>, NoParams> {
  const GetWatchedHistory(this._repository);
  final LibraryRepository _repository;
  @override
  Future<Either<GenericException, List<LibraryItem>>> call(NoParams params) => _repository.getWatchedHistory();
}