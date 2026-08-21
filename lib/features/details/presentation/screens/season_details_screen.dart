import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movix/core/widgets/error_view.dart';
import 'package:movix/dependency_injection.dart';

import '../cubit/season_details_cubit.dart';
import '../cubit/season_details_state.dart';
import '../widgets/episode_tile.dart';

class SeasonDetailsScreen extends StatelessWidget {
  const SeasonDetailsScreen({super.key, required this.tvId, required this.seasonNumber});
  final int tvId;
  final int seasonNumber;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SeasonDetailsCubit>()..load(tvId, seasonNumber),
      child: Scaffold(
        appBar: AppBar(title: const Text('Episodes')),
        body: BlocBuilder<SeasonDetailsCubit, SeasonDetailsState>(
          builder: (context, state) {
            if (state is SeasonDetailsInitial || state is SeasonDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is SeasonDetailsError) {
              return ErrorView(
                message: state.message,
                onRetry: () => context.read<SeasonDetailsCubit>().load(tvId, seasonNumber),
              );
            }
            final season = (state as SeasonDetailsLoaded).season;
            if (season.episodes.isEmpty) {
              return const Center(child: Text('No episodes listed'));
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: season.episodes.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: 20, endIndent: 20),
              itemBuilder: (context, index) => EpisodeTile(episode: season.episodes[index]),
            );
          },
        ),
      ),
    );
  }
}