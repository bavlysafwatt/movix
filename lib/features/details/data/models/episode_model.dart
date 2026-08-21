import 'package:movix/features/details/domain/entities/episode.dart';

class EpisodeModel extends Episode {
  const EpisodeModel({
    required super.episodeNumber, required super.name,
    super.overview, super.stillPath, super.airDate, super.voteAverage,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) => EpisodeModel(
    episodeNumber: json['episode_number'] as int,
    name: json['name'] as String? ?? 'Episode',
    overview: json['overview'] as String?,
    stillPath: json['still_path'] as String?,
    airDate: json['air_date'] as String?,
    voteAverage: (json['vote_average'] as num?)?.toDouble(),
  );
}


class SeasonDetailsModel extends SeasonDetails {
  const SeasonDetailsModel({required super.seasonNumber, required super.name, required super.episodes});
}