import 'package:movix/features/home/domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.mediaType,
    super.posterPath,
    super.backdropPath,
    super.overview,
    super.voteAverage,
    super.releaseDate,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json, {String? mediaType}) {
    final resolvedMediaType = mediaType ?? json['media_type'] as String? ?? 'movie';
    final isTv = resolvedMediaType == 'tv';

    return MovieModel(
      id: json['id'] as int,
      title: (isTv ? json['name'] : json['title']) as String? ?? 'Untitled',
      mediaType: resolvedMediaType,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      overview: json['overview'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      releaseDate: (isTv ? json['first_air_date'] : json['release_date']) as String?,
    );
  }
}