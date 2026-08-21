class EndPoints {
  static const String baseUrl = 'https://api.themoviedb.org/3/';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/';

  // Image sizes
  static const String posterW342 = 'w342';
  static const String posterW500 = 'w500';
  static const String backdropW780 = 'w780';
  static const String backdropOriginal = 'original';
  static const String profileW185 = 'w185';
  static const String logoW92 = 'w92';

  // Trending / lists
  static const String trendingAllDay = 'trending/all/day';
  static const String trendingAllWeek = 'trending/all/week';
  static const String popularMovies = 'movie/popular';
  static const String topRatedMovies = 'movie/top_rated';
  static const String upcomingMovies = 'movie/upcoming';
  static const String nowPlayingMovies = 'movie/now_playing';
  static const String popularTv = 'tv/popular';
  static const String topRatedTv = 'tv/top_rated';

  // Movie details
  static String movieDetails(int id) => 'movie/$id';
  static String movieCredits(int id) => 'movie/$id/credits';
  static String movieVideos(int id) => 'movie/$id/videos';
  static String movieSimilar(int id) => 'movie/$id/similar';
  static String movieRecommendations(int id) => 'movie/$id/recommendations';
  static String movieWatchProviders(int id) => 'movie/$id/watch/providers';

  // TV details
  static String tvDetails(int id) => 'tv/$id';
  static String tvCredits(int id) => 'tv/$id/credits';
  static String tvVideos(int id) => 'tv/$id/videos';
  static String tvSeasonDetails(int id, int seasonNumber) =>
      'tv/$id/season/$seasonNumber';
  static String tvSimilar(int id) => 'tv/$id/similar';
  static String tvRecommendations(int id) => 'tv/$id/recommendations';
  static String tvWatchProviders(int id) => 'tv/$id/watch/providers';


  // Discover / genres
  static const String discoverMovie = 'discover/movie';
  static const String discoverTv = 'discover/tv';
  static const String movieGenres = 'genre/movie/list';
  static const String tvGenres = 'genre/tv/list';

  // Search
  static const String searchMulti = 'search/multi';
  static const String searchMovie = 'search/movie';
  static const String searchTv = 'search/tv';
  static const String searchPerson = 'search/person';

  // Person
  static String personDetails(int id) => 'person/$id';
  static String personMovieCredits(int id) => 'person/$id/movie_credits';
  static String personCombinedCredits(int id) => 'person/$id/combined_credits';
}