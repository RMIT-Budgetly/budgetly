import 'package:flutter/material.dart';

import '../constants/style.dart';
import 'package:personal_finance/constants/colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: customColorScheme,
    scaffoldBackgroundColor: white,
    useMaterial3: false,
    appBarTheme: const AppBarTheme(
      color: grey3,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: blue5),
      titleTextStyle: TextStyle(
        color: primaryBlack,
        fontSize: 50,
        fontWeight: FontWeight.w700,
      ),
    ),
    disabledColor: grey2,
    fontFamily: 'Poppins',
  );
}

ColorScheme customColorScheme = const ColorScheme(
  primary: blue1,
  primaryContainer: white,
  secondary: blue5,
  tertiary: blue7,
  surface: grey3,
  background: white,
  error: red,
  onPrimary: white,
  onSecondary: white,
  onSurface: blue1,
  onBackground: blue1,
  onError: primaryBlack,
  brightness: Brightness.light,
);

ColorScheme darkCustomColorScheme = const ColorScheme(
  primary: darkBlue1,
  primaryContainer: darkGrey4,
  secondary: darkBlue5,
  tertiary: darkBlue7,
  surface: darkBlue7, //darkBlue3
  background: darkWhite,
  error: darkRed,
  onPrimary: darkWhite,
  onSecondary: darkWhite,
  onSurface: darkBlue1,
  onBackground: darkBlue1,
  onError: darkBlack,
  brightness: Brightness.dark,
);
