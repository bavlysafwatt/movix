

import 'package:movix/features/details/domain/entities/movie_details.dart';
import 'package:movix/features/discover/data/model/genre_model.dart';

class MovieDetailsModel extends MovieDetails {
  const MovieDetailsModel({
    required super.id,
    required super.title,
    super.tagline,
    super.overview,
    super.posterPath,
    super.backdropPath,
    super.genres,
    super.runtime,
    super.releaseDate,
    super.voteAverage,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    final genres = (json['genres'] as List? ?? [])
        .cast<Map<String, dynamic>>()
        .map(GenreModel.fromJson)
        .toList();

    return MovieDetailsModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Untitled',
      tagline: (json['tagline'] as String?)?.let((v) => v.isEmpty ? null : v),
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      genres: genres,
      runtime: json['runtime'] as int?,
      releaseDate: json['release_date'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
    );
  }
}

extension _Let<T> on T {
  R let<R>(R Function(T) block) => block(this);
}