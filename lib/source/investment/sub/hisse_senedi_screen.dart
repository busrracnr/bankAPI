import 'package:flutter/material.dart';

class HisseSeneediScreen extends StatelessWidget {
  const HisseSeneediScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text("Hisse Senedi",
            style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _item("Hisse Senedi Portföyüm"),
                _divider(),
                _item("Favorilerim"),
                _divider(),
                _item("Hisse Senedi Al"),
                _divider(),
                _item("Hisse Senedi Sat"),
                _divider(),
                _item("Hisse Senedi Emirlerim"),
                _divider(),
                _item("Hisse Senedi İşlem Geçmişi"),
                _divider(),
                _item("Yatırım Hesabı Transferleri"),
                _divider(),
                _item("Halka Arz"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(String title) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      onTap: () {},
    );
  }

  Widget _divider() => const Divider(height: 1, indent: 16);
}
