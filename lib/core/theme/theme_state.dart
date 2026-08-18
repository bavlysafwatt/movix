part of 'theme_cubit.dart';

@immutable
sealed class ThemeState {}

final class ThemeChanged extends ThemeState {
  final ThemeData themeData;

  ThemeChanged({required this.themeData});
}
