import 'package:flutter/material.dart';
import 'package:music_app/core/core.dart';
import 'colors_custom.dart';

class AppTheme {
  ThemeData getDarkTheme() => ThemeData(
        // useMaterial3: true,
        //primaryColor: ColorsCustom.primary,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ColorsCustom.darkBackground,
        colorScheme: const ColorScheme.dark(
          primary: ColorsCustom.darkPrimary,
          secondary: ColorsCustom.blue,
          //secondary: ColorsCustom.secondary,
        ),
        appBarTheme: const AppBarTheme(
          color: ColorsCustom.darkPrimary,
          foregroundColor: Colors.white,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Colors.black87,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
      );

  static Brightness currentSystemBrightness(BuildContext context) =>
      MediaQuery.platformBrightnessOf(context);
}

extension ThemeExtras on ThemeData {
  Color get navBarItemColor => ColorsCustom.blue;
}
