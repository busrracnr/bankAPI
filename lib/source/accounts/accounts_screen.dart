import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../action/accounts/account_filter_manager.dart';
import 'filter_accounts_screen.dart';

class AccountsScreen extends ConsumerStatefulWidget {
  const AccountsScreen({super.key});

  @override
  ConsumerState<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends ConsumerState<AccountsScreen> with TickerProviderStateMixin {
  int _selectedTab = 0;
  late TabController _tabController;

  // Örnek hesap verileri
  final List<Map<String, dynamic>> myAccounts = [
    {
      "number": "98750438-1",
      "balance": "87,23 TL",
      "type": "Cari Hesap",
      "icon": Icons.account_balance_wallet,
    },
    {
      "number": "98750438-4000",
      "balance": "2,00 TL",
      "type": "Yatırım Hesabı",
      "icon": Icons.trending_up,
    },
    {
      "number": "98750438-101",
      "balance": "0.02 ALT (gr)",
      "type": "Cari Hesap",
      "icon": Icons.account_balance_wallet,
    },
    {
      "number": "98750438-102",
      "balance": "0,00 EUR",
      "type": "Cari Hesap",
      "icon": Icons.account_balance_wallet,
    },
    {
      "number": "98750438-4001",
      "balance": "0,00 ALT (gr)",
      "type": "Yatırım Hesabı",
      "icon": Icons.trending_up,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredAccounts() {
    final filterState = ref.read(accountFilterProvider);
    
    return myAccounts.where((account) {
      // Sadece Açık Hesaplar
      if (filterState.onlyOpenAccounts) {
        if (account["balance"].toString().contains("0,00") || 
            account["balance"].toString().contains("0.00")) {
          return false;
        }
      }

      // Sadece Kullanılabilir Bakiyeli Hesaplar
      if (filterState.onlyAvailableBalance) {
        if (account["balance"].toString().contains("0,00") || 
            account["balance"].toString().contains("0.00")) {
          return false;
        }
      }

      // Ortak Hesaplar seçeneği
      if (!filterState.commonAccounts) {
        // Ortak hesapları gizle (isim içinde "ortak" varsa)
        if (account["type"].toString().toLowerCase().contains("ortak")) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Hesaplar", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.teal),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FilterAccountsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Sekme Başlıkları
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.teal,
              indicatorWeight: 3,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              onTap: (index) {
                setState(() {
                  _selectedTab = index;
                });
              },
              tabs: const [
                Tab(text: "Cari Hesaplarım"),
                Tab(text: "Katılma Hesaplarım"),
                Tab(text: "Başka Banka"),
              ],
            ),
          ),
          
          // İçerik
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.teal,
        label: const Text("Hesap Aç", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTabContent() {
    if (_selectedTab == 0) {
      // Cari hesaplarım
      final filteredAccounts = _getFilteredAccounts();
      
      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // Toplam bilgi
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Toplam:", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text("219,90", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                    Text("(TL Karşılığı)", style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
                const Icon(Icons.account_balance, color: Colors.teal, size: 40),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Hesap listesi
          if (filteredAccounts.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    Icon(Icons.folder_open_outlined, size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text(
                      "Filtre kriterlerine uygun hesap bulunamadı.",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                  ],
                ),
              ),
            )
          else
            ...filteredAccounts.map((account) => _buildAccountCard(account)).toList(),
        ],
      );
    } else if (_selectedTab == 1) {
      // Katılma hesaplarım - boş
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              "Katılma hesabınız bulunmamaktadır.",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
      );
    } else {
      // Başka banka - boş
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              "Henüz tanımlanmış başka banka hesabınız\nkullanmamaktadır.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildAccountCard(Map<String, dynamic> account) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Hesap numarası ve tip
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account["number"],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  account["type"],
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          
          // Tutar
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                account["balance"],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 4),
            ],
          ),
          
          // Ok ikonu
          const SizedBox(width: 12),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
