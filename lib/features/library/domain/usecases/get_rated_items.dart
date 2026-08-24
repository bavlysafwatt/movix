import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';
import 'package:movix/features/library/domain/entities/library_rated_item.dart';
import 'package:movix/features/library/domain/repositories/library_repository.dart';

class GetRatedItems implements UseCase<List<LibraryRatedItem>, NoParams> {
  const GetRatedItems(this._repository);
  final LibraryRepository _repository;
  @override
  Future<Either<GenericException, List<LibraryRatedItem>>> call(NoParams params) => _repository.getRatedItems();
}