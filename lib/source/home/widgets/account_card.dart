import 'package:flutter/material.dart';

class AccountBalanceCard extends StatelessWidget {
  final String accountNo;
  final double balance;
  final bool isBalanceVisible;
  final VoidCallback onBalanceToggle;
  final VoidCallback? onAllAccountsTap;

  const AccountBalanceCard({
    super.key,
    required this.accountNo,
    required this.balance,
    required this.isBalanceVisible,
    required this.onBalanceToggle,
    this.onAllAccountsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.account_balance_wallet, color: Colors.teal, size: 40),
                const SizedBox(width: 12),
                Text(accountNo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal)),
                const Spacer(),
                GestureDetector(
                  onTap: onBalanceToggle,
                  child: Icon(
                    isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.share_outlined, color: Colors.teal),
                const SizedBox(width: 10),
                const Icon(Icons.more_horiz, color: Colors.teal),
              ],
            ),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerRight,
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                  children: [
                    const TextSpan(text: "Bakiye: "),
                    TextSpan(
                      text: isBalanceVisible 
                        ? balance.toStringAsFixed(2)
                        : "*****",
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: " TL"),
                  ],
                ),
              ),
            ),
            const Divider(height: 30),
            GestureDetector(
              onTap: onAllAccountsTap,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Tüm Hesaplarım", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w600)),
                  Icon(Icons.chevron_right, color: Colors.teal),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}