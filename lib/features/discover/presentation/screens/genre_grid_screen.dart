import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:movix/core/routing/routes.dart';
import 'package:movix/core/widgets/error_view.dart';
import 'package:movix/dependency_injection.dart';
import 'package:movix/features/discover/domain/entities/discover_filters.dart';

import '../cubit/genre_cubit.dart';
import '../cubit/genre_state.dart';
import '../widgets/genre_grid_shimmer.dart';
import '../widgets/genre_tile.dart';

class GenreGridScreen extends StatelessWidget {
  const GenreGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GenreCubit>()..fetchGenres(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Discover'),
          actions: [
            BlocBuilder<GenreCubit, GenreState>(
              builder: (context, state) {
                if (state is! GenreSuccess) return const SizedBox.shrink();
                return IconButton(
                  icon: const Icon(FontAwesomeIcons.filter),
                  tooltip: 'Browse all',
                  onPressed: () => context.push(
                    Routes.discoverResults,
                    extra: (genres: state.genres, initialFilters: const DiscoverFilters()),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<GenreCubit, GenreState>(
          builder: (context, state) {
            if (state is GenreInitial || state is GenreLoading) return const GenreGridShimmer();
            if (state is GenreError) {
              return ErrorView(message: state.message, onRetry: () => context.read<GenreCubit>().fetchGenres());
            }

            final genres = (state as GenreSuccess).genres;
            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 170,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.4,
              ),
              itemCount: genres.length,
              itemBuilder: (context, index) {
                final genre = genres[index];
                return GenreTile(
                  genre: genre,
                  onTap: () => context.push(
                    Routes.discoverResults,
                    extra: (genres: genres, initialFilters: DiscoverFilters(genre: genre)),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}