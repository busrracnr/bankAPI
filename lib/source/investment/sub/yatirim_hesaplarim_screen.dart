import 'package:flutter/material.dart';

class YatirimHesaplarimScreen extends StatelessWidget {
  const YatirimHesaplarimScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text("Yatırım Hesaplarım",
            style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection("Kuveyt Türk Yatırım Hesabı", [
            _HesapItem(hesapNo: "90758", bakiye: "0,00 TL", tur: "Yatırım Hesabı"),
          ]),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Text(
              "Hisse senedi işlemleri için kullanılan Kuveyt Türk\nYatırım Menkul Değerler AŞ hesabıdır.",
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 8),
          _buildSection("Yatırım", [
            _HesapItem(hesapNo: "98750438-4000", bakiye: "3.300,00 TL", tur: "Yatırım Hesabı"),
            _HesapItem(hesapNo: "98750438-4001", bakiye: "0,00 ALT gr", tur: "Yatırım Hesabı"),
          ]),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Text(
              "Yatırım fonu, kira sertifikası gibi yatırım işlemleri için\nkullanılan hesaplardır.",
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.orange,
              side: const BorderSide(color: Colors.orange),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Yatırım Hesabı Aç", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {},
            child: const Text("Yatırım Hesaplarımı Kapat",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<_HesapItem> items) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.teal)),
          ),
          const Divider(height: 1),
          ...items.map((item) => ListTile(
                title: Text(item.hesapNo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                subtitle: Text(item.tur, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(item.bakiye, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                  ],
                ),
                onTap: () {},
              )),
        ],
      ),
    );
  }
}

class _HesapItem {
  final String hesapNo;
  final String bakiye;
  final String tur;
  const _HesapItem({required this.hesapNo, required this.bakiye, required this.tur});
}
