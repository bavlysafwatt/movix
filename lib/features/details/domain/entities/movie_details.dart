import 'package:equatable/equatable.dart';
import 'package:movix/features/discover/domain/entities/genre.dart';

class MovieDetails extends Equatable {
  const MovieDetails({
    required this.id,
    required this.title,
    this.tagline,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.genres = const [],
    this.runtime,
    this.releaseDate,
    this.voteAverage,
  });

  final int id;
  final String title;
  final String? tagline;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final List<Genre> genres;
  final int? runtime;
  final String? releaseDate;
  final double? voteAverage;

  @override
  List<Object?> get props =>
      [id, title, tagline, overview, posterPath, backdropPath, genres, runtime, releaseDate, voteAverage];
}