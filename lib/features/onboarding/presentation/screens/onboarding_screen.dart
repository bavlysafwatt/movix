import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movix/core/helpers/spacing.dart';
import 'package:movix/core/routing/routes.dart';
import 'package:movix/core/theme/theme_cubit.dart';
import 'package:movix/core/utils/app_strings.dart';
import 'package:movix/core/utils/assets_manager.dart';
import 'package:movix/core/utils/messages.dart';
import 'package:movix/dependency_injection.dart';
import 'package:movix/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:movix/features/onboarding/presentation/cubit/onboarding_state.dart';

import '../models/onboarding_content.dart';
import '../widgets/onboarding_controls.dart';
import '../widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _pages = [
    OnboardingContent(
      assetPath: AssetsManager.onboardingDiscover,
      title: AppStrings.onboardingDiscoverTitle,
      description: AppStrings.onboardingDiscoverDescription,
    ),
    OnboardingContent(
      assetPath: AssetsManager.onboardingSearch,
      title: AppStrings.onboardingSearchTitle,
      description: AppStrings.onboardingSearchDescription,
    ),
    OnboardingContent(
      assetPath: AssetsManager.onboardingLibrary,
      title: AppStrings.onboardingLibraryTitle,
      description: AppStrings.onboardingLibraryDescription,
    ),
  ];

  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _next(OnboardingState state, OnboardingCubit cubit) async {
    final isLastPage = state.currentPage == _pages.length - 1;
    if (!isLastPage) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      return;
    }

    await _completeOnboarding(cubit);
  }

  Future<void> _completeOnboarding(OnboardingCubit cubit) async {
    final completed = await cubit.complete();
    if (mounted && completed) context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OnboardingCubit>(),
      child: BlocConsumer<OnboardingCubit, OnboardingState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage &&
            current.errorMessage != null,
        listener: (context, state) {
          Messages.showErrorSnackBar(context: context, message: state.errorMessage!);
        },
        builder: (context, state) {
          final isLastPage = state.currentPage == _pages.length - 1;
          final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(
                      responsiveSpacing(context, 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (state.currentPage > 0)
                          IconButton(
                            onPressed: () => _pageController.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            ),
                            icon: Icon(
                                Icons.arrow_back_ios,
                                color: Theme.of(context).colorScheme.primary,
                                size: 16,
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                        Row(
                          children: [
                            IconButton(
                              tooltip: isDarkTheme
                                  ? AppStrings.enableLightTheme
                                  : AppStrings.enableDarkTheme,
                              onPressed: context.read<ThemeCubit>().toggleTheme,
                              icon: Icon(
                                isDarkTheme
                                    ? Icons.light_mode_outlined
                                    : Icons.dark_mode_outlined,
                                size: 16,
                              ),
                            ),
                            if (!isLastPage)
                              TextButton(
                                onPressed: state.isCompleting
                                    ? null
                                    : () => _completeOnboarding(
                                        context.read<OnboardingCubit>(),
                                      ),
                                child: const Text(AppStrings.skip),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _pages.length,
                      onPageChanged: context.read<OnboardingCubit>().changePage,
                      itemBuilder: (_, index) => OnboardingPage(
                        content: _pages[index],
                      ),
                    ),
                  ),
                  OnboardingControls(
                    controller: _pageController,
                    totalPages: _pages.length,
                    buttonText: isLastPage
                        ? AppStrings.getStarted
                        : AppStrings.next,
                    onNextPressed: () => _next(
                      state,
                      context.read<OnboardingCubit>(),
                    ),
                    isLoading: state.isCompleting,
                  ),
                  verticalSpace(responsiveSpacing(context, 24)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
