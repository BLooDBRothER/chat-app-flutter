import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyAppColors {
  static final darkBlue = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 23, 24, 27),
);
}

class MyAppTheme {
  static final kDarkColor = MyAppColors.darkBlue;

  static final darkTheme =ThemeData.dark().copyWith(
        colorScheme: kDarkColor,
      );
}
