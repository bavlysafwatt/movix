import 'package:equatable/equatable.dart';
import 'package:movix/features/home/domain/entities/movie.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial({this.recentSearches = const []});
  final List<String> recentSearches;
  @override
  List<Object?> get props => [recentSearches];
}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  const SearchSuccess({required this.results});
  final List<Movie> results;
  @override
  List<Object?> get props => [results];
}

class SearchEmpty extends SearchState {}

class SearchError extends SearchState {
  const SearchError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}