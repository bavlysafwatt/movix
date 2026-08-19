import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movix/features/auth/presentation/screens/login_screen.dart';
import 'package:movix/features/home/presentation/screens/home_screen.dart';
import 'package:movix/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:movix/features/settings/presentation/screens/settings_screen.dart';
import 'package:movix/features/splash/presentation/pages/splash_screen.dart';

import 'main_shell.dart';
import 'routes.dart';

class AppRouter {
  late final GoRouter router = GoRouter(
    initialLocation: Routes.splashScreen,
    routes: [
      GoRoute(
        path: Routes.splashScreen,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(path: Routes.settings, builder: (_, __) => const SettingsScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: Routes.home, builder: (_, __) => const HomeScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: Routes.discover, builder: (_, __) => const _PendingDestinationPage(title: 'Discover'))]),
          StatefulShellBranch(routes: [GoRoute(path: Routes.search, builder: (_, __) => const _PendingDestinationPage(title: 'Search'))]),
          StatefulShellBranch(routes: [GoRoute(path: Routes.library, builder: (_, __) => const _PendingDestinationPage(title: 'Library'))]),
        ],
      ),
    ],
  );
}

class _PendingDestinationPage extends StatelessWidget {
  const _PendingDestinationPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('$title feature is coming next.')),
    );
  }
}
