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
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox.expand(),
            // Logo ve Başlık
            Column(
              children: [
                // Kuveyt Türk Logo (Palm Tree Icon)
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.teal, width: 3),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    size: 70,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Kuveit Türk Mobil",
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            // Alt kısımda Loading
            Column(
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade700),
                  strokeWidth: 3,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}