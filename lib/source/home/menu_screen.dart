import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MenuItemData> menuItems = [
      MenuItemData(
        icon: Icons.trending_up,
        title: "Döviz/Yatırım",
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.assessment,
        title: "Durumum",
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.compare_arrows,
        title: "Para Transferi",
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.credit_card,
        title: "Hesap/Kart",
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.history,
        title: "Kayıtlı İşlemler",
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.payment,
        title: "Ödemeler",
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.qr_code_2,
        title: "Karekod",
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.account_balance,
        title: "Finansman",
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.location_on_outlined,
        title: "Şube Randevu",
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.description,
        title: "Çek - Senet",
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.shield_outlined,
        title: "Sigorta",
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.security,
        title: "Bireysel Emeklilik (BES)",
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.folder_open,
        title: "Belgeler ve Onay İşlemleri",
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.local_offer,
        title: "Kampanyalar",
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.settings,
        title: "Ayarlar",
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.apartment,
        title: "e-Devlet",
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.assignment,
        title: "Başvurular",
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.mail_outline,
        title: "Bize Ulaşın",
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.school,
        title: "Kampüs",
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.person_outline,
        title: "Selim'e Sor",
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.business,
        title: "Firma Hesabı Başvurusu",
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.card_giftcard,
        title: "Emekli Bankacılığı",
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.bookmark_outline,
        title: "Benim Köşem",
        onTap: () {},
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return _buildMenuItem(item);
      },
    );
  }

  Widget _buildMenuItem(MenuItemData item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(item.icon, color: Colors.teal, size: 24),
        title: Text(
          item.title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        onTap: item.onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}

class MenuItemData {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  MenuItemData({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
