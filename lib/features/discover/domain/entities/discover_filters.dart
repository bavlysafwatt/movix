import 'package:equatable/equatable.dart';

import 'genre.dart';

enum DiscoverSort { popularityDesc, ratingDesc, releaseDateDesc, titleAsc }

extension DiscoverSortValues on DiscoverSort {
  String get apiValue => switch (this) {
    DiscoverSort.popularityDesc => 'popularity.desc',
    DiscoverSort.ratingDesc => 'vote_average.desc',
    DiscoverSort.releaseDateDesc => 'primary_release_date.desc',
    DiscoverSort.titleAsc => 'original_title.asc',
  };

  String get label => switch (this) {
    DiscoverSort.popularityDesc => 'Most Popular',
    DiscoverSort.ratingDesc => 'Highest Rated',
    DiscoverSort.releaseDateDesc => 'Newest',
    DiscoverSort.titleAsc => 'A–Z',
  };
}

class DiscoverFilters extends Equatable {
  const DiscoverFilters({this.genre, this.year, this.minRating, this.sort = DiscoverSort.popularityDesc});

  final Genre? genre;
  final int? year;
  final double? minRating;
  final DiscoverSort sort;

  bool get hasActiveFilters => genre != null || year != null || minRating != null;

  DiscoverFilters copyWith({
    Genre? genre,
    bool clearGenre = false,
    int? year,
    bool clearYear = false,
    double? minRating,
    bool clearMinRating = false,
    DiscoverSort? sort,
  }) {
    return DiscoverFilters(
      genre: clearGenre ? null : (genre ?? this.genre),
      year: clearYear ? null : (year ?? this.year),
      minRating: clearMinRating ? null : (minRating ?? this.minRating),
      sort: sort ?? this.sort,
    );
  }

  @override
  List<Object?> get props => [genre, year, minRating, sort];
}