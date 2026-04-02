import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../action/accounts/account_filter_manager.dart';

class FilterAccountsScreen extends ConsumerWidget {
  const FilterAccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(accountFilterProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Filtrele",
          style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              children: [
                // Sadece Açık Hesaplar
                _buildFilterTile(
                  context,
                  ref,
                  title: "Sadece Açık Hesaplar",
                  value: filterState.onlyOpenAccounts,
                  onChanged: (_) {
                    ref.read(accountFilterProvider.notifier).toggleOnlyOpenAccounts();
                  },
                ),
                const SizedBox(height: 12),

                // Sadece Kullanılabilir Bakiyeli Hesaplar
                _buildFilterTile(
                  context,
                  ref,
                  title: "Sadece Kullanılabilir\nBakiyeli Hesaplar",
                  value: filterState.onlyAvailableBalance,
                  onChanged: (_) {
                    ref.read(accountFilterProvider.notifier).toggleOnlyAvailableBalance();
                  },
                ),
                const SizedBox(height: 12),

                // Ortak Hesaplar
                _buildFilterTile(
                  context,
                  ref,
                  title: "Ortak Hesaplar",
                  value: filterState.commonAccounts,
                  onChanged: (_) {
                    ref.read(accountFilterProvider.notifier).toggleCommonAccounts();
                  },
                ),
              ],
            ),
          ),
          // Filtrele Butonu
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(accountFilterProvider.notifier).applyFilter();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  "Filtrele",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTile(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
          Switch(
            activeColor: Colors.teal,
            inactiveTrackColor: Colors.grey.shade300,
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
