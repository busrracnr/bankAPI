import 'package:flutter/material.dart';

class YatirimHesabiTransferleriScreen extends StatefulWidget {
  const YatirimHesabiTransferleriScreen({super.key});

  @override
  State<YatirimHesabiTransferleriScreen> createState() => _YatirimHesabiTransferleriScreenState();
}

class _YatirimHesabiTransferleriScreenState extends State<YatirimHesabiTransferleriScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text("Yatırım Hesabı Para Transferleri",
            style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Tab seçici
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  _buildTab("Yatırım Hesabına", 0),
                  _buildTab("Yatırım Hesabından", 1),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _infoRow("Gönderen Hesap", "98750438-1", "Cari Hesap", "55,11 TL"),
                  const SizedBox(height: 16),
                  _infoRow("Alıcı Hesap", "90758", "Kuveyt Türk\nYatırım Hesabı", "0,00 TL"),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: "Tutar",
                  hintText: "Giriniz",
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("İleri", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _tabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.teal.shade50 : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isSelected ? Border.all(color: Colors.teal) : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.teal : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String hesapNo, String hesapTur, String bakiye) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(hesapNo, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            Text(hesapTur, style: const TextStyle(fontSize: 11, color: Colors.teal), textAlign: TextAlign.right),
            Text(bakiye, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
