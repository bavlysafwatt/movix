import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:movix/core/helpers/spacing.dart';
import 'package:movix/core/routing/routes.dart';
import 'package:movix/core/theme/theme_cubit.dart';
import 'package:movix/core/utils/messages.dart';
import 'package:movix/core/widgets/error_view.dart';
import 'package:movix/dependency_injection.dart';
import 'package:movix/features/settings/presentation/widgets/profile_card.dart';
import 'package:movix/features/settings/presentation/widgets/section_card.dart';
import 'package:movix/features/settings/presentation/widgets/settings_tile.dart';

import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

const _regions = [
  ('US', 'United States'),
  ('GB', 'United Kingdom'),
  ('EG', 'Egypt'),
  ('SA', 'Saudi Arabia'),
  ('AE', 'United Arab Emirates'),
  ('IN', 'India'),
  ('DE', 'Germany'),
  ('FR', 'France'),
];

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SettingsCubit>(),
      child: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLoggedOut) context.go(Routes.login);
          if (state is SettingsActionFailure) {
            Messages.showErrorSnackBar(
              context: context,
              message: state.message,
            );
          }
        },
        builder: (context, state) {
          if (state is SettingsInitial || state is SettingsLoading || state is SettingsLoggedOut) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          if (state is SettingsError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Settings')),
              body: ErrorView(message: state.message),
            );
          }

          final loaded = state as SettingsLoaded;
          final isLoggingOut = state is SettingsLoggingOut;
          final cubit = context.read<SettingsCubit>();
          final colorScheme = Theme.of(context).colorScheme;

          return Scaffold(
            body: SafeArea(
              child: ListView(
                padding: EdgeInsets.all(responsiveSpacing(context, 20)),
                children: [
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  verticalSpace(responsiveSpacing(context, 24)),

                  ProfileCard(name: loaded.name, email: loaded.email),
                  verticalSpace(responsiveSpacing(context, 20)),

                  SectionCard(
                    title: 'Preferences',
                    children: [
                      BlocBuilder<ThemeCubit, ThemeState>(
                        builder: (context, themeState) {
                          final isDark =
                              (themeState as ThemeChanged)
                                  .themeData
                                  .brightness ==
                              Brightness.dark;
                          return SettingsTile(
                            icon: isDark
                                ? FontAwesomeIcons.moon
                                : FontAwesomeIcons.sun,
                            title: 'Dark Mode',
                            trailing: Switch(
                              value: isDark,
                              onChanged: (_) =>
                                  context.read<ThemeCubit>().toggleTheme(),
                            ),
                          );
                        },
                      ),
                      SettingsTile(
                        icon: FontAwesomeIcons.earthAmericas,
                        title: 'Region',
                        subtitle: _regions
                            .firstWhere(
                              (r) => r.$1 == loaded.region,
                              orElse: () => (loaded.region, loaded.region),
                            )
                            .$2,
                        trailing: Icon(
                          Icons.chevron_right,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onTap: () =>
                            _showRegionSheet(context, cubit, loaded.region),
                      ),
                    ],
                  ),
                  verticalSpace(responsiveSpacing(context, 16)),

                  SectionCard(
                    title: 'Account',
                    children: [
                      SettingsTile(
                        icon: FontAwesomeIcons.rightFromBracket,
                        title: 'Log Out',
                        titleColor: colorScheme.error,
                        iconColor: colorScheme.error,
                        trailing: isLoggingOut
                            ? SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    colorScheme.error,
                                  ),
                                ),
                              )
                            : null,
                        onTap: isLoggingOut
                            ? null
                            : () => _confirmLogout(context, cubit),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showRegionSheet(
    BuildContext context,
    SettingsCubit cubit,
    String currentRegion,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(sheetContext).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Select Region',
                style: Theme.of(sheetContext).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              for (final (code, name) in _regions)
                ListTile(
                  title: Text(name),
                  trailing: code == currentRegion
                      ? Icon(
                          Icons.check,
                          color: Theme.of(sheetContext).colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    cubit.changeRegion(code);
                    Navigator.of(sheetContext).pop();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, SettingsCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text(
          'You\'ll need to sign in again to access your library.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              cubit.logout();
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
