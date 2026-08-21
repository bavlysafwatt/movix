import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movix/core/helpers/spacing.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({super.key, required this.currentRating, required this.isSubmitting, required this.onRate});

  final double? currentRating;
  final bool isSubmitting;
  final ValueChanged<double> onRate;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final filledStars = ((currentRating ?? 0) / 2).round(); // 0-10 scale -> 5 stars

    return Container(
      padding: EdgeInsets.all(responsiveSpacing(context, 14)),
      decoration: BoxDecoration(color: colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Text('Rate this', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colorScheme.onSurface)),
          horizontalSpace(responsiveSpacing(context, 10)),
          if (isSubmitting)
            SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary)),
            )
          else
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: List.generate(5, (index) {
                  final filled = index < filledStars;
                  return GestureDetector(
                    onTap: () => onRate((index + 1) * 2.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Icon(
                        filled ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star,
                        size: 18,
                        color: filled ? Colors.amber.shade600 : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}