import 'package:flutter/material.dart';
import 'alis_satis_screen.dart';
import 'doviz_portfoy_screen.dart';

class DovizKiymetliMadenlerScreen extends StatelessWidget {
  const DovizKiymetliMadenlerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text("Döviz ve Kıymetli Madenler",
            style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _item(context, "Portföyüm", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DovizPortfoyScreen()))),
                _divider(),
                _item(context, "Al / Sat", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AlisSatisScreen()))),
                _divider(),
                _item(context, "Emirlerim"),
                _divider(),
                _item(context, "İşlem Geçmişi"),
                _divider(),
                _item(context, "Kur Referansı İşlemleri"),
                _divider(),
                _item(context, "İşlem Limitlerini Güncelle"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String title, {VoidCallback? onTap}) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      onTap: onTap ?? () {},
    );
  }

  Widget _divider() => const Divider(height: 1, indent: 16);
}
