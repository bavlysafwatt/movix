import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:movix/core/helpers/spacing.dart';
import 'package:movix/core/routing/routes.dart';
import 'package:movix/core/utils/app_strings.dart';
import 'package:movix/core/utils/assets_manager.dart';
import 'package:movix/core/widgets/error_view.dart';
import 'package:movix/dependency_injection.dart';
import 'package:movix/features/splash/domain/entities/splash_destination.dart';
import 'package:movix/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:movix/features/splash/presentation/cubit/splash_state.dart';
import 'package:movix/features/splash/presentation/widgets/movies_decoration.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SplashCubit>()..determineInitialDestination(),
      child: const _SplashView(),
    );
  }
}

class _SplashView extends StatefulWidget {
  const _SplashView();

  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _logoScale = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _logoOpacity = Tween<double>(begin: 0.82, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _routeFor(SplashDestination destination) {
    return switch (destination) {
      SplashDestination.onboarding => Routes.onboarding,
      SplashDestination.login => Routes.login,
      SplashDestination.home => Routes.home,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logoWidth = responsiveSize(context, 240, max: 300);
    final progressIndicatorSize = responsiveSize(context, 120, max: 170);

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state case SplashReady(:final destination)) {
              context.go(_routeFor(destination));
            }
          },
          builder: (context, state) {
            if (state case SplashFailure(:final message)) {
              return ErrorView(
                message: message,
                onRetry: context.read<SplashCubit>().determineInitialDestination,
              );
            }

            return SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorScheme.surface,
                      colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    const Positioned(
                      top: 90,
                      left: 35,
                      child: MovieDecoration(
                        icon: FontAwesomeIcons.clapperboard,
                        size: 42,
                        rotation: -0.15,
                      ),
                    ),

                    const Positioned(
                      top: 130,
                      right: 40,
                      child: MovieDecoration(
                        icon: FontAwesomeIcons.star,
                        size: 34,
                        rotation: 0.2,
                      ),
                    ),

                    const Positioned(
                      left: 25,
                      bottom: 230,
                      child: MovieDecoration(
                        icon: FontAwesomeIcons.film,
                        size: 40,
                        rotation: 0.12,
                      ),
                    ),

                    const Positioned(
                      right: 30,
                      bottom: 270,
                      child: MovieDecoration(
                        icon: FontAwesomeIcons.ticket,
                        size: 38,
                        rotation: -0.18,
                      ),
                    ),

                    const Positioned(
                      left: 65,
                      bottom: 110,
                      child: MovieDecoration(
                        icon: FontAwesomeIcons.masksTheater,
                        size: 30,
                        rotation: 0.15,
                      ),
                    ),

                    const Positioned(
                      right: 65,
                      bottom: 125,
                      child: MovieDecoration(
                        icon: FontAwesomeIcons.play,
                        size: 28,
                        rotation: -0.1,
                      ),
                    ),

                    // Center logo
                    Center(
                      child: FadeTransition(
                        opacity: _logoOpacity,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: Image.asset(
                            isDark
                                ? AssetsManager.logoDark
                                : AssetsManager.logoLight,
                            width: logoWidth,
                            semanticLabel: AppStrings.appName,
                          ),
                        ),
                      ),
                    ),

                    // Bottom loading indicator
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 24,
                      child: Center(
                        child: SizedBox(
                          width: progressIndicatorSize,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              minHeight: 4,
                              backgroundColor:
                              Theme.of(context).colorScheme.surfaceContainerHighest,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        )
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
