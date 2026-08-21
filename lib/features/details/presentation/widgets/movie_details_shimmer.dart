import 'package:flutter/material.dart';
import 'package:movix/core/helpers/spacing.dart';
import 'package:shimmer/shimmer.dart';

class MovieDetailsShimmer extends StatelessWidget {
  const MovieDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainerHighest,
      highlightColor: colorScheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          AspectRatio(aspectRatio: 16 / 9, child: Container(color: Colors.white)),
          Padding(
            padding: EdgeInsets.all(responsiveSpacing(context, 20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 22, width: 220, color: Colors.white),
                verticalSpace(responsiveSpacing(context, 12)),
                Container(height: 60, width: double.infinity, color: Colors.white),
                verticalSpace(responsiveSpacing(context, 16)),
                Container(height: 64, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}