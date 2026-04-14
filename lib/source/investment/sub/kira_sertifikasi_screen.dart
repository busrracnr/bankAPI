import 'package:flutter/material.dart';

class KiraSertifikasiScreen extends StatelessWidget {
  const KiraSertifikasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text("Kira Sertifikası",
            style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _item("Kira Sertifikası Portföyüm"),
                _divider(),
                _item("Favorilerim"),
                _divider(),
                _item("Kira Sertifikası Al"),
                _divider(),
                _item("Kira Sertifikası Sat"),
                _divider(),
                _item("Kira Sertifikası İşlem Geçmişi"),
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
