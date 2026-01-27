// lib/themes/app_themes.dart
import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppThemes {
  static ThemeData dropdownSearchTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      colorScheme: ColorScheme.light(
        primary: Colors.grey.shade700,   // focus border, cursor
        onPrimary: Colors.white,         // header text/icon
        onSurface: kBlackColor,          // input text
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white, // field background
        hintStyle: TextStyle(color: Colors.grey.shade600),
        labelStyle: const TextStyle(color: kPrimaryDark),
      ),
      iconTheme:const IconThemeData(color: kBlackColor),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: kBlackColor),
      ),
    );
  }
}
