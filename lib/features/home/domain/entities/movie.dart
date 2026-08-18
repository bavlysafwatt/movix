import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  const Movie({
    required this.id,
    required this.title,
    required this.mediaType,
    this.posterPath,
    this.backdropPath,
    this.overview,
    this.voteAverage,
    this.releaseDate,
  });

  final int id;
  final String title;
  final String mediaType; // 'movie' or 'tv'
  final String? posterPath;
  final String? backdropPath;
  final String? overview;
  final double? voteAverage;
  final String? releaseDate;

  @override
  List<Object?> get props => [
    id,
    title,
    mediaType,
    posterPath,
    backdropPath,
    overview,
    voteAverage,
    releaseDate,
  ];
}