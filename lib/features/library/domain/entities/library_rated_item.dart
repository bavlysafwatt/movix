import 'library_item.dart';

class LibraryRatedItem extends LibraryItem {
  const LibraryRatedItem({
    required super.tmdbId,
    required super.mediaType,
    required super.title,
    super.posterPath,
    super.releaseDate,
    required this.rating,
  });

  final double rating;

  @override
  List<Object?> get props => [...super.props, rating];
}