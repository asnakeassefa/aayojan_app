import 'package:aayojan/core/theme/custom_colors.dart';
import 'package:aayojan/core/theme/custom_typo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';




// set light and dark theme
ThemeData lightTheme = ThemeData(
  fontFamily: GoogleFonts.poppins().fontFamily,
  // I want all text colors to be white

  scaffoldBackgroundColor: const Color(0xff62396c),
  colorScheme: const ColorScheme.light(
    primary: Color(0xff62396C),
    secondary: Color(0xffffffff),
    tertiary: Color(0xffF97316),
  ),
  // checkboxTheme: CheckboxThemeData(
  //   fillColor: WidgetStateProperty.all(CustomColors.bgLight.withOpacity(0.2)),
  //   checkColor: WidgetStateProperty.all(Colors.white),
  // ),

  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xff62396c),
    surfaceTintColor: const Color(0xff62396c),
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: CustomTypography.titleSmall.copyWith(color: Colors.white),
  ),

  // inputDecorationTheme: InputDecorationTheme(
  //   // border: OutlineInputBorder(
  //   //   borderRadius: BorderRadius.circular(50),
  //   //   borderSide:
  //   //       const BorderSide(color: CustomColors.primary), // Default border
  //   // ),

  //   // focusedBorder: OutlineInputBorder(
  //   //   borderRadius: BorderRadius.circular(50),
  //   //   borderSide:
  //   //       BorderSide(color: CustomColors.bgLight), // Border when not focused
  //   // ),

  // ),

  // ... other theme properties
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,

  colorScheme: ColorScheme.dark(
      primary: Colors.white,
      secondary: Color(0xffA1A1AA),
      tertiary: Color(0xffF97316),
      surface: Colors.black,
      background:
          Color(0xff3F3F46) // Fills the remaining parts of the app window
      ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    // color: Colors.black
  ),
  iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
          padding: WidgetStatePropertyAll(
    EdgeInsets.all(1),
  ))),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Color(0xffD9D9D9)), // Default border
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide:
          BorderSide(color: Color(0xffD9D9D9)), // Border when not focused
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: CustomColors.error),
    ),

    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: CustomColors.error),
    ),
    // focusedBorder: OutlineInputBorder(
    //   borderRadius: BorderRadius.circular(8),
    //   borderSide: BorderSide(color: Colors.blue),
    // ),
  ),
  textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xff3f3f46)),
      bodySmall: TextStyle(color: Color(0xff3f3f46)),
      bodyLarge: TextStyle(color: Color(0xff3f3f46)),
      displaySmall: TextStyle(color: Color(0xff3f3f46)),
      displayMedium: TextStyle(color: Color(0xff3f3f46)),
      displayLarge: TextStyle(color: Color(0xff3f3f46))),
  // ... other theme properties
);

const Color borderColor = Color(0xffD9D9D9);

class CustomAppColors extends ThemeExtension<CustomAppColors> {
  final Color warning;
  final Color info;
  final Color success;

  CustomAppColors({
    required this.warning,
    required this.info,
    required this.success,
  });

  @override
  CustomAppColors copyWith({
    Color? warning,
    Color? info,
    Color? success,
  }) {
    return CustomAppColors(
      warning: warning ?? this.warning,
      info: info ?? this.info,
      success: success ?? this.success,
    );
  }

  @override
  CustomAppColors lerp(ThemeExtension<CustomAppColors>? other, double t) {
    if (other is! CustomAppColors) return this;
    return CustomAppColors(
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      success: Color.lerp(success, other.success, t)!,
    );
  }
}
