import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';
import 'source/splash/splash_screen.dart'; // Yeni import

void main() {
  runApp(const ProviderScope(child: BankApp()));
}

class BankApp extends StatelessWidget {
  const BankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kuveyt Türk Clone',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(), // Uygulama artık Splash ile başlar
    );
  }
}