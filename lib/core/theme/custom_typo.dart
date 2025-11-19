import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTypography {
  // Utility function to add `copyWith` functionality
  static TextStyle customStyle({
    required double fontSize,
    required double height,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: fontSize,
      height: height / fontSize,
      fontWeight: fontWeight,
      fontFamily: GoogleFonts.poppins().fontFamily,
      color: color,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  // Title XLarge
  static TextStyle titleXLarge = customStyle(
    fontSize: 34,
    height: 41,
  );

  static TextStyle titleLarge = customStyle(
    fontSize: 28,
    height: 34,
  );

  static TextStyle titleMedium = customStyle(
    fontSize: 24,
    height: 30,
  );

  static TextStyle titleSmall = customStyle(
    fontSize: 22,
    height: 30,
  );

  static TextStyle headLineLarge = customStyle(
    fontSize: 20,
    height: 26,
  );

  // Title Large
  static TextStyle headLineSmall = customStyle(
    fontSize: 18,
    height: 24,
  );

  static TextStyle subHeadLarge = customStyle(
    fontSize: 16,
    height: 20,
  );

  static TextStyle subHeadSmall = customStyle(
    fontSize: 14,
    height: 18,
  );

  static TextStyle bodyLarge = customStyle(
    fontSize: 16,
    height: 24,
    fontWeight: FontWeight.w300,
  );

  static TextStyle bodyMedium = customStyle(
    fontSize: 14,
    height: 22,
  );

  // Other text styles (Follow the same structure)
  static TextStyle bodySmall = customStyle(
    fontSize: 12,
    height: 18,
  );

  static TextStyle labelLarge = customStyle(
    fontSize: 16,
    height: 24,
  );

  static TextStyle labelMedium = customStyle(
    fontSize: 14,
    height: 18,
  );

  // Other text styles (Follow the same structure)
  static TextStyle labelSmall = customStyle(
    fontSize: 12,
    height: 16,
  );

  static TextStyle caption = customStyle(
    fontSize: 12,
    height: 16,
  );
}
