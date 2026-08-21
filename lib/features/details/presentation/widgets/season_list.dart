import 'package:flutter/material.dart';
import 'package:movix/core/helpers/spacing.dart';
import 'package:movix/core/utils/tmdb_image_helper.dart';
import 'package:movix/core/widgets/tmdb_network_image.dart';
import 'package:movix/features/details/domain/entities/tv_details.dart';

class SeasonList extends StatelessWidget {
  const SeasonList({super.key, required this.seasons, required this.onSeasonTap});
  final List<SeasonSummary> seasons;
  final ValueChanged<SeasonSummary> onSeasonTap;

  @override
  Widget build(BuildContext context) {
    if (seasons.isEmpty) return const SizedBox.shrink();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: responsiveSpacing(context, 20)),
          child: Text('Seasons', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        ),
        verticalSpace(responsiveSpacing(context, 12)),
        SizedBox(
          height: responsiveSpacing(context, 220),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: responsiveSpacing(context, 20)),
            itemCount: seasons.length,
            separatorBuilder: (_, __) => horizontalSpace(responsiveSpacing(context, 12)),
            itemBuilder: (context, index) {
              final season = seasons[index];
              return GestureDetector(
                onTap: () => onSeasonTap(season),
                child: SizedBox(
                  width: responsiveSpacing(context, 130),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TmdbNetworkImage(
                          imageUrl: TmdbImageHelper.poster(season.posterPath),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      verticalSpace(6),
                      Text(
                        season.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                      ),
                      Text(
                        '${season.episodeCount} episodes',
                        style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}