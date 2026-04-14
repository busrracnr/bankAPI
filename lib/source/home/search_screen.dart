import 'package:flutter/material.dart';
import '../money_transfer/transfer_flow_screen.dart';
import '../money_transfer/money_transfer_menu_screen.dart';
import '../accounts/accounts_screen.dart';

class _SearchItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback Function(BuildContext context) onTap;

  const _SearchItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}

final List<_SearchItem> _allItems = [
  _SearchItem(
    title: "Para Transferi",
    subtitle: "IBAN veya hesap numarasına transfer",
    icon: Icons.swap_horiz,
    onTap: (ctx) => () => Navigator.push(
          ctx,
          MaterialPageRoute(builder: (_) => const MoneyTransferMenuScreen()),
        ),
  ),
  _SearchItem(
    title: "IBAN'a Para Transferi",
    subtitle: "IBAN numarasına EFT / havale gönder",
    icon: Icons.compare_arrows,
    onTap: (ctx) => () => Navigator.push(
          ctx,
          MaterialPageRoute(
              builder: (_) => const TransferFlowScreen(initialTabIndex: 0)),
        ),
  ),
  _SearchItem(
    title: "Hesaba Para Transferi",
    subtitle: "Hesap numarasına transfer gönder",
    icon: Icons.account_balance,
    onTap: (ctx) => () => Navigator.push(
          ctx,
          MaterialPageRoute(
              builder: (_) => const TransferFlowScreen(initialTabIndex: 1)),
        ),
  ),
  _SearchItem(
    title: "Hesaplarım",
    subtitle: "Tüm hesaplarını görüntüle",
    icon: Icons.credit_card,
    onTap: (ctx) => () => Navigator.push(
          ctx,
          MaterialPageRoute(builder: (_) => const AccountsScreen()),
        ),
  ),
];

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<_SearchItem> _results = [];

  @override
  void initState() {
    super.initState();
    _results = List.from(_allItems);
  }

  void _onSearch(String query) {
    final q = query.toLowerCase().trim();
    setState(() {
      if (q.isEmpty) {
        _results = List.from(_allItems);
      } else {
        _results = _allItems
            .where((item) =>
                item.title.toLowerCase().contains(q) ||
                item.subtitle.toLowerCase().contains(q))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: const BackButton(color: Colors.teal),
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: _onSearch,
          style: const TextStyle(fontSize: 16),
          decoration: const InputDecoration(
            hintText: "İşlem veya ekran ara...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _controller.clear();
                _onSearch('');
              },
            ),
        ],
      ),
      body: _results.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    "Sonuç bulunamadı",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _results.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = _results[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.pop(context);
                    item.onTap(context)();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(item.icon, color: Colors.teal, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.subtitle,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right,
                            color: Colors.grey, size: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
