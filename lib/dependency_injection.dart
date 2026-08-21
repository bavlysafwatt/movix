import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movix/features/search/data/datasources/search_remote_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/api/api_consumer.dart';
import 'core/api/app_interceptors.dart';
import 'core/api/dio_consumer.dart';
import 'core/theme/theme_cubit.dart';
import 'features/details/data/datasources/details_remote_data_source.dart';
import 'features/details/data/repositories/movie_details_repository_impl.dart';
import 'features/details/domain/repositories/details_repository.dart';
import 'features/details/domain/usecases/get_movie_details_bundle.dart';
import 'features/details/domain/usecases/get_person_bundle.dart';
import 'features/details/domain/usecases/get_season_details.dart';
import 'features/details/domain/usecases/get_tv_details_bundle.dart';
import 'features/details/presentation/cubit/movie_details_cubit.dart';
import 'features/details/presentation/cubit/person_details_cubit.dart';
import 'features/details/presentation/cubit/season_details_cubit.dart';
import 'features/details/presentation/cubit/tv_details_cubit.dart';
import 'features/discover/data/datasources/discover_remote_data_source.dart';
import 'features/discover/data/repositories/discover_repository_impl.dart';
import 'features/discover/domain/repositories/discover_repository.dart';
import 'features/discover/domain/usecases/discover_movies.dart';
import 'features/discover/domain/usecases/get_genres.dart';
import 'features/discover/presentation/cubit/discover_cubit.dart';
import 'features/discover/presentation/cubit/genre_cubit.dart';
import 'features/home/data/datasources/home_remote_data_source.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/repositories/home_repository.dart';
import 'features/home/domain/usecases/get_home_sections.dart';
import 'features/home/presentation/cubit/home_cubit.dart';
import 'features/library/data/datasources/library_remote_data_source.dart';
import 'features/library/data/repositories/library_repository_impl.dart';
import 'features/library/domain/repositories/library_repository.dart';
import 'features/library/domain/usecases/get_library_status.dart';
import 'features/library/domain/usecases/rate_item.dart';
import 'features/library/domain/usecases/toggle_favorite.dart';
import 'features/library/domain/usecases/toggle_watched.dart';
import 'features/library/domain/usecases/toggle_watchlist.dart';
import 'features/search/data/datasources/search_local_data_source.dart';
import 'features/search/data/repositories/search_repository_impl.dart';
import 'features/search/domain/repositories/search_repository.dart';
import 'features/search/domain/usecases/recent_searches.dart';
import 'features/search/domain/usecases/search_movies.dart';
import 'features/search/presentation/cubit/search_cubit.dart';
import 'features/settings/data/datasources/settings_local_data_source.dart';
import 'features/settings/data/datasources/settings_remote_data_source.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/domain/usecases/get_current_user.dart';
import 'features/settings/domain/usecases/get_region.dart';
import 'features/settings/domain/usecases/logout.dart';
import 'features/settings/domain/usecases/set_region.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/splash/data/datasources/splash_local_data_source.dart';
import 'features/splash/data/datasources/splash_session_data_source.dart';
import 'features/splash/data/repositories/splash_repository_impl.dart';
import 'features/splash/domain/repositories/splash_repository.dart';
import 'features/splash/domain/usecases/get_initial_destination.dart';
import 'features/splash/presentation/cubit/splash_cubit.dart';
import 'features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'features/onboarding/domain/repositories/onboarding_repository.dart';
import 'features/onboarding/domain/usecases/complete_onboarding.dart';
import 'features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/sign_in_with_google.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

final getIt = GetIt.instance;

Future<void> initGetIt() async {
  // Theme
  getIt.registerFactory<ThemeCubit>(() => ThemeCubit());

  // Supabase
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // Core - API
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<AppInterceptors>(() => AppInterceptors());
  getIt.registerLazySingleton<LogInterceptor>(
        () => LogInterceptor(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
      error: true,
    ),
  );
  getIt.registerLazySingleton<ApiConsumer>(
        () => DioConsumer(client: getIt<Dio>()),
  );

  // Splash
  getIt.registerLazySingleton<SplashLocalDataSource>(
    SplashLocalDataSourceImpl.new,
  );
  getIt.registerLazySingleton<SplashSessionDataSource>(
    () => SplashSessionDataSourceImpl(getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton<SplashRepository>(
    () => SplashRepositoryImpl(
      localDataSource: getIt<SplashLocalDataSource>(),
      sessionDataSource: getIt<SplashSessionDataSource>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetInitialDestination(getIt<SplashRepository>()),
  );
  getIt.registerFactory(
    () => SplashCubit(getIt<GetInitialDestination>()),
  );

  // Onboarding
  getIt.registerLazySingleton<OnboardingLocalDataSource>(
    OnboardingLocalDataSourceImpl.new,
  );
  getIt.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(getIt<OnboardingLocalDataSource>()),
  );
  getIt.registerLazySingleton(
    () => CompleteOnboarding(getIt<OnboardingRepository>()),
  );
  getIt.registerFactory(
    () => OnboardingCubit(getIt<CompleteOnboarding>()),
  );

  // Auth
  getIt.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn.instance);

  getIt.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(getIt<SupabaseClient>(), getIt<GoogleSignIn>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );
  getIt.registerLazySingleton(() => SignInWithGoogle(getIt<AuthRepository>()));
  getIt.registerFactory(
    () => AuthCubit(
      repository: getIt<AuthRepository>(),
      signInWithGoogle: getIt<SignInWithGoogle>(),
    ),
  );

  // Home
  getIt.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(getIt<ApiConsumer>()));
  getIt.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(getIt<HomeRemoteDataSource>()));
  getIt.registerLazySingleton<GetHomeSections>(() => GetHomeSections(getIt<HomeRepository>()));
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt<GetHomeSections>()));

  // Settings
  getIt.registerLazySingleton<SettingsRemoteDataSource>(() => SettingsRemoteDataSourceImpl(getIt<SupabaseClient>()));
  getIt.registerLazySingleton<SettingsLocalDataSource>(() => const SettingsLocalDataSourceImpl());
  getIt.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(getIt<SettingsRemoteDataSource>(), getIt<SettingsLocalDataSource>()));
  getIt.registerLazySingleton<GetCurrentUser>(() => GetCurrentUser(getIt<SettingsRepository>()));
  getIt.registerLazySingleton<GetRegion>(() => GetRegion(getIt<SettingsRepository>()));
  getIt.registerLazySingleton<SetRegion>(() => SetRegion(getIt<SettingsRepository>()));
  getIt.registerLazySingleton<Logout>(() => Logout(getIt<SettingsRepository>()));
  getIt.registerFactory<SettingsCubit>(() => SettingsCubit(
    getIt<GetCurrentUser>(), getIt<GetRegion>(), getIt<SetRegion>(), getIt<Logout>(),
  ));

  // Search
  getIt.registerLazySingleton<SearchRemoteDataSource>(() => SearchRemoteDataSourceImpl(getIt<ApiConsumer>()));
  getIt.registerLazySingleton<SearchLocalDataSource>(() => const SearchLocalDataSourceImpl());
  getIt.registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(getIt<SearchRemoteDataSource>(), getIt<SearchLocalDataSource>()));
  getIt.registerLazySingleton<SearchMovies>(() => SearchMovies(getIt<SearchRepository>()));
  getIt.registerLazySingleton<GetRecentSearches>(() => GetRecentSearches(getIt<SearchRepository>()));
  getIt.registerLazySingleton<SaveRecentSearch>(() => SaveRecentSearch(getIt<SearchRepository>()));
  getIt.registerLazySingleton<ClearRecentSearches>(() => ClearRecentSearches(getIt<SearchRepository>()));
  getIt.registerFactory<SearchCubit>(() => SearchCubit(
    getIt<SearchMovies>(), getIt<GetRecentSearches>(), getIt<SaveRecentSearch>(), getIt<ClearRecentSearches>(),
  ));

  // Discover
  getIt.registerLazySingleton<DiscoverRemoteDataSource>(() => DiscoverRemoteDataSourceImpl(getIt<ApiConsumer>()));
  getIt.registerLazySingleton<DiscoverRepository>(() => DiscoverRepositoryImpl(getIt<DiscoverRemoteDataSource>()));
  getIt.registerLazySingleton<GetGenres>(() => GetGenres(getIt<DiscoverRepository>()));
  getIt.registerLazySingleton<DiscoverMovies>(() => DiscoverMovies(getIt<DiscoverRepository>()));
  getIt.registerFactory<GenreCubit>(() => GenreCubit(getIt<GetGenres>()));
  getIt.registerFactory<DiscoverCubit>(() => DiscoverCubit(getIt<DiscoverMovies>()));

  // Library
  getIt.registerLazySingleton<LibraryRemoteDataSource>(() => LibraryRemoteDataSourceImpl(getIt<SupabaseClient>()));
  getIt.registerLazySingleton<LibraryRepository>(() => LibraryRepositoryImpl(getIt<LibraryRemoteDataSource>()));
  getIt.registerLazySingleton<GetLibraryStatus>(() => GetLibraryStatus(getIt<LibraryRepository>()));
  getIt.registerLazySingleton<ToggleFavorite>(() => ToggleFavorite(getIt<LibraryRepository>()));
  getIt.registerLazySingleton<ToggleWatchlist>(() => ToggleWatchlist(getIt<LibraryRepository>()));
  getIt.registerLazySingleton<ToggleWatched>(() => ToggleWatched(getIt<LibraryRepository>()));
  getIt.registerLazySingleton<RateItem>(() => RateItem(getIt<LibraryRepository>()));

  // Movie Details
  getIt.registerLazySingleton<DetailsRemoteDataSource>(() => DetailsRemoteDataSourceImpl(getIt<ApiConsumer>()));
  getIt.registerLazySingleton<DetailsRepository>(() => DetailsRepositoryImpl(getIt<DetailsRemoteDataSource>()));
  getIt.registerLazySingleton<GetMovieDetailsBundle>(() => GetMovieDetailsBundle(getIt<DetailsRepository>()));
  getIt.registerLazySingleton<GetTvDetailsBundle>(() => GetTvDetailsBundle(getIt<DetailsRepository>()));
  getIt.registerLazySingleton<GetSeasonDetails>(() => GetSeasonDetails(getIt<DetailsRepository>()));
  getIt.registerLazySingleton<GetPersonBundle>(() => GetPersonBundle(getIt<DetailsRepository>()));
  getIt.registerFactory<MovieDetailsCubit>(() => MovieDetailsCubit(
    getIt<GetMovieDetailsBundle>(), getIt<GetRegion>(), getIt<GetLibraryStatus>(), getIt<ToggleFavorite>(),
    getIt<ToggleWatchlist>(), getIt<ToggleWatched>(), getIt<RateItem>(),
  ));
  getIt.registerFactory<TvDetailsCubit>(() => TvDetailsCubit(
    getIt<GetTvDetailsBundle>(),
    getIt<GetLibraryStatus>(),
    getIt<GetRegion>(),
    getIt<ToggleFavorite>(),
    getIt<ToggleWatchlist>(),
    getIt<ToggleWatched>(),
    getIt<RateItem>(),
  ));
  getIt.registerFactory<SeasonDetailsCubit>(() => SeasonDetailsCubit(getIt<GetSeasonDetails>()));
  getIt.registerFactory<PersonDetailsCubit>(() => PersonDetailsCubit(getIt<GetPersonBundle>()));
}
