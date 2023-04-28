import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ThemeProvider{
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: ColorProvider.light.withOpacity(0.80),
      secondary: ColorProvider.blueDark,
      primaryContainer: ColorProvider.dark,
      secondaryContainer: ColorProvider.dark,
    ),
    scaffoldBackgroundColor: ColorProvider.dark,
    primaryColor: ColorProvider.dark,
    textTheme: const TextTheme(
      bodySmall: TextStyle(color: ColorProvider.light),
      bodyMedium: TextStyle(color: ColorProvider.light),
      bodyLarge: TextStyle(color: ColorProvider.light),
      displaySmall: TextStyle(color: ColorProvider.light),
      displayMedium: TextStyle(color: ColorProvider.light),
      displayLarge: TextStyle(color: ColorProvider.light),
      headlineSmall: TextStyle(color: ColorProvider.light),
      headlineMedium: TextStyle(color: ColorProvider.light),
      headlineLarge: TextStyle(color: ColorProvider.light),
      titleSmall: TextStyle(color: ColorProvider.light),
      titleMedium: TextStyle(color: ColorProvider.light),
      titleLarge: TextStyle(color: ColorProvider.light),
      labelSmall: TextStyle(color: ColorProvider.light),
      labelMedium: TextStyle(color: ColorProvider.light),
      labelLarge: TextStyle(color: ColorProvider.light),
    ),
  );
  static final lightTheme = ThemeData(
    //useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: ColorProvider.dark.withOpacity(0.8),
      secondary: ColorProvider.blueLight,
      primaryContainer: ColorProvider.light,
      secondaryContainer: ColorProvider.light,
    ),
    scaffoldBackgroundColor: ColorProvider.light,
    primaryColor: ColorProvider.light,
    textTheme:  const TextTheme(
      bodySmall: TextStyle(color: ColorProvider.dark),
      bodyMedium: TextStyle(color: ColorProvider.dark),
      bodyLarge: TextStyle(color: ColorProvider.dark),
      displaySmall: TextStyle(color: ColorProvider.dark),
      displayMedium: TextStyle(color: ColorProvider.dark),
      displayLarge: TextStyle(color: ColorProvider.dark),
      headlineSmall: TextStyle(color: ColorProvider.dark),
      headlineMedium: TextStyle(color: ColorProvider.dark),
      headlineLarge: TextStyle(color: ColorProvider.dark),
      titleSmall: TextStyle(color: ColorProvider.dark),
      titleMedium: TextStyle(color: ColorProvider.dark),
      titleLarge: TextStyle(color: ColorProvider.dark),
      labelSmall: TextStyle(color: ColorProvider.dark),
      labelMedium: TextStyle(color: ColorProvider.dark),
      labelLarge: TextStyle(color: ColorProvider.dark),
    ),
  );
}

class ColorProvider{

  static bool isThemeDark([BuildContext? context]) {
    if(context == null){
      return Get.isDarkMode;
    } else {
      return context.isDarkMode;
    }

  }

  static const light = Color(0xffF7F0F0);
  static const yellowLight = Color(0xffF8C674);
  static const blueLight = Color(0xff8AF3FF);
  static const greenLight = Color(0xff5EE8d8);


  static const dark = Color(0xff3F3B40);
  static const yellowDark = Color(0xffBF9060);
  static const greenDark = Color(0xff39BFAB);
  static const blueDark = Color(0xff2FABBF);
}