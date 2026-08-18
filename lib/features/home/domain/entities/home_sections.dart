import 'package:equatable/equatable.dart';

import 'movie.dart';

class HomeSections extends Equatable {
  const HomeSections({
    required this.heroTrending,
    required this.trending,
    required this.popular,
    required this.topRated,
    required this.upcoming,
    required this.nowPlaying,
    required this.popularTv,
  });

  final List<Movie> heroTrending;
  final List<Movie> trending;
  final List<Movie> popular;
  final List<Movie> topRated;
  final List<Movie> upcoming;
  final List<Movie> nowPlaying;
  final List<Movie> popularTv;

  @override
  List<Object?> get props =>
      [heroTrending, trending, popular, topRated, upcoming, nowPlaying, popularTv];
}