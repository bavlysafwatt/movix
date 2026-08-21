import 'package:equatable/equatable.dart';
import 'package:movix/features/discover/domain/entities/genre.dart';

class SeasonSummary extends Equatable {
  const SeasonSummary({
    required this.seasonNumber,
    required this.name,
    required this.episodeCount,
    this.posterPath,
  });
  final int seasonNumber;
  final String name;
  final int episodeCount;
  final String? posterPath;
  @override
  List<Object?> get props => [seasonNumber, name, episodeCount, posterPath];
}

class TvDetails extends Equatable {
  const TvDetails({
    required this.id,
    required this.name,
    this.tagline,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.genres = const [],
    this.episodeRuntime,
    this.firstAirDate,
    this.voteAverage,
    this.numberOfSeasons,
    this.seasons = const [],
  });

  final int id;
  final String name;
  final String? tagline;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final List<Genre> genres;
  final int? episodeRuntime;
  final String? firstAirDate;
  final double? voteAverage;
  final int? numberOfSeasons;
  final List<SeasonSummary> seasons;

  @override
  List<Object?> get props => [
    id, name, tagline, overview, posterPath, backdropPath, genres,
    episodeRuntime, firstAirDate, voteAverage, numberOfSeasons, seasons,
  ];
}