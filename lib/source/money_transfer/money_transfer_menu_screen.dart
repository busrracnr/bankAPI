import 'package:flutter/material.dart';
import 'transfer_flow_screen.dart';

class MoneyTransferMenuScreen extends StatelessWidget {
  const MoneyTransferMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Para Transferi", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      backgroundColor: const Color(0xFFF2F4F7),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _buildMenuItem(
            context,
            icon: Icons.history,
            title: "Son İşlemler",
            onTap: () {
              // Son işlemlere git
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.import_export,
            title: "Kayıtlı Para Transferleri",
            onTap: () {
              // Kayıtlı transferlere git
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.compare_arrows,
            title: "Hesaplarım Arası",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TransferFlowScreen(initialTabIndex: 5),
                ),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.reply,
            title: "Başka Hesaba (Havale / EFT / F...",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TransferFlowScreen(initialTabIndex: 1),
                ),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.account_balance,
            title: "Açık Bankacılık Transferleri",
            onTap: () {
              // Açık bankacılık transferlere git
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.credit_card,
            title: "Karta",
            onTap: () {
              // Karta transfere git
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.smartphone,
            title: "Cebe Gönder ATM'den Çek",
            onTap: () {
              // ATM transferine git
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.language,
            title: "Döviz Transferi",
            onTap: () {
              // Döviz transferine git
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.tune,
            title: "Transfer Limitleri",
            onTap: () {
              // Transfer limitlerini göster
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.date_range,
            title: "Talimatlarım",
            onTap: () {
              // Talimatları göster
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.security,
            title: "Güvenli Ödeme İşlemleri",
            onTap: () {
              // Güvenli ödeme işlemlerine git
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.currency_lira,
            title: "Ödeme İste",
            onTap: () {
              // Ödeme işte sayfasına git
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        onTap: onTap,
      ),
    );
  }
}
