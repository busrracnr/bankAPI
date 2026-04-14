import 'package:flutter/material.dart';
import 'sub/doviz_kiymetli_madenler_screen.dart';
import 'sub/hisse_senedi_screen.dart';
import 'sub/yatirim_fonu_screen.dart';
import 'sub/kira_sertifikasi_screen.dart';
import 'sub/yatirim_hesaplarim_screen.dart';
import 'sub/yatirim_hesabi_transferleri_screen.dart';
import 'sub/elus_islemleri_screen.dart';
import 'sub/nitelikli_yatirimci_screen.dart';
import 'sub/uygunluk_testi_screen.dart';
import 'sub/yatirim_rehberi_screen.dart';
import 'sub/portfoy_screen.dart';

class InvestmentMenuScreen extends StatelessWidget {
  const InvestmentMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Döviz/Yatırım",
          style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Portföyüm kartı
          _buildCard(
            context,
            icon: Icons.donut_large,
            title: "Portföyüm",
            subtitle: "Döviz / Kıymetli Maden ve Yatırım\nÜrünlerinin Portföy Değerleri, Kâr / Zarar\nBilgisi",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PortfoyScreen())),
          ),
          const SizedBox(height: 16),
          // Liste menü
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildMenuItem(context, icon: Icons.monetization_on_outlined, title: "Döviz ve Kıymetli Madenler",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DovizKiymetliMadenlerScreen()))),
                _buildDivider(),
                _buildMenuItem(context, icon: Icons.show_chart, title: "Hisse Senedi",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HisseSeneediScreen()))),
                _buildDivider(),
                _buildMenuItem(context, icon: Icons.grid_view, title: "Yatırım Fonu",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const YatirimFonuScreen()))),
                _buildDivider(),
                _buildMenuItem(context, icon: Icons.grid_on, title: "Kira Sertifikası",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KiraSertifikasiScreen()))),
                _buildDivider(),
                _buildMenuItem(context, icon: Icons.account_balance_wallet_outlined, title: "Yatırım Hesaplarım",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const YatirimHesaplarimScreen()))),
                _buildDivider(),
                _buildMenuItem(context, icon: Icons.currency_lira, title: "Yatırım Hesabı Transferleri",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const YatirimHesabiTransferleriScreen()))),
                _buildDivider(),
                _buildMenuItem(context, icon: Icons.location_on_outlined, title: "ELÜS İşlemleri",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ElusIslemleriScreen()))),
                _buildDivider(),
                _buildMenuItem(context, icon: Icons.people_outline, title: "Nitelikli Yatırımcı Tanımlama",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NitelikliYatirimciScreen()))),
                _buildDivider(),
                _buildMenuItem(context, icon: Icons.compare_arrows, title: "Uygunluk Testi",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UygunlukTestiScreen()))),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Yatırım Rehberim kartı
          _buildCard(
            context,
            icon: Icons.lightbulb_outline,
            title: "Yatırım Rehberim",
            subtitle: "Yatırım Tavsiyesi, Birikim Değerlendirme\nÖnerileri vb.",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const YatirimRehberiScreen())),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.teal, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 56, endIndent: 0);
  }
}
