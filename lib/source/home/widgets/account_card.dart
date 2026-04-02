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
                GestureDetector(
                  onTap: () => _showShareMenu(context),
                  child: const Icon(Icons.share_outlined, color: Colors.teal),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _showMoreMenu(context),
                  child: const Icon(Icons.more_horiz, color: Colors.teal),
                ),
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

  void _showShareMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                accountNo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "TR09002050000098750438000001",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              _buildBottomSheetItem("IBAN Kopyala", Icons.copy, Colors.orange),
              const SizedBox(height: 12),
              _buildBottomSheetItem("IBAN Bilgisi Paylaş", Icons.share, Colors.orange),
              const SizedBox(height: 12),
              _buildBottomSheetItem("Karekod Paylaş", Icons.qr_code_2, Colors.orange),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "Vazgeç",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Hesap Detayı",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 20),
              _buildBottomSheetItem("Ana Sayfa Favori Hesap / Kart Seçimi", Icons.favorite_border, Colors.orange),
              const SizedBox(height: 12),
              _buildBottomSheetItem("Para Transferi Yap", Icons.send, Colors.orange),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "Vazgeç",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetItem(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}