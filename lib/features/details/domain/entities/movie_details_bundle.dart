import 'package:equatable/equatable.dart';
import 'package:movix/features/details/domain/entities/watch_providers.dart';
import 'package:movix/features/home/domain/entities/movie.dart';

import 'cast_member.dart';
import 'movie_details.dart';

class MovieDetailsBundle extends Equatable {
  const MovieDetailsBundle({
    required this.details,
    required this.cast,
    this.trailerKey,
    required this.similar,
    required this.recommendations,
    required this.watchProviders
  });

  final MovieDetails details;
  final List<CastMember> cast;
  final String? trailerKey;
  final List<Movie> similar;
  final List<Movie> recommendations;
  final WatchProvidersInfo? watchProviders;

  @override
  List<Object?> get props => [details, cast, trailerKey, similar, recommendations, watchProviders];
}