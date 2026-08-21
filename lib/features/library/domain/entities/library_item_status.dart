import 'package:equatable/equatable.dart';

class LibraryItemStatus extends Equatable {
  const LibraryItemStatus({
    this.isFavorite = false,
    this.isInWatchlist = false,
    this.isWatched = false,
    this.userRating,
  });

  final bool isFavorite;
  final bool isInWatchlist;
  final bool isWatched;
  final double? userRating;

  LibraryItemStatus copyWith({
    bool? isFavorite,
    bool? isInWatchlist,
    bool? isWatched,
    double? userRating,
  }) {
    return LibraryItemStatus(
      isFavorite: isFavorite ?? this.isFavorite,
      isInWatchlist: isInWatchlist ?? this.isInWatchlist,
      isWatched: isWatched ?? this.isWatched,
      userRating: userRating ?? this.userRating,
    );
  }

  @override
  List<Object?> get props => [isFavorite, isInWatchlist, isWatched, userRating];
}