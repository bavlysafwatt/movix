import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movix/core/helpers/spacing.dart';

class MovieActionButtons extends StatelessWidget {
  const MovieActionButtons({
    super.key,
    required this.isFavorite,
    required this.isInWatchlist,
    required this.isWatched,
    required this.isUpdatingFavorite,
    required this.isUpdatingWatchlist,
    required this.isUpdatingWatched,
    required this.onFavoriteTap,
    required this.onWatchlistTap,
    required this.onWatchedTap,
  });

  final bool isFavorite;
  final bool isInWatchlist;
  final bool isWatched;
  final bool isUpdatingFavorite;
  final bool isUpdatingWatchlist;
  final bool isUpdatingWatched;
  final VoidCallback onFavoriteTap;
  final VoidCallback onWatchlistTap;
  final VoidCallback onWatchedTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: FontAwesomeIcons.solidHeart,
            outlineIcon: FontAwesomeIcons.heart,
            label: 'Favorite',
            active: isFavorite,
            loading: isUpdatingFavorite,
            onTap: onFavoriteTap,
          ),
        ),
        horizontalSpace(responsiveSpacing(context, 10)),
        Expanded(
          child: _ActionButton(
            icon: FontAwesomeIcons.solidBookmark,
            outlineIcon: FontAwesomeIcons.bookmark,
            label: 'Watchlist',
            active: isInWatchlist,
            loading: isUpdatingWatchlist,
            onTap: onWatchlistTap,
          ),
        ),
        horizontalSpace(responsiveSpacing(context, 10)),
        Expanded(
          child: _ActionButton(
            icon: FontAwesomeIcons.solidCircleCheck,
            outlineIcon: FontAwesomeIcons.circleCheck,
            label: 'Watched',
            active: isWatched,
            loading: isUpdatingWatched,
            onTap: onWatchedTap,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.outlineIcon,
    required this.label,
    required this.active,
    required this.loading,
    required this.onTap,
  });

  final IconData icon;
  final IconData outlineIcon;
  final String label;
  final bool active;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: responsiveSpacing(context, 12)),
        decoration: BoxDecoration(
          color: active ? colorScheme.primary.withValues(alpha: 0.14) : colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading)
              SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                ),
              )
            else
              Icon(active ? icon : outlineIcon, size: 18, color: active ? colorScheme.primary : colorScheme.onSurfaceVariant),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: active ? colorScheme.primary : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}