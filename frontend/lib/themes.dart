import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'design_configs.dart';


ThemeData defaultTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: DesignConfigs.whiteColor,
    colorScheme: ColorScheme.light(
        primary: DesignConfigs.purpleColor,
        onPrimary: Colors.white,
        surface: DesignConfigs.whiteColor,
        secondary: DesignConfigs.blueColor,
        onSurface: DesignConfigs.grayColor
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: DesignConfigs.whiteColor,
    ),
    textTheme:  GoogleFonts.montserratTextTheme(
      ThemeData.light().textTheme,
    ).apply(
      bodyColor: DesignConfigs.grayColor,
      displayColor: DesignConfigs.grayColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: DesignConfigs.brownColor,
            foregroundColor: DesignConfigs.whiteColor,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 17),
            fixedSize: const Size.fromHeight(45),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            textStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                letterSpacing: 0.5,
                color: DesignConfigs.whiteColor
            )
        )
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      dividerColor: DesignConfigs.blueColor,
      headerBackgroundColor: DesignConfigs.blueColor,
      headerForegroundColor: Colors.white,
      cancelButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {return Colors.white;}),
          backgroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {return DesignConfigs.blueColor;})
      ),
      confirmButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {return Colors.white;}),
          backgroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {return DesignConfigs.purpleColor;})
      ),
      dayOverlayColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {return DesignConfigs.blueColor;}),
      dayForegroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {return DesignConfigs.grayColor;}),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
          fontSize: 16,
          color: DesignConfigs.grayColor
      ),
      prefixIconColor: DesignConfigs.orangeColor,
      suffixIconColor: DesignConfigs.orangeColor,
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: DesignConfigs.brownColor)
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: DesignConfigs.grayColor)
      ),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: DesignConfigs.grayColor)
      ),
      focusColor: DesignConfigs.brownColor,
      fillColor: DesignConfigs.orangeColor,
      floatingLabelStyle: TextStyle(color: DesignConfigs.brownColor)
    ),
    iconTheme: IconThemeData(
        color: DesignConfigs.orangeColor
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: DesignConfigs.brownColor,
      contentTextStyle: TextStyle(
        fontSize: 16,
        color: DesignConfigs.whiteColor
      )
    )
  );
}