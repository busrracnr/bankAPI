import 'package:flutter/material.dart';

class PortfoyScreen extends StatelessWidget {
  const PortfoyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text("Portföyüm", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text("Portföy Değeri", style: TextStyle(fontSize: 12, color: Colors.grey)),
                const Text("4,23 TL", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 1.0,
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.orange,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 16),
                _buildPortfoyRow("Döviz / Kıymetli Maden", "(TL Karşılığı)", "0,00 TL", Colors.teal),
                const SizedBox(height: 12),
                _buildPortfoyRow("Hisse Senedi", "", "0,00 TL", Colors.orange),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("T+1 Bakiye: 0,00 TL", style: TextStyle(fontSize: 11, color: Colors.grey)),
                      Text("T+2 Bakiye: 0,00 TL", style: TextStyle(fontSize: 11, color: Colors.grey)),
                      Text("Kâr / Zarar: 0,00 TL", style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
                _buildPortfoyRow("Yatırım Fonu", "(TL Karşılığı)", "4,23 TL", Colors.teal),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
                  child: const Text("Kâr / Zarar: +0,37 TL", style: TextStyle(fontSize: 11, color: Colors.green)),
                ),
                _buildPortfoyRow("Kira Sertifikası", "(TL Karşılığı)", "0,00 TL", Colors.teal),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
                  child: const Text("Kâr / Zarar: 0,00 TL", style: TextStyle(fontSize: 11, color: Colors.grey)),
                ),
                const Divider(),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Toplam Kâr / Zarar:", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text("+0,37 TL", style: TextStyle(fontSize: 13, color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text("Tutarlar bilgi amaçlı olup satış anındaki\nhesaplamalardan farklı olabilir.",
              style: TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 16),
          _buildHesapKart("90758 (TL)", "Kuveyt Türk Yatırım Hesabı", "Kullanılabilir Bakiye: 0,00 TL", "Bakiye: 0,00 TL"),
          const SizedBox(height: 8),
          _buildHesapKart("98750438-4000 (TL)", "", "Kullanılabilir Bakiye: 3.300,00 TL", "Bakiye: 3.300,00 TL"),
          const SizedBox(height: 8),
          _buildHesapKart("98750438-4001 (ALT gr)", "", "Kullanılabilir Bakiye: 0,00 ALT gr", "Bakiye: 0,00 ALT gr"),
        ],
      ),
    );
  }

  Widget _buildPortfoyRow(String title, String sub, String value, Color arrowColor) {
    return Row(
      children: [
        Icon(Icons.chevron_right, color: arrowColor, size: 18),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, color: Colors.teal, fontWeight: FontWeight.w500)),
              if (sub.isNotEmpty) Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildHesapKart(String hesapNo, String aciklama, String kulBakiye, String bakiye) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(hesapNo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          if (aciklama.isNotEmpty)
            Text(aciklama, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.swap_horiz, color: Colors.teal.shade300, size: 20),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(kulBakiye, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(bakiye, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
