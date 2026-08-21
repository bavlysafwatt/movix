import 'package:flutter/material.dart';
import 'package:movix/core/helpers/spacing.dart';
import 'package:movix/core/utils/tmdb_image_helper.dart';
import 'package:movix/core/widgets/tmdb_network_image.dart';
import 'package:movix/features/details/domain/entities/cast_member.dart';

class CastStrip extends StatelessWidget {
  const CastStrip({super.key, required this.cast, this.onCastTap});
  final List<CastMember> cast;
  final void Function(CastMember member)? onCastTap;

  @override
  Widget build(BuildContext context) {
    if (cast.isEmpty) return const SizedBox.shrink();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: responsiveSpacing(context, 20)),
          child: Text('Cast', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        ),
        verticalSpace(responsiveSpacing(context, 12)),
        SizedBox(
          height: responsiveSpacing(context, 120),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: responsiveSpacing(context, 20)),
            itemCount: cast.length,
            separatorBuilder: (_, __) => horizontalSpace(responsiveSpacing(context, 12)),
            itemBuilder: (context, index) {
              final member = cast[index];
              return GestureDetector(
                onTap: onCastTap == null ? null : () => onCastTap!(member),
                child: SizedBox(
                  width: responsiveSpacing(context, 78),
                  child: Column(
                    children: [
                      ClipOval(
                        child: SizedBox(
                          height: responsiveSpacing(context, 78),
                          width: responsiveSpacing(context, 78),
                          child: TmdbNetworkImage(imageUrl: TmdbImageHelper.profile(member.profilePath)),
                        ),
                      ),
                      verticalSpace(6),
                      Text(
                        member.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                      ),
                      if (member.character != null)
                        Text(
                          member.character!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10, color: colorScheme.onSurfaceVariant),
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