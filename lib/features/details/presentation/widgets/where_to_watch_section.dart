import 'package:flutter/material.dart';
import 'package:movix/core/api/end_points.dart';
import 'package:movix/core/helpers/spacing.dart';
import 'package:movix/core/utils/tmdb_image_helper.dart';
import 'package:movix/core/widgets/tmdb_network_image.dart';
import 'package:movix/features/details/domain/entities/watch_providers.dart';

class WhereToWatchSection extends StatelessWidget {
  const WhereToWatchSection({super.key, required this.providers});
  final WatchProvidersInfo? providers;

  @override
  Widget build(BuildContext context) {
    if (providers == null || providers!.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsiveSpacing(context, 20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Where to Watch', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          verticalSpace(responsiveSpacing(context, 10)),
          if (providers!.flatrate.isNotEmpty) _row(context, 'Stream', providers!.flatrate),
          if (providers!.rent.isNotEmpty) _row(context, 'Rent', providers!.rent),
          if (providers!.buy.isNotEmpty) _row(context, 'Buy', providers!.buy),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, List<WatchProvider> items) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: responsiveSpacing(context, 12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: responsiveSpacing(context, 60),
            child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant)),
          ),
          Expanded(
            child: SizedBox(
              height: responsiveSpacing(context, 44),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, __) => horizontalSpace(8),
                itemBuilder: (context, index) => ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: responsiveSpacing(context, 44),
                    height: responsiveSpacing(context, 44),
                    child: TmdbNetworkImage(
                      imageUrl: TmdbImageHelper.poster(items[index].logoPath, size: EndPoints.logoW92),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}