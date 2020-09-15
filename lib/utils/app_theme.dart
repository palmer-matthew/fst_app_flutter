import 'package:flutter/material.dart';
import 'package:fst_app_flutter/models/preferences/theme_model.dart';

/// Contains all the [ThemeData] for the app and methods to retrieve a theme 
/// based on the current theme and [Brightness] of the platform.
class AppTheme {

  /// A light theme colour scheme based on Material design. 
  static ColorScheme _lightColorScheme = ColorScheme(
      primary: Color(0xFF003D8A),
      primaryVariant: Color(0xFF00185C),
      secondary: Color(0xFF1565BF),
      secondaryVariant: Color(0xFF003C8E),
      surface: Colors.white,
      background: Colors.white,
      error: Color(0xFF931621),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light);

  /// A dark colour scheme based on material design.
  static ColorScheme _darkColorScheme = ColorScheme(
    primary: Color(0xff5578E2),
    primaryVariant: Color(0xFF00185C),
    secondary: Color(0xFF5E92F2),
    secondaryVariant: Color(0xFF5E92F2),
    surface: Color(0xff121212),
    background: Color(0xff121212),
    error: Color(0xffcf6679),
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.black,
    brightness: Brightness.dark,
  );

  /// The default text themes using Montserrat as the font
  static var _textTheme = Typography.material2018().copyWith(
      black: Typography.blackMountainView.apply(fontFamily: _fontFamily),
      dense: Typography.dense2018.apply(fontFamily: _fontFamily),
      englishLike: Typography.englishLike2018.apply(fontFamily: _fontFamily),
      tall: Typography.tall2018.apply(fontFamily: _fontFamily),
      white: Typography.whiteMountainView.apply(fontFamily: _fontFamily));

  static String _fontFamily = 'Montserrat';

  /// The dark [ThemeData] for this app created using the [_darkColorScheme].
  static ThemeData _darkTheme =
      ThemeData.from(colorScheme: _darkColorScheme, textTheme: _textTheme.white)
          .copyWith(toggleableActiveColor: _darkColorScheme.secondary);

  /// The light [ThemeData] for this app created using the [_lightColorScheme].
  static ThemeData _lightTheme = ThemeData.from(
      colorScheme: _lightColorScheme, textTheme: _textTheme.black);

  /// Gets the current [ThemeData] based off the [ThemeMode] and [platformBrightness].
  static ThemeData getTheme(ThemeMode mode, Brightness platformBrightness) {
    if (mode == ThemeMode.dark) {
      return _darkTheme;
    } else if (mode == ThemeMode.light) {
      return _lightTheme;
    } else {
      return platformBrightness == Brightness.light ? _lightTheme : _darkTheme;
    }
  }


  /// Gets the current [ThemeData] based on the [ThemeModel].
  static ThemeData getFromModel(ThemeModel model) =>
      model.isDark ? _darkTheme : _lightTheme;
}
