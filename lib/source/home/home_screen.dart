import 'package:flutter/material.dart';
import 'widgets/account_card.dart';
import '../money_transfer/transfer_flow_screen.dart';
import 'menu_screen.dart';
import '../accounts/accounts_screen.dart';

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
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Color(0xFFE0F2F1),
            child: Icon(Icons.account_circle, color: Colors.teal, size: 28),
          ),
        ),
        title: const Text("Zeynep Büşra Çınar", style: TextStyle(fontSize: 16, color: Colors.black87)),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.teal), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.teal), onPressed: () {}),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeContent(),
          _buildDovizYatirimContent(),
          _buildDurumContent(),
          _buildParaTransferiContent(),
          _buildMenuContent(),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabs(),
          AccountBalanceCard(
            accountNo: "98750438 - 1",
            balance: 689.43,
            onAllAccountsTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AccountsScreen()),
              );
            },
          ),
          _buildSectionTitle("Hızlı İşlemler"),
          _buildQuickActions(context),
          _buildSectionTitle("Son İşlem"),
          _buildLastTransaction(),
        ],
      ),
    );
  }

  Widget _buildDovizYatirimContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.trending_up, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            "Döviz/Yatırım",
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDurumContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assessment, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            "Durumum",
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildParaTransferiContent() {
    return const TransferFlowScreen(initialTabIndex: 0);
  }

  Widget _buildMenuContent() {
    return const MenuScreen();
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