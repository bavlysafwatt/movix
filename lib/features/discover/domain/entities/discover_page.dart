import 'package:equatable/equatable.dart';
import 'package:movix/features/home/domain/entities/movie.dart';

class DiscoverPage extends Equatable {
  const DiscoverPage({required this.movies, required this.page, required this.totalPages});
  final List<Movie> movies;
  final int page;
  final int totalPages;

  bool get hasMore => page < totalPages;

  @override
  List<Object?> get props => [movies, page, totalPages];
}