import 'package:flutter/material.dart';
import 'package:movix/core/helpers/spacing.dart';

import '../../domain/entities/movie.dart';
import 'movie_card.dart';

class MovieSectionCarousel extends StatelessWidget {
  const MovieSectionCarousel({super.key, required this.title, required this.movies, this.onMovieTap});
  final String title;
  final List<Movie> movies;
  final void Function(Movie movie)? onMovieTap;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        ),
        verticalSpace(12),
        SizedBox(
          height: 236,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movies.length,
            separatorBuilder: (_, __) => horizontalSpace(12),
            itemBuilder: (context, index) => MovieCard(
              movie: movies[index],
              onTap: onMovieTap == null ? null : () => onMovieTap!(movies[index]),
            ),
          ),
        ),
        verticalSpace(20),
      ],
    );
  }
}