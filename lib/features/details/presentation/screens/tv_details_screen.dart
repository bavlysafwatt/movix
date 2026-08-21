import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movix/core/helpers/spacing.dart';
import 'package:movix/core/routing/routes.dart';
import 'package:movix/core/widgets/error_view.dart';
import 'package:movix/dependency_injection.dart';
import 'package:movix/features/details/presentation/widgets/where_to_watch_section.dart';
import 'package:movix/features/home/presentation/widgets/movie_section_carousel.dart';

import '../cubit/tv_details_cubit.dart';
import '../cubit/tv_details_state.dart';
import '../widgets/cast_strip.dart';
import '../widgets/movie_action_buttons.dart';
import '../widgets/movie_backdrop_header.dart';
import '../widgets/movie_details_shimmer.dart';
import '../widgets/rating_widget.dart';
import '../widgets/season_list.dart';

class TvDetailsScreen extends StatelessWidget {
  const TvDetailsScreen({super.key, required this.tvId});
  final int tvId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TvDetailsCubit>()..load(tvId),
      child: Scaffold(
        body: BlocBuilder<TvDetailsCubit, TvDetailsState>(
          builder: (context, state) {
            if (state is TvDetailsInitial || state is TvDetailsLoading) {
              return const MovieDetailsShimmer();
            }
            if (state is TvDetailsError) {
              return SafeArea(
                child: ErrorView(
                  message: state.message,
                  onRetry: () => context.read<TvDetailsCubit>().load(tvId),
                ),
              );
            }

            final loaded = state as TvDetailsLoaded;
            final cubit = context.read<TvDetailsCubit>();
            final colorScheme = Theme.of(context).colorScheme;
            final details = loaded.details;

            return Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.only(bottom: 40),
                  children: [
                    MovieBackdropHeader(
                      backdropPath: details.backdropPath,
                      onPlayTrailer: loaded.trailerKey == null
                          ? null
                          : () => context.push(Routes.trailerPath(loaded.trailerKey!)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(responsiveSpacing(context, 20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            details.name,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          if (details.tagline != null) ...[
                            verticalSpace(4),
                            Text(
                              details.tagline!,
                              style: TextStyle(fontStyle: FontStyle.italic, color: colorScheme.onSurfaceVariant),
                            ),
                          ],
                          verticalSpace(responsiveSpacing(context, 10)),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              if (details.voteAverage != null)
                                _MetaChip(icon: Icons.star_rounded, label: details.voteAverage!.toStringAsFixed(1), color: Colors.amber.shade600),
                              if (details.episodeRuntime != null)
                                _MetaChip(icon: Icons.schedule_rounded, label: '${details.episodeRuntime} min/ep'),
                              if (details.firstAirDate != null)
                                _MetaChip(icon: Icons.calendar_today_rounded, label: details.firstAirDate!.split('-').first),
                              if (details.numberOfSeasons != null)
                                _MetaChip(icon: Icons.video_library_outlined, label: '${details.numberOfSeasons} seasons'),
                              for (final genre in details.genres) _MetaChip(label: genre.name),
                            ],
                          ),
                          verticalSpace(responsiveSpacing(context, 18)),
                          MovieActionButtons(
                            isFavorite: loaded.status.isFavorite,
                            isInWatchlist: loaded.status.isInWatchlist,
                            isWatched: loaded.status.isWatched,
                            isUpdatingFavorite: loaded.isUpdatingFavorite,
                            isUpdatingWatchlist: loaded.isUpdatingWatchlist,
                            isUpdatingWatched: loaded.isUpdatingWatched,
                            onFavoriteTap: cubit.toggleFavorite,
                            onWatchlistTap: cubit.toggleWatchlist,
                            onWatchedTap: cubit.toggleWatched,
                          ),
                          verticalSpace(responsiveSpacing(context, 14)),
                          RatingWidget(
                            currentRating: loaded.status.userRating,
                            isSubmitting: loaded.isSubmittingRating,
                            onRate: cubit.rate,
                          ),
                          if (details.overview != null) ...[
                            verticalSpace(responsiveSpacing(context, 20)),
                            Text('Overview', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                            verticalSpace(6),
                            Text(details.overview!, style: TextStyle(color: colorScheme.onSurfaceVariant, height: 1.5)),
                          ],
                        ],
                      ),
                    ),
                    verticalSpace(responsiveSpacing(context, 8)),
                    SeasonList(
                      seasons: details.seasons,
                      onSeasonTap: (season) => context.push(Routes.seasonDetailsPath(tvId, season.seasonNumber)),
                    ),
                    verticalSpace(responsiveSpacing(context, 20)),
                    WhereToWatchSection(providers: loaded.watchProviders),
                    verticalSpace(responsiveSpacing(context, 8)),
                    CastStrip(
                      cast: loaded.cast,
                      onCastTap: (member) => context.push(Routes.personDetailsPath(member.id)),
                    ),
                    verticalSpace(responsiveSpacing(context, 8)),
                    MovieSectionCarousel(
                      title: 'Similar',
                      movies: loaded.similar,
                      onMovieTap: (movie) => context.push(Routes.tvDetailsPath(movie.id)),
                    ),
                    MovieSectionCarousel(
                      title: 'Recommended',
                      movies: loaded.recommendations,
                      onMovieTap: (movie) => context.push(Routes.tvDetailsPath(movie.id)),
                    ),
                  ],
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 12,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.45), shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({this.icon, required this.label, this.color});
  final IconData? icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(14)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color ?? colorScheme.onSurfaceVariant),
            const SizedBox(width: 4),
          ],
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
        ],
      ),
    );
  }
}