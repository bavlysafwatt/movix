import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movix/core/helpers/spacing.dart';
import 'package:movix/core/utils/tmdb_image_helper.dart';
import 'package:movix/core/widgets/tmdb_network_image.dart';
import 'package:movix/features/home/domain/entities/movie.dart';

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({super.key, required this.movie, this.onTap});
  final Movie movie;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: TmdbNetworkImage(
                    imageUrl: TmdbImageHelper.poster(movie.posterPath),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      movie.mediaType == 'tv' ? 'TV' : 'MOVIE',
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(6),
          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
          ),
          if (movie.voteAverage != null)
            Row(
              children: [
                FaIcon(FontAwesomeIcons.star, size: 13, color: Colors.amber.shade600),
                horizontalSpace(2),
                Text(
                  movie.voteAverage!.toStringAsFixed(1),
                  style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
        ],
      ),
    );
  }
}