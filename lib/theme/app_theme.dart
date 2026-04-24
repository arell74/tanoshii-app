import 'package:flutter/material.dart';

class AppColors {
  static const Color ink = Color(0xFF1A1A2E);
  static const Color inkSoft = Color(0xFF2D2D4A);
  static const Color paper = Color(0xFFFAF7F2);
  static const Color vermillion = Color(0xFFD94F3D);
  static const Color gold = Color(0xFFC9A84C);
  static const Color sage = Color(0xFF4A7C6F);
  static const Color indigo = Color(0xFF3D5A8A);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gold, vermillion],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.paper,
      primaryColor: AppColors.vermillion,
      colorScheme: const ColorScheme.light(
        primary: AppColors.vermillion,
        secondary: AppColors.gold,
        surface: Colors.white,
        // ignore: deprecated_member_use
        background: AppColors.paper,
      ),
      // Kita bisa mengatur styling Text di sini nanti menggunakan Google Fonts
    );
  }
}