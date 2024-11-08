import 'package:flutter/material.dart';
import 'package:parrotpos/style/colors.dart';

ThemeData themeData = ThemeData(
  useMaterial3: false,
  // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
  primaryColor: Colors.blue,
  // highlightColor: Colors.transparent,
  // splashColor: Colors.transparent,
  // splashFactory: NoSplash.splashFactory,
  // hoverColor: Colors.transparent,
  scaffoldBackgroundColor: kWhite,
  appBarTheme: const AppBarTheme(
    surfaceTintColor: Colors.white,
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(
      color: kBlack,
    ),
  ),

  dialogTheme: DialogTheme(
    backgroundColor: Colors.white, // Set dialog background color to white
  ),
  // buttonTheme: ButtonThemeData(
  //   splashColor: Colors.blue,
  //   hoverColor: Colors.blue,
  // ),
  // checkboxTheme: CheckboxThemeData(
  // fillColor: MaterialStateProperty.all(kColorPrimaryDark),
  // checkColor: MaterialStateProperty.all(kWhite),
  // ),
);
                  