import 'package:equatable/equatable.dart';

class Episode extends Equatable {
  const Episode({
    required this.episodeNumber,
    required this.name,
    this.overview,
    this.stillPath,
    this.airDate,
    this.voteAverage,
  });
  final int episodeNumber;
  final String name;
  final String? overview;
  final String? stillPath;
  final String? airDate;
  final double? voteAverage;
  @override
  List<Object?> get props => [episodeNumber, name, overview, stillPath, airDate, voteAverage];
}

class SeasonDetails extends Equatable {
  const SeasonDetails({required this.seasonNumber, required this.name, required this.episodes});
  final int seasonNumber;
  final String name;
  final List<Episode> episodes;
  @override
  List<Object?> get props => [seasonNumber, name, episodes];
}