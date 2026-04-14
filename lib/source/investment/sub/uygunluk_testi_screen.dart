import 'package:flutter/material.dart';

class UygunlukTestiScreen extends StatelessWidget {
  const UygunlukTestiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text("Uygunluk Testi",
            style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text("Uygunluk Testim",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("29.08.2023",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 13),
                        children: [
                          TextSpan(text: "Uygun: ", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w500)),
                          TextSpan(
                              text: "Çok Düşük Riskli, Düşük Riskli, Orta Riskli, Yüksek Riskli",
                              style: TextStyle(color: Colors.black87)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 13),
                        children: [
                          TextSpan(text: "Uygun değil: ", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
                          TextSpan(text: "Çok Yüksek Riskli", style: TextStyle(color: Colors.black87)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: TextButton(
                onPressed: () {},
                child: const Text("Uygunluk Testi Yap",
                    style: TextStyle(color: Colors.orange, fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
