// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:movix/core/helpers/shared_pref_helper.dart';
import 'package:movix/core/utils/constants.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = Constants.themeKey;

  static final lightTheme = FlexThemeData.light(
    scheme: FlexScheme.bahamaBlue,
    fontFamily: "Cairo",
  );
  static final darkTheme = FlexThemeData.dark(
    scheme: FlexScheme.bahamaBlue,
    fontFamily: "Cairo",
  ).copyWith(scaffoldBackgroundColor: Color(0xff14171a));
  static ThemeData currentTheme = darkTheme;

  ThemeCubit() : super(ThemeChanged(themeData: currentTheme)) {
    _loadSavedTheme();
  }

  void _loadSavedTheme() {
    final isDarkTheme = SharedPrefHelper.getBool(key: _themeKey);
    currentTheme = isDarkTheme! ? darkTheme : lightTheme;
    emit(ThemeChanged(themeData: currentTheme));
  }

  void toggleTheme() {
    if (currentTheme == lightTheme) {
      currentTheme = darkTheme;
      SharedPrefHelper.setData(key: _themeKey, value: true);
    } else {
      currentTheme = lightTheme;
      SharedPrefHelper.setData(key: _themeKey, value: false);
    }
    emit(ThemeChanged(themeData: currentTheme));
  }
}
