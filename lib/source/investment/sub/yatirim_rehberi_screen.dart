import 'package:flutter/material.dart';

class YatirimRehberiScreen extends StatelessWidget {
  const YatirimRehberiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text("Yatırım Rehberim",
            style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_circle_outlined, size: 72, color: Colors.grey.shade300),
            const SizedBox(height: 20),
            const Text(
              "Yanıtlayacağınız birkaç kolay soruyla yatırımcı profilinizi oluşturabilir, size en uygun yatırım ürünlerini öğrenebilirsiniz.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.6),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Profil Oluştur",
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
