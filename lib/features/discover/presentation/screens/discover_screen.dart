import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movix/core/helpers/spacing.dart';
import 'package:movix/core/widgets/error_view.dart';
import 'package:movix/dependency_injection.dart';
import 'package:movix/features/discover/domain/entities/discover_filters.dart';
import 'package:movix/features/discover/domain/entities/genre.dart';

import '../cubit/discover_cubit.dart';
import '../cubit/discover_state.dart';
import '../widgets/discover_filter_bar.dart';
import '../widgets/discover_filter_sheet.dart';
import '../widgets/discover_movie_card.dart';
import '../widgets/discover_results_shimmer.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key, required this.genres, required this.initialFilters});

  final List<Genre> genres;
  final DiscoverFilters initialFilters;

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _scrollController = ScrollController();
  late final DiscoverCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<DiscoverCubit>()..loadInitial(widget.initialFilters);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      _cubit.loadMore();
    }
  }

  void _openFilterSheet(BuildContext context, DiscoverFilters current) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => DiscoverFilterSheet(
        genres: widget.genres,
        initialFilters: current,
        onApply: _cubit.applyFilters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(title: const Text('Browse')),
        body: SafeArea(
          child: BlocBuilder<DiscoverCubit, DiscoverState>(
            builder: (context, state) {
              if (state is DiscoverInitial || state is DiscoverLoading) {
                return const DiscoverResultsShimmer();
              }
              if (state is DiscoverError) {
                return ErrorView(message: state.message, onRetry: () => context.read<DiscoverCubit>().retry());
              }

              final loaded = state as DiscoverLoaded;
              return Column(
                children: [
                  verticalSpace(responsiveSpacing(context, 12)),
                  DiscoverFilterBar(
                    filters: loaded.filters,
                    onOpenFilters: () => _openFilterSheet(context, loaded.filters),
                  ),
                  verticalSpace(responsiveSpacing(context, 12)),
                  Expanded(
                    child: loaded.movies.isEmpty
                        ? const _NoMatchesView()
                        : GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 130,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.55,
                      ),
                      itemCount: loaded.movies.length + (loaded.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= loaded.movies.length) {
                          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                        }
                        return DiscoverMovieCard(movie: loaded.movies[index], onTap: null);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NoMatchesView extends StatelessWidget {
  const _NoMatchesView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.filter_alt_off_outlined, size: 40, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text('No matches for these filters', style: TextStyle(fontWeight: FontWeight.w700, color: colorScheme.onSurface)),
          ],
        ),
      ),
    );
  }
}