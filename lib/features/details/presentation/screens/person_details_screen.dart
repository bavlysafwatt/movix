import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movix/core/helpers/spacing.dart';
import 'package:movix/core/routing/routes.dart';
import 'package:movix/core/utils/tmdb_image_helper.dart';
import 'package:movix/core/widgets/error_view.dart';
import 'package:movix/core/widgets/tmdb_network_image.dart';
import 'package:movix/dependency_injection.dart';
import 'package:movix/features/home/presentation/widgets/movie_card.dart';

import '../cubit/person_details_cubit.dart';
import '../cubit/person_details_state.dart';

class PersonDetailsScreen extends StatelessWidget {
  const PersonDetailsScreen({super.key, required this.personId});
  final int personId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PersonDetailsCubit>()..load(personId),
      child: Scaffold(
        body: BlocBuilder<PersonDetailsCubit, PersonDetailsState>(
          builder: (context, state) {
            if (state is PersonDetailsInitial || state is PersonDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is PersonDetailsError) {
              return SafeArea(
                child: ErrorView(
                  message: state.message,
                  onRetry: () => context.read<PersonDetailsCubit>().load(personId),
                ),
              );
            }

            final loaded = state as PersonDetailsLoaded;
            final person = loaded.details;
            final colorScheme = Theme.of(context).colorScheme;

            return SafeArea(
              child: ListView(
                padding: EdgeInsets.all(responsiveSpacing(context, 20)),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: SizedBox(
                          width: responsiveSpacing(context, 100),
                          height: responsiveSpacing(context, 140),
                          child: TmdbNetworkImage(imageUrl: TmdbImageHelper.profile(person.profilePath)),
                        ),
                      ),
                      horizontalSpace(responsiveSpacing(context, 14)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              person.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            if (person.knownForDepartment != null) ...[
                              verticalSpace(4),
                              Text(person.knownForDepartment!, style: TextStyle(color: colorScheme.onSurfaceVariant)),
                            ],
                            if (person.placeOfBirth != null) ...[
                              verticalSpace(8),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, size: 14, color: colorScheme.onSurfaceVariant),
                                  horizontalSpace(4),
                                  Expanded(
                                    child: Text(
                                      person.placeOfBirth!,
                                      style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (person.biography != null) ...[
                    verticalSpace(responsiveSpacing(context, 20)),
                    Text('Biography', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    verticalSpace(6),
                    Text(person.biography!, style: TextStyle(color: colorScheme.onSurfaceVariant, height: 1.5)),
                  ],
                  verticalSpace(responsiveSpacing(context, 20)),
                  Text('Filmography', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  verticalSpace(responsiveSpacing(context, 12)),
                  if (loaded.filmography.isEmpty)
                    Text('No filmography listed', style: TextStyle(color: colorScheme.onSurfaceVariant))
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 110,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.5,
                      ),
                      itemCount: loaded.filmography.length,
                      itemBuilder: (context, index) {
                        final movie = loaded.filmography[index];
                        return MovieCard(
                          movie: movie,
                          onTap: () {
                            if (movie.mediaType == 'tv') {
                              context.push(Routes.tvDetailsPath(movie.id));
                            } else {
                              context.push(Routes.movieDetailsPath(movie.id));
                            }
                          },
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}