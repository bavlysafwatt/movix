import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:movix/core/helpers/spacing.dart';
import 'package:movix/core/routing/routes.dart';
import 'package:movix/core/utils/app_strings.dart';
import 'package:movix/core/utils/messages.dart';
import 'package:movix/dependency_injection.dart';
import 'package:movix/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:movix/features/auth/presentation/cubit/auth_state.dart';
import 'package:movix/features/auth/presentation/widgets/feature_pill.dart';
import 'package:movix/features/auth/presentation/widgets/google_sign_in_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<AuthCubit>(),
    child: BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.action == AuthAction.authenticated) context.go(Routes.home);
        if (state.action == AuthAction.failure) {
          Messages.showErrorSnackBar(
            context: context,
            message: state.message ?? AppStrings.authUnexpectedError,
          );
        }
      },
      builder: (context, state) {
        final loading = state.action == AuthAction.loading;
        final colorScheme = Theme.of(context).colorScheme;

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsiveSpacing(context, 28),
              ),
              child: Column(
                children: [
                  verticalSpace(responsiveSpacing(context, 70)),

                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: colorScheme.outlineVariant),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.film,
                        size: 34,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),

                  Text(
                    AppStrings.loginHeadlinePrimary,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    AppStrings.loginHeadlineSecondary,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.primary,
                      height: 1.1,
                    ),
                  ),

                  verticalSpace(responsiveSpacing(context, 16)),

                  Text(
                    AppStrings.loginDescription,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),

                  verticalSpace(responsiveSpacing(context, 24)),

                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      FeaturePill(
                        icon: FontAwesomeIcons.fire,
                        label: AppStrings.featureTrending,
                        colorScheme: colorScheme,
                      ),
                      FeaturePill(
                        icon: FontAwesomeIcons.bookmark,
                        label: AppStrings.featureWatchlist,
                        colorScheme: colorScheme,
                      ),
                      FeaturePill(
                        icon: FontAwesomeIcons.shieldHalved,
                        label: AppStrings.featureSecure,
                        colorScheme: colorScheme,
                      ),
                    ],
                  ),

                  const Spacer(flex: 4),

                  GoogleSignInButton(
                    label: AppStrings.continueWithGoogle,
                    isLoading: loading,
                    onPressed: () =>
                        context.read<AuthCubit>().signInWithGoogle(),
                  ),

                  verticalSpace(responsiveSpacing(context, 20)),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}