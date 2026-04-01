import 'package:flutter/material.dart';
import 'widgets/account_card.dart';
import '../money_transfer/transfer_flow_screen.dart';
import '../money_transfer/money_transfer_menu_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7), // Arka plan hafif gri
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(backgroundImage: NetworkImage('https://via.placeholder.com/150')),
        ),
        title: const Text("Zeynep Büşra Çınar", style: TextStyle(fontSize: 16, color: Colors.black87)),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.teal), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.teal), onPressed: () {}),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTabs(),
            const AccountBalanceCard(accountNo: "98750438 - 1", balance: 689.43),
            _buildSectionTitle("Hızlı İşlemler"),
            _buildQuickActions(context),
            _buildSectionTitle("Son İşlem"),
            _buildLastTransaction(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text("Hesabım", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(width: 20),
          Text("Kartım", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text("Düzenle", style: TextStyle(color: Colors.teal)),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        children: [
          _quickActionItem(context, Icons.swap_horiz, "Para Transferi\nIBAN'a", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const TransferFlowScreen(initialTabIndex: 0)));
          }),
          _quickActionItem(context, Icons.account_balance, "Para Transferi\nHesaba", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const TransferFlowScreen(initialTabIndex: 1)));
          }),
        ],
      ),
    );
  }

  Widget _quickActionItem(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.teal),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildLastTransaction() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: ListTile(
        title: const Text("01.04.2026", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text("Firma Adı: TAVUK DUNYASI\nBURDUR BURDUR, Harcama"),
        trailing: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("-455,00 TL", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            Text("Bakiye: 689,43 TL", style: TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        
        // Para Transferi menüsü tıklandığında (index 3)
        if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MoneyTransferMenuScreen()),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Ana Sayfa"),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Döviz/Yatırım"),
        BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: "Durumum"),
        BottomNavigationBarItem(icon: Icon(Icons.send), label: "Para Transf..."),
        BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menü"),
      ],
    );
  }
}