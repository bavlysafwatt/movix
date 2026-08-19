import 'package:flutter/material.dart';
import 'package:movix/core/helpers/spacing.dart';
import 'package:movix/features/discover/domain/entities/discover_filters.dart';

class DiscoverFilterBar extends StatelessWidget {
  const DiscoverFilterBar({super.key, required this.filters, required this.onOpenFilters});
  final DiscoverFilters filters;
  final VoidCallback onOpenFilters;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final chips = <String>[
      if (filters.genre != null) filters.genre!.name,
      if (filters.year != null) filters.year.toString(),
      if (filters.minRating != null) '${filters.minRating!.toStringAsFixed(1)}+ ★',
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsiveSpacing(context, 20)),
      child: Row(
        children: [
          Expanded(
            child: chips.isEmpty
                ? Text(filters.sort.label, style: TextStyle(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600))
                : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final label in chips)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colorScheme.primary)),
                  ),
              ],
            ),
          ),
          horizontalSpace(responsiveSpacing(context, 10)),
          IconButton.filledTonal(
            onPressed: onOpenFilters,
            icon: const Icon(Icons.tune_rounded, size: 20),
          ),
        ],
      ),
    );
  }
}