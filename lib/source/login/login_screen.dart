import 'package:flutter/material.dart';
import '../components/primary_button.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance, size: 80, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 20),
            const Text("Hoş Geldiniz", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            const TextField(
              decoration: InputDecoration(
                labelText: "Müşteri / TCKN",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Şifre",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            PrimaryButton(
              text: "Giriş Yap", 
              onPressed: () {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (context) => const HomeScreen())
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}