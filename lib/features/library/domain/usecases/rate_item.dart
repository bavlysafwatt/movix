import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/usecase/usecase.dart';
import 'package:movix/features/library/domain/entities/library_rated_item.dart';
import '../repositories/library_repository.dart';


class RateItem implements UseCase<void, LibraryRatedItem> {
  const RateItem(this._repository);
  final LibraryRepository _repository;
  @override
  Future<Either<GenericException, void>> call(LibraryRatedItem item) =>
      _repository.rateItem(item);
}