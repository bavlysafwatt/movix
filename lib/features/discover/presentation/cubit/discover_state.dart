import 'package:equatable/equatable.dart';
import 'package:movix/features/discover/domain/entities/discover_filters.dart';
import 'package:movix/features/home/domain/entities/movie.dart';

abstract class DiscoverState extends Equatable {
  const DiscoverState();
  @override
  List<Object?> get props => [];
}

class DiscoverInitial extends DiscoverState {}
class DiscoverLoading extends DiscoverState {}

class DiscoverError extends DiscoverState {
  const DiscoverError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}

class DiscoverLoaded extends DiscoverState {
  const DiscoverLoaded({
    required this.movies,
    required this.filters,
    required this.page,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  final List<Movie> movies;
  final DiscoverFilters filters;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  DiscoverLoaded copyWith({
    List<Movie>? movies,
    DiscoverFilters? filters,
    int? page,
    bool? hasMore,
    bool isLoadingMore = false,
  }) {
    return DiscoverLoaded(
      movies: movies ?? this.movies,
      filters: filters ?? this.filters,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [movies, filters, page, hasMore, isLoadingMore];
}