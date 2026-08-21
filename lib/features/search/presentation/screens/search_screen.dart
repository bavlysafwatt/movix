import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:movix/core/helpers/spacing.dart';
import 'package:movix/core/routing/routes.dart';
import 'package:movix/core/widgets/app_text_field.dart';
import 'package:movix/core/widgets/error_view.dart';
import 'package:movix/dependency_injection.dart';
import 'package:movix/features/search/presentation/widgets/no_results_view.dart';
import 'package:movix/features/search/presentation/widgets/recent_search_view.dart';

import '../../domain/entities/search_filter.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../widgets/search_result_card.dart';
import '../widgets/search_results_shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  SearchFilter _filter = SearchFilter.all;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SearchCubit>(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<SearchCubit>();
          final colorScheme = Theme.of(context).colorScheme;

          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      responsiveSpacing(context, 20),
                      responsiveSpacing(context, 10),
                      responsiveSpacing(context, 20),
                      0,
                    ),
                    child: Column(
                      children: [
                        AppTextField(
                          hintText: 'Search movies & shows',
                          controller: _controller,
                          prefixIcon: Icon(
                            FontAwesomeIcons.magnifyingGlass,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          suffixIcon: ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _controller,
                            builder: (context, value, _) => value.text.isEmpty
                                ? const SizedBox.shrink()
                                : IconButton(
                                  icon: const Icon(
                                    FontAwesomeIcons.xmark,
                                  ),
                                  onPressed: () {
                                    _controller.clear();
                                    cubit.onQueryChanged('', _filter);
                                  },
                                ),
                          ),
                          onChanged: (value) =>
                              cubit.onQueryChanged(value, _filter),
                        ),
                        verticalSpace(responsiveSpacing(context, 14)),
                        SizedBox(
                          width: double.infinity,
                          child: SegmentedButton<SearchFilter>(
                            segments: const [
                              ButtonSegment(
                                value: SearchFilter.all,
                                label: Text('All'),
                              ),
                              ButtonSegment(
                                value: SearchFilter.movie,
                                label: Text('Movies'),
                              ),
                              ButtonSegment(
                                value: SearchFilter.tv,
                                label: Text('TV'),
                              ),
                            ],
                            selected: {_filter},
                            onSelectionChanged: (selection) {
                              setState(() => _filter = selection.first);
                              cubit.onFilterChanged(selection.first);
                            },
                          ),
                        ),
                        verticalSpace(responsiveSpacing(context, 12)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<SearchCubit, SearchState>(
                      builder: (context, state) {
                        if (state is SearchInitial) {
                          return RecentSearchesView(
                            recentSearches: state.recentSearches,
                            onSelect: (query) {
                              _controller.text = query;
                              cubit.searchImmediately(query, _filter);
                            },
                            onClear: cubit.clearRecentSearches,
                          );
                        }
                        if (state is SearchLoading) {
                          return const SearchResultsShimmer();
                        }
                        if (state is SearchEmpty) return const NoResultsView();
                        if (state is SearchError) {
                          return ErrorView(
                            message: state.message,
                            onRetry: cubit.retry,
                          );
                        }

                        final results = (state as SearchSuccess).results;
                        return GridView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.55,
                              ),
                          itemCount: results.length,
                          itemBuilder: (context, index) => SearchResultCard(
                            movie: results[index],
                            onTap: () {
                              if (results[index].mediaType == 'movie') {
                                context.push(
                                  Routes.movieDetailsPath(results[index].id),
                                );
                              } else if (results[index].mediaType == 'tv') {
                                context.push(
                                  Routes.tvDetailsPath(results[index].id),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
