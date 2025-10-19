import 'package:flutter/material.dart';

ThemeData lightThemee = ThemeData.light();

ThemeData darkThemee = ThemeData.dark();

ThemeData customlightTheme = ThemeData.light().copyWith(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(backgroundColor: Color(0xff095263)),

  primaryColor: Color(0xff095263),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(Color(0xff095263)),
    ),
  ),

  // ignore: prefer_const_constructors
  textTheme: TextTheme(
    displayLarge: TextStyle(
      backgroundColor: Color(0xff095263),
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
    displayMedium: TextStyle(
      //  fontFamily: "Cairo",
      fontSize: 30,
      color: Colors.black87,
      fontWeight: FontWeight.w600,
    ),
    displaySmall: TextStyle(
      height: 1.8,
      color: Colors.black87,
      fontSize: 20,
      // fontWeight: FontWeight.w500,
      fontFamily: "Med",
    ),
    headlineLarge: TextStyle(
      color: Colors.white,
      fontSize: 28,
      fontWeight: FontWeight.w900,
      fontFamily: "Amiri",
      //   fontFamily: "Cairo",
    ),
    headlineMedium: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    titleLarge: TextStyle(
      color: Colors.black54,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      fontFamily: "Amiri",
    ),
    titleMedium: TextStyle(
      fontFamily: "Amiri",
      fontSize: 16,
      color: Colors.black54,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      fontFamily: "Amiri",
      fontSize: 10,
      color: Colors.black54,
      fontWeight: FontWeight.w600,
    ),
    labelSmall: TextStyle(
      height: 1.8,

      fontSize: 20,
      fontWeight: FontWeight.w400,
      fontFamily: "Amiri",
    ),
    bodyMedium: TextStyle(
      //  fontFamily: "Cairo",
      fontSize: 30,
      color: Color(0xff095263),
      fontWeight: FontWeight.w600,
    ),
  ),

  //    colorScheme: ColorScheme(surface: Colors.white),
);
ThemeData customDarkTheme = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(backgroundColor: Color(0xff18191A)),
  primaryColor: Color(0xff18191A),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(Color(0xff095263)),
    ),
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      backgroundColor: Color(0xff18191A),
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
    displayMedium: TextStyle(
      //  fontFamily: "Cairo",
      fontSize: 30,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
    displaySmall: TextStyle(
      height: 1.8,
      fontSize: 20,
      // fontWeight: FontWeight.w500,
      color: Colors.white70,
      fontFamily: "Med",
    ),
    headlineLarge: TextStyle(
      color: Color(0xffB0BEC5),
      fontSize: 28,
      fontWeight: FontWeight.w500,
      fontFamily: "Amiri",
      //   fontFamily: "Cairo",
    ),
    headlineMedium: TextStyle(
      color: Color(0xffB0BEC5),
      fontSize: 16,
      fontWeight: FontWeight.w500,
      //   fontFamily: "Cairo",
    ),
    titleLarge: TextStyle(
      fontFamily: "Amiri",
      fontSize: 22,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      fontFamily: "Amiri",
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      fontFamily: "Amiri",
      fontSize: 10,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
    labelSmall: TextStyle(
      height: 1.8,
      color: Color(0xff18191A),
      fontSize: 20,
      fontWeight: FontWeight.w400,
      fontFamily: "Amiri",
    ),
    bodyMedium: TextStyle(
      //  fontFamily: "Cairo",
      fontSize: 30,
      color: Color.fromARGB(255, 170, 169, 169),
      fontWeight: FontWeight.w600,
    ),
  ),
  //  colorScheme: ColorScheme(surface: Color(0xff303030)),
);
