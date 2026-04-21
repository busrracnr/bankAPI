import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../action/accounts/account_filter_manager.dart';
import '../../action/money_transfer/account_provider.dart';
import 'filter_accounts_screen.dart';

class AccountsScreen extends ConsumerStatefulWidget {
  const AccountsScreen({super.key});

  @override
  ConsumerState<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends ConsumerState<AccountsScreen> with TickerProviderStateMixin {
  int _selectedTab = 0;
  late TabController _tabController;

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

  List<Map<String, dynamic>> _applyFilters(List<dynamic> accounts) {
    final filterState = ref.read(accountFilterProvider);
    return accounts.where((a) {
      final account = a as Map<String, dynamic>;
      final balance = double.tryParse(account['balance'].toString()) ?? 0;
      if (filterState.onlyOpenAccounts && balance == 0) return false;
      if (filterState.onlyAvailableBalance && balance == 0) return false;
      return true;
    }).cast<Map<String, dynamic>>().toList();
  }

  String _formatBalance(Map<String, dynamic> account) {
    final balance = double.tryParse(account['balance'].toString()) ?? 0.0;
    final currency = account['currency'] as String? ?? 'TRY';
    final formatted = balance.toStringAsFixed(2).replaceAll('.', ',');
    final currencyLabel = currency == 'TRY' ? 'TL' : currency;
    return '$formatted $currencyLabel';
  }

  String _accountNo(Map<String, dynamic> account) {
    final iban = account['iban'] as String? ?? '';
    return iban.length > 8 ? iban.substring(iban.length - 8) : iban;
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsProvider);

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
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.teal,
              indicatorWeight: 3,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              onTap: (index) => setState(() => _selectedTab = index),
              tabs: const [
                Tab(text: "Cari Hesaplarım"),
                Tab(text: "Katılım Hesaplarım"),
                Tab(text: "Başka Banka"),
              ],
            ),
          ),
          Expanded(
            child: accountsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: Colors.teal)),
              error: (e, _) => Center(child: Text('Hata: $e', style: const TextStyle(color: Colors.red))),
              data: (accounts) => _buildTabContent(accounts),
            ),
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

  Widget _buildTabContent(List<dynamic> allAccounts) {
    if (_selectedTab == 0) {
      final filtered = _applyFilters(allAccounts);
      final totalBalance = allAccounts
          .map((a) => (a as Map<String, dynamic>))
          .where((a) => a['currency'] == 'TRY')
          .fold(0.0, (sum, a) => sum + (double.tryParse(a['balance'].toString()) ?? 0));

      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // Toplam
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
                  children: [
                    const Text("Toplam:", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(
                      totalBalance.toStringAsFixed(2).replaceAll('.', ','),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const Text("(TL Karşılığı)", style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
                const Icon(Icons.account_balance, color: Colors.teal, size: 40),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (filtered.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    Icon(Icons.folder_open_outlined, size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text("Hesap bulunamadı.", style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                  ],
                ),
              ),
            )
          else
            ...filtered.map((account) => _buildAccountCard(account)).toList(),
        ],
      );
    } else if (_selectedTab == 1) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text("Katılım hesabınız bulunmamaktadır.", style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text("Henüz tanımlanmış başka banka hesabınız\nbulunmamaktadır.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_accountNo(account), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(account['name'] as String? ?? '', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
          Text(_formatBalance(account), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(width: 12),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
