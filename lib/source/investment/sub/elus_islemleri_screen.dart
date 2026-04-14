import 'package:flutter/material.dart';

class ElusIslemleriScreen extends StatelessWidget {
  const ElusIslemleriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text("ELÜS İşlemleri",
            style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("ELÜS İptal İşlemleri",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: const Center(
              child: Text("ELÜS iptal talebiniz bulunmamaktadır.",
                  style: TextStyle(fontSize: 13, color: Colors.grey)),
            ),
          ),
          const SizedBox(height: 20),
          const Text("ELÜS Belgelerim",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("14.03.2026 - 14.06.2026",
                        style: TextStyle(fontSize: 13, color: Colors.teal, fontWeight: FontWeight.bold)),
                    Icon(Icons.receipt_outlined, color: Colors.teal.shade300),
                  ],
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text("ELÜS Alım Satım Belgesi\nbulunmamaktadır.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.grey)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
