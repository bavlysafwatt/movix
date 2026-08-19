import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/features/home/domain/entities/movie.dart';
import 'package:movix/features/search/domain/entities/search_filter.dart';


abstract class SearchRepository {
  Future<Either<GenericException, List<Movie>>> search(String query, SearchFilter filter);
  Future<List<String>> getRecentSearches();
  Future<void> saveRecentSearch(String query);
  Future<void> clearRecentSearches();
}