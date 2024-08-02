import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppColors {
  static final darkBlue = ColorScheme.fromSeed(
    seedColor: Colors.lightBlue,
    brightness: Brightness.dark,
    secondaryContainer: Colors.black38,
  );
}

class MyAppTheme {
  static final kDarkColor = MyAppColors.darkBlue;

  static final darkTheme = ThemeData.dark().copyWith(
                            colorScheme: kDarkColor,
                            textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme)
                          );
}
