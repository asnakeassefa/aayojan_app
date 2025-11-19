import 'package:flutter/material.dart';

class CustomColors {
  // Base Colors
  static const Color primary = Color(0xFF62396C);
  static const Color secondary = Color(0xFFDDFF0A);
  static const Color tertiary = Color(0xFFC7B8CA);
  static const Color warning = Color(0xFFFB8A00);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFFB8B8B8);
  static const Color success = Color(0xFF43A048);

  static const Color bgLight = Color(0xFFFFFFFF); // white
  static const Color ligthPrimary = Color(0xff805F88);
  static const Color ligthPrimary2 = Color(0xff714C7A);
  static const Color bgTeritary = Color(0xffF3EBF2);
  static const Color bgSecondary = Color(0xFF724D7B);

  static const Color contentTertiary = Color(0xFF5A5A5A);
  static const Color contentSecondary = Color(0xFF414141);
  static const Color contentPrimary = Color(0xff2A2A2A);
  static const Color contentDisabled = Color(0xFF2A2A2A);

  static Color customColor({
    required int red,
    required int green,
    required int blue,
    double opacity = 1.0,
  }) {
    return Color.fromRGBO(red, green, blue, opacity);
  }

  // Custom Colors for usage
  static Color primaryLight = Color(0xff724D7B).withOpacity(0.6);
  static Color secondaryLight = secondary.withOpacity(0.6);
  static Color warningLight = warning.withOpacity(0.6);
  static Color errorLight = error.withOpacity(0.6);
  static Color successLight = success.withOpacity(0.6);
}
