import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movix/core/helpers/spacing.dart';
import 'package:movix/core/routing/routes.dart';
import 'package:movix/core/widgets/error_view.dart';
import 'package:movix/dependency_injection.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/hero_carousel.dart';
import '../widgets/hero_shimmer.dart';
import '../widgets/home_banner.dart';
import '../widgets/movie_section_carousel.dart';
import '../widgets/movie_section_shimmer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..fetchHome(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const HomeBanner(),
              Expanded(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading || state is HomeInitial) {
                      return const _HomeShimmerSkeleton();
                    }

                    if (state is HomeError) {
                      return ErrorView(
                        message: state.message,
                        onRetry: () => context.read<HomeCubit>().fetchHome(),
                      );
                    }

                    final sections = (state as HomeSuccess).sections;

                    return RefreshIndicator(
                      onRefresh: () => context.read<HomeCubit>().fetchHome(),
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        children: [
                          HeroCarousel(
                            movies: sections.heroTrending,
                            onMovieTap: (movie) {
                              if (movie.mediaType == 'movie') {
                                context.push(Routes.movieDetailsPath(movie.id));
                              } else if (movie.mediaType == 'tv') {
                                context.push(Routes.tvDetailsPath(movie.id));
                              }
                            },
                          ),
                          verticalSpace(24),

                          MovieSectionCarousel(
                            title: 'Trending Now',
                            movies: sections.trending,
                            onMovieTap: (movie) {
                              if (movie.mediaType == 'movie') {
                                context.push(Routes.movieDetailsPath(movie.id));
                              } else if (movie.mediaType == 'tv') {
                                context.push(Routes.tvDetailsPath(movie.id));
                              }
                            },
                          ),
                          MovieSectionCarousel(
                            title: 'Popular Movies',
                            movies: sections.popular,
                            onMovieTap: (movie) {
                              if (movie.mediaType == 'movie') {
                                context.push(Routes.movieDetailsPath(movie.id));
                              } else if (movie.mediaType == 'tv') {
                                context.push(Routes.tvDetailsPath(movie.id));
                              }
                            },
                          ),
                          MovieSectionCarousel(
                            title: 'Top Rated Movies',
                            movies: sections.topRated,
                            onMovieTap: (movie) {
                              if (movie.mediaType == 'movie') {
                                context.push(Routes.movieDetailsPath(movie.id));
                              } else if (movie.mediaType == 'tv') {
                                context.push(Routes.tvDetailsPath(movie.id));
                              }
                            },
                          ),
                          MovieSectionCarousel(
                            title: 'Upcoming Movies',
                            movies: sections.upcoming,
                            onMovieTap: (movie) {
                              if (movie.mediaType == 'movie') {
                                context.push(Routes.movieDetailsPath(movie.id));
                              } else if (movie.mediaType == 'tv') {
                                context.push(Routes.tvDetailsPath(movie.id));
                              }
                            },
                          ),
                          MovieSectionCarousel(
                            title: 'Now Playing Movies',
                            movies: sections.nowPlaying,
                            onMovieTap: (movie) {
                              if (movie.mediaType == 'movie') {
                                context.push(Routes.movieDetailsPath(movie.id));
                              }
                            },
                          ),
                          MovieSectionCarousel(
                            title: 'Popular TV Shows',
                            movies: sections.popularTv,
                            onMovieTap: (movie) {
                              if (movie.mediaType == 'tv') {
                                context.push(Routes.tvDetailsPath(movie.id));
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeShimmerSkeleton extends StatelessWidget {
  const _HomeShimmerSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      children: const [
        HeroShimmer(),
        SizedBox(height: 24),
        MovieSectionShimmer(),
        MovieSectionShimmer(),
        MovieSectionShimmer(),
        MovieSectionShimmer(),
        MovieSectionShimmer(),
        MovieSectionShimmer(),
      ],
    );
  }
}
