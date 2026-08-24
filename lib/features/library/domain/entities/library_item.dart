import 'package:equatable/equatable.dart';

class LibraryItem extends Equatable {
  const LibraryItem({
    required this.tmdbId,
    required this.mediaType,
    required this.title,
    this.posterPath,
    this.releaseDate,
  });

  final int tmdbId;
  final String mediaType;
  final String title;
  final String? posterPath;
  final String? releaseDate;

  @override
  List<Object?> get props => [tmdbId, mediaType, title, posterPath, releaseDate];
}