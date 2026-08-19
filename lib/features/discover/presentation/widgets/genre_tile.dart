import 'package:flutter/material.dart';
import 'package:movix/core/helpers/spacing.dart';
import 'package:movix/features/discover/domain/entities/genre.dart';

class GenreTile extends StatelessWidget {
  const GenreTile({super.key, required this.genre, required this.onTap});
  final Genre genre;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final palette = [colorScheme.primary, colorScheme.secondary, colorScheme.tertiary];
    final color = palette[genre.id % palette.length];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withValues(alpha: 0.85), color.withValues(alpha: 0.45)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(responsiveSpacing(context, 12)),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              genre.name,
              maxLines: 2,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}