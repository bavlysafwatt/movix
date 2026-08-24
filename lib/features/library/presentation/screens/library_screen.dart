import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movix/core/routing/routes.dart';
import 'package:movix/core/widgets/error_view.dart';
import 'package:movix/dependency_injection.dart';
import 'package:movix/features/discover/presentation/widgets/discover_results_shimmer.dart';

import '../cubit/library_items_cubit.dart';
import '../cubit/library_list_state.dart';
import '../cubit/ratings_cubit.dart';
import '../cubit/ratings_state.dart';
import '../widgets/library_empty_state.dart';
import '../widgets/library_item_tile.dart';
import '../widgets/rated_item_tile.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Library'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [Tab(text: 'Favorites'), Tab(text: 'Watchlist'), Tab(text: 'Watched'), Tab(text: 'Ratings')],
          ),
        ),
        body: const TabBarView(
          children: [
            _LibraryListTab(kind: LibraryListKind.favorites),
            _LibraryListTab(kind: LibraryListKind.watchlist),
            _LibraryListTab(kind: LibraryListKind.watched),
            _RatingsTab(),
          ],
        ),
      ),
    );
  }
}

class _LibraryListTab extends StatelessWidget {
  const _LibraryListTab({required this.kind});
  final LibraryListKind kind;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LibraryItemsCubit>(param1: kind)..load(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<LibraryItemsCubit>();
          return BlocBuilder<LibraryItemsCubit, LibraryListState>(
            builder: (context, state) {
              if (state is LibraryListInitial || state is LibraryListLoading) {
                return const DiscoverResultsShimmer();
              }
              if (state is LibraryListError) {
                return ErrorView(message: state.message, onRetry: cubit.load);
              }

              final loaded = state as LibraryListLoaded;
              if (loaded.items.isEmpty) {
                return LibraryEmptyState(
                  icon: _emptyIcon,
                  title: _emptyTitle,
                  subtitle: _emptySubtitle,
                );
              }

              return RefreshIndicator(
                onRefresh: cubit.load,
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 130,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.55,
                  ),
                  itemCount: loaded.items.length,
                  itemBuilder: (context, index) {
                    final item = loaded.items[index];
                    final key = '${item.tmdbId}-${item.mediaType}';
                    return LibraryItemTile(
                      item: item,
                      isRemoving: loaded.removingKeys.contains(key),
                      onTap: () => item.mediaType == 'tv'
                          ? context.push(Routes.tvDetailsPath(item.tmdbId))
                          : context.push(Routes.movieDetailsPath(item.tmdbId)),
                      onRemove: () => cubit.remove(item),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData get _emptyIcon => switch (kind) {
    LibraryListKind.favorites => Icons.favorite_border_rounded,
    LibraryListKind.watchlist => Icons.bookmark_border_rounded,
    LibraryListKind.watched => Icons.check_circle_outline_rounded,
  };

  String get _emptyTitle => switch (kind) {
    LibraryListKind.favorites => 'No favorites yet',
    LibraryListKind.watchlist => 'Your watchlist is empty',
    LibraryListKind.watched => 'Nothing watched yet',
  };

  String get _emptySubtitle => switch (kind) {
    LibraryListKind.favorites => 'Tap the heart on a title to save it here',
    LibraryListKind.watchlist => 'Save movies & shows to watch later',
    LibraryListKind.watched => 'Mark titles as watched to track them here',
  };
}

class _RatingsTab extends StatelessWidget {
  const _RatingsTab();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RatingsCubit>()..load(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<RatingsCubit>();
          return BlocBuilder<RatingsCubit, RatingsState>(
            builder: (context, state) {
              if (state is RatingsInitial || state is RatingsLoading) {
                return const DiscoverResultsShimmer();
              }
              if (state is RatingsError) {
                return ErrorView(message: state.message, onRetry: cubit.load);
              }

              final items = (state as RatingsLoaded).items;
              if (items.isEmpty) {
                return const LibraryEmptyState(
                  icon: Icons.star_border_rounded,
                  title: 'No ratings yet',
                  subtitle: 'Rate a movie or show to see it here',
                );
              }

              return RefreshIndicator(
                onRefresh: cubit.load,
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 130,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.55,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return RatedItemTile(
                      item: item,
                      onTap: () => item.mediaType == 'tv'
                          ? context.push(Routes.tvDetailsPath(item.tmdbId))
                          : context.push(Routes.movieDetailsPath(item.tmdbId)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}