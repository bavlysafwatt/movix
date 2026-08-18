import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: NavigationBar(
          height: 55,
          backgroundColor: colorScheme.surface,
          selectedIndex: navigationShell.currentIndex,
          indicatorColor: colorScheme.primary.withValues(alpha: 0.1),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          onDestinationSelected: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                (states) {
              if (states.contains(WidgetState.selected)) {
                return TextStyle(
                  color: colorScheme.primary,
                  fontSize: 12,
                );
              }
              return TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              );
            },
          ),
          destinations: [
            _navIcon(FontAwesomeIcons.house, 'Home', colorScheme),
            _navIcon(FontAwesomeIcons.compass, 'Discover', colorScheme),
            _navIcon(FontAwesomeIcons.magnifyingGlass, 'Search', colorScheme),
            _navIcon(FontAwesomeIcons.bookmark, 'Library', colorScheme),
          ],
        ),
      ),
    );
  }

  NavigationDestination _navIcon(
      IconData icon,
      String label,
      ColorScheme colorScheme,
      ) {
    return NavigationDestination(
      icon: FaIcon(icon, size: 18, color: colorScheme.onSurfaceVariant),
      selectedIcon: FaIcon(icon, size: 18, color: colorScheme.primary),
      label: label,
    );
  }
}