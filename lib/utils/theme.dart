import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: kPrimaryColor,
    ),
    scaffoldBackgroundColor: kScaffoldBackgroundColor,
    fontFamily: GoogleFonts.comfortaa().fontFamily,
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      scrolledUnderElevation: 0.0,
      backgroundColor: kScaffoldBackgroundColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: _buildOutlineInputBorder(kPrimaryColor),
      focusedBorder: _buildOutlineInputBorder(kPrimaryColor),
      errorBorder: _buildOutlineInputBorder(kErrorColor),
      focusedErrorBorder: _buildOutlineInputBorder(kErrorColor),
      hintStyle: TextStyle(color: kNeutralColors[2]),
      errorStyle: TextStyle(color: kErrorColor),
      contentPadding: EdgeInsets.all(0.5 * kPadding),
    ),
    snackBarTheme: SnackBarThemeData(
      elevation: 0.0,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(kBorderRadius),
        ),
      ),
    ),
    bannerTheme: MaterialBannerThemeData(
      elevation: 0.0,
      padding: EdgeInsets.zero,
    ),
    dividerTheme: DividerThemeData(
      color: kNeutralColors[2],
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        backgroundColor: kPrimaryColor,
        foregroundColor: kNeutralColors[1],
        padding: EdgeInsets.symmetric(
          horizontal: 2.0 * kPadding,
          vertical: 0.4 * kPadding,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: kPrimaryColor,
        splashFactory: InkRipple.splashFactory,
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: kNeutralColors[1],
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(kBorderRadius),
        ),
      ),
    ),
    dialogTheme: DialogTheme(
      elevation: 10.0,
      backgroundColor: kNeutralColors[1],
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(kBorderRadius),
        ),
      ),
    ),
  );
}

OutlineInputBorder _buildOutlineInputBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(kBorderRadius),
    ),
    borderSide: BorderSide(
      color: color,
      width: kLineThickness,
    ),
  );
}
