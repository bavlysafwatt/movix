import 'package:equatable/equatable.dart';
import 'package:movix/features/details/domain/entities/cast_member.dart';
import 'package:movix/features/details/domain/entities/tv_details.dart';
import 'package:movix/features/details/domain/entities/watch_providers.dart';
import 'package:movix/features/home/domain/entities/movie.dart';
import 'package:movix/features/library/domain/entities/library_item_status.dart';

abstract class TvDetailsState extends Equatable {
  const TvDetailsState();
  @override
  List<Object?> get props => [];
}

class TvDetailsInitial extends TvDetailsState {}
class TvDetailsLoading extends TvDetailsState {}

class TvDetailsError extends TvDetailsState {
  const TvDetailsError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}

class TvDetailsLoaded extends TvDetailsState {
  const TvDetailsLoaded({
    required this.details,
    required this.cast,
    this.trailerKey,
    required this.similar,
    required this.recommendations,
    this.watchProviders,
    this.status = const LibraryItemStatus(),
    this.isUpdatingFavorite = false,
    this.isUpdatingWatchlist = false,
    this.isUpdatingWatched = false,
    this.isSubmittingRating = false,
  });

  final TvDetails details;
  final List<CastMember> cast;
  final String? trailerKey;
  final List<Movie> similar;
  final List<Movie> recommendations;
  final WatchProvidersInfo? watchProviders;
  final LibraryItemStatus status;
  final bool isUpdatingFavorite;
  final bool isUpdatingWatchlist;
  final bool isUpdatingWatched;
  final bool isSubmittingRating;

  TvDetailsLoaded copyWith({
    LibraryItemStatus? status,
    bool? isUpdatingFavorite,
    bool? isUpdatingWatchlist,
    bool? isUpdatingWatched,
    bool? isSubmittingRating,
  }) {
    return TvDetailsLoaded(
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
    details, cast, trailerKey, similar, recommendations,
    status, isUpdatingFavorite, isUpdatingWatchlist, isUpdatingWatched, isSubmittingRating,
  ];
}