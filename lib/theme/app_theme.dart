import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color accentRed = Color(0xFFFF5252);
  static const Color textColor = Color(0xFF333333);
  static const Color lightGrey = Color(0xFFF5F5F5);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryRed,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(
        primary: primaryRed,
        secondary: accentRed,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        color: primaryRed,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3,
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: lightGrey,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryRed, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: Colors.grey[600]),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        titleLarge: TextStyle(
          color: textColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      // Add dropdown menu styling
      popupMenuTheme: PopupMenuThemeData(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      // Customize the DropdownButton
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          fillColor: lightGrey,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryRed, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        menuStyle: MenuStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          elevation: MaterialStateProperty.all(3),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textStyle: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
      ),
    );
  }
}