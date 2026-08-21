import 'package:equatable/equatable.dart';
import 'package:movix/features/details/domain/entities/watch_providers.dart';
import 'package:movix/features/home/domain/entities/movie.dart';
import 'package:movix/features/library/domain/entities/library_item_status.dart';
import 'package:movix/features/details/domain/entities/cast_member.dart';
import 'package:movix/features/details/domain/entities/movie_details.dart';

abstract class MovieDetailsState extends Equatable {
  const MovieDetailsState();
  @override
  List<Object?> get props => [];
}

class MovieDetailsInitial extends MovieDetailsState {}
class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsError extends MovieDetailsState {
  const MovieDetailsError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}

class MovieDetailsLoaded extends MovieDetailsState {
  const MovieDetailsLoaded({
    required this.details,
    required this.cast,
    this.trailerKey,
    required this.similar,
    required this.recommendations,
    required this.watchProviders,
    this.status = const LibraryItemStatus(),
    this.isUpdatingFavorite = false,
    this.isUpdatingWatchlist = false,
    this.isUpdatingWatched = false,
    this.isSubmittingRating = false,
  });

  final MovieDetails details;
  final List<CastMember> cast;
  final String? trailerKey;
  final List<Movie> similar;
  final List<Movie> recommendations;
  final LibraryItemStatus status;
  final WatchProvidersInfo? watchProviders;
  final bool isUpdatingFavorite;
  final bool isUpdatingWatchlist;
  final bool isUpdatingWatched;
  final bool isSubmittingRating;

  MovieDetailsLoaded copyWith({
    LibraryItemStatus? status,
    WatchProvidersInfo? watchProviders,
    bool? isUpdatingFavorite,
    bool? isUpdatingWatchlist,
    bool? isUpdatingWatched,
    bool? isSubmittingRating,
  }) {
    return MovieDetailsLoaded(
      details: details,
      cast: cast,
      trailerKey: trailerKey,
      similar: similar,
      recommendations: recommendations,
      watchProviders: watchProviders ?? this.watchProviders,
      status: status ?? this.status,
      isUpdatingFavorite: isUpdatingFavorite ?? false,
      isUpdatingWatchlist: isUpdatingWatchlist ?? false,
      isUpdatingWatched: isUpdatingWatched ?? false,
      isSubmittingRating: isSubmittingRating ?? false,
    );
  }

  @override
  List<Object?> get props => [
    details, cast, trailerKey, similar, recommendations, watchProviders,
    status, isUpdatingFavorite, isUpdatingWatchlist, isUpdatingWatched, isSubmittingRating,
  ];
}