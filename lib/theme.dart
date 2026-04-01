import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF006837), // Kuveyt Türk Yeşili
        primary: const Color(0xFF006837),
        secondary: const Color(0xFFBA9645), // Altın/Gold detaylar
        surface: Colors.white,
      ),
      // Buton temalarını global tanımlıyoruz
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}