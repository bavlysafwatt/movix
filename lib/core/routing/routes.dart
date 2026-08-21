class Routes {
  static const String splashScreen = '/splashScreen';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/home';
  static const String search = '/search';
  static const String discover = '/discover';
  static const String discoverResults = '/discover/results';
  static const String library = '/library';
  static const String settings = '/settings';
  static const String movieDetails = '/movie/:id';
  static String movieDetailsPath(int id) => '/movie/$id';
  static const String tvDetails = '/tv/:id';
  static String tvDetailsPath(int id) => '/tv/$id';
  static const String seasonDetails = '/tv/:id/season/:seasonNumber';
  static String seasonDetailsPath(int tvId, int seasonNumber) => '/tv/$tvId/season/$seasonNumber';
  static const String personDetails = '/person/:id';
  static String personDetailsPath(int id) => '/person/$id';
  static const String trailer = '/trailer/:videoId';
  static String trailerPath(String videoId) => '/trailer/$videoId';
}
