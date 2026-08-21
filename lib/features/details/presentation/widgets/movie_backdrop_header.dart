import 'package:flutter/material.dart';
import 'package:movix/core/utils/tmdb_image_helper.dart';
import 'package:movix/core/widgets/tmdb_network_image.dart';
import 'package:movix/features/details/domain/entities/movie_details.dart';

class MovieBackdropHeader extends StatelessWidget {
  const MovieBackdropHeader({super.key, required this.backdropPath, this.onPlayTrailer});
  final String? backdropPath;
  final VoidCallback? onPlayTrailer;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          TmdbNetworkImage(imageUrl: TmdbImageHelper.backdrop(backdropPath)),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.65)],
                stops: const [0.4, 1],
              ),
            ),
          ),
          if (onPlayTrailer != null)
            Center(
              child: GestureDetector(
                onTap: onPlayTrailer,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 34),
                ),
              ),
            ),
        ],
      ),
    );
  }
}