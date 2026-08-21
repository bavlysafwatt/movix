import 'package:flutter/material.dart';
import 'package:movix/core/helpers/spacing.dart';
import 'package:movix/core/utils/tmdb_image_helper.dart';
import 'package:movix/core/widgets/tmdb_network_image.dart';
import 'package:movix/features/details/domain/entities/episode.dart';

class EpisodeTile extends StatelessWidget {
  const EpisodeTile({super.key, required this.episode});
  final Episode episode;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsiveSpacing(context, 20),
        vertical: responsiveSpacing(context, 10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: responsiveSpacing(context, 110),
              height: responsiveSpacing(context, 68),
              child: TmdbNetworkImage(imageUrl: TmdbImageHelper.backdrop(episode.stillPath), fit: BoxFit.cover),
            ),
          ),
          horizontalSpace(responsiveSpacing(context, 12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${episode.episodeNumber}. ${episode.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colorScheme.onSurface),
                ),
                if (episode.overview != null) ...[
                  verticalSpace(2),
                  Text(
                    episode.overview!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}