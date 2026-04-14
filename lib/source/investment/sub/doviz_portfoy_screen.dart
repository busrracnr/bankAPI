import 'package:flutter/material.dart';

class DovizPortfoyScreen extends StatelessWidget {
  const DovizPortfoyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Döviz / Kıymetli Maden",
          style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Üst özet kart
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Döviz / Kıymetli Maden",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "(TL Karşılığı)",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                const Text(
                  "0,00 TL",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Hesap listesi
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildHesapRow(
                  kod: "ALT (gr)",
                  ad: "Altın",
                  miktar: "0,00",
                  yuzde: "%0",
                  kulBakiye: "0,00 ALT (gr)",
                ),
                const Divider(height: 1, indent: 16),
                _buildHesapRow(
                  kod: "EUR",
                  ad: "Euro",
                  miktar: "0,00",
                  yuzde: "%0",
                  kulBakiye: "0,00 EUR",
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Yatay grafikteki oranlar, ürünün portföyünüzdeki payını göstermektedir.",
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildHesapRow({
    required String kod,
    required String ad,
    required String miktar,
    required String yuzde,
    required String kulBakiye,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sol: kod ve ad
          SizedBox(
            width: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kod,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                Text(
                  ad,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          // Sağ: değerler
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  miktar,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                // Yüzde progress bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(yuzde, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: 0,
                          backgroundColor: Colors.grey.shade200,
                          color: Colors.teal,
                          minHeight: 5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Kullanılabilir Bakiye: $kulBakiye",
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.receipt_long_outlined, size: 18, color: Colors.orange.shade400),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
