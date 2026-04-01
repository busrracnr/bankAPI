import 'package:flutter/material.dart';
import 'dart:async'; // Zamanlayıcı (Timer) için gerekli
import '../login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Ekran açıldıktan 3 saniye sonra yönlendirme yap
    Timer(const Duration(seconds: 3), () {
      // pushReplacement: Splash ekranını yığından çıkarır, geri dönülemez.
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Arka plan rengini Theme'dan çekiyoruz (Kuveyt Türk Yeşili)
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Banka Logosu (Yerine ikon koyuyoruz - Altın Rengi)
            Icon(
              Icons.account_balance, 
              size: 100, 
              color: Theme.of(context).colorScheme.secondary // Altın/Gold renk
            ),
            const SizedBox(height: 25),
            const Text(
              "Kuveyt Türk",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2
              ),
            ),
            const SizedBox(height: 50),
            // Yükleniyor belirteci (Yine altın renginde)
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}