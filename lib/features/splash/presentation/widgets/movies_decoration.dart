import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MovieDecoration extends StatelessWidget {
  final IconData icon;
  final double size;
  final double rotation;

  const MovieDecoration({super.key,
    required this.icon,
    required this.size,
    required this.rotation,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Transform.rotate(
      angle: rotation,
      child: FaIcon(
        icon,
        size: size,
        color: colorScheme.primary.withValues(alpha: 0.10),
      ),
    );
  }
}