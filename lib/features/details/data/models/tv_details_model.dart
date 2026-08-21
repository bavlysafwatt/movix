import 'package:movix/features/discover/data/model/genre_model.dart';
import 'package:movix/features/details/domain/entities/tv_details.dart';

class TvDetailsModel extends TvDetails {
  const TvDetailsModel({
    required super.id, required super.name, super.tagline, super.overview,
    super.posterPath, super.backdropPath, super.genres, super.episodeRuntime,
    super.firstAirDate, super.voteAverage, super.numberOfSeasons, super.seasons,
  });

  factory TvDetailsModel.fromJson(Map<String, dynamic> json) {
    final genres = (json['genres'] as List? ?? []).cast<Map<String, dynamic>>().map(GenreModel.fromJson).toList();
    final runtimes = (json['episode_run_time'] as List? ?? []).cast<int>();
    final seasons = (json['seasons'] as List? ?? [])
        .cast<Map<String, dynamic>>()
        .where((s) => (s['season_number'] as int) > 0) // TMDB includes a "Specials" season 0; skip it
        .map((s) => SeasonSummary(
      seasonNumber: s['season_number'] as int,
      name: s['name'] as String? ?? 'Season ${s['season_number']}',
      episodeCount: s['episode_count'] as int? ?? 0,
      posterPath: s['poster_path'] as String?,
    ))
        .toList();

    return TvDetailsModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Untitled',
      tagline: (json['tagline'] as String?)?.isEmpty ?? true ? null : json['tagline'] as String?,
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      genres: genres,
      episodeRuntime: runtimes.isEmpty ? null : runtimes.first,
      firstAirDate: json['first_air_date'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      numberOfSeasons: json['number_of_seasons'] as int?,
      seasons: seasons,
    );
  }
}