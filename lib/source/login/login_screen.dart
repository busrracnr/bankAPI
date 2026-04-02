import 'package:flutter/material.dart';
import '../components/primary_button.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.account_circle_outlined, color: Colors.teal, size: 28),
          onPressed: () {},
        ),
        title: const Text(
          "KuveytTÜRK",
          style: TextStyle(color: Colors.teal, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.grey, size: 24),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  // Profil Resmi
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.teal, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage(
                          "https://via.placeholder.com/80?text=ZB",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Merhaba",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Zeynep Büşra Çınar",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Şifre Girişi
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const TextField(
                        obscureText: true,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "Şifre giriniz",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Şifremi Unuttum Linki
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Şifremi Unuttum >",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Hızlı Erişim Kartları
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildQuickAccessCard(
                      "Dijital TOOD\nDijital açılan\nKuveyt Türk Mobil hesap",
                      Icons.phone_android,
                      Colors.teal.shade300,
                    ),
                    const SizedBox(width: 12),
                    _buildQuickAccessCard(
                      "Ortak ATM İşlemleri",
                      Icons.atm,
                      Colors.blue.shade300,
                    ),
                    const SizedBox(width: 12),
                    _buildQuickAccessCard(
                      "Dış Ticaret\nOperasyonları",
                      Icons.business,
                      Colors.purple.shade300,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Giriş Yap Butonu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PrimaryButton(
                text: "Giriş Yap",
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      // Bottom Navigation
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(Icons.home_outlined, "FAST İşlemleri", false),
              _buildBottomNavItem(Icons.image_outlined, "Kartar", false),
              _buildBottomNavItem(Icons.qr_code_2, "Transfer", false),
              _buildBottomNavItem(Icons.compare_arrows_outlined, "Döviz", false),
              _buildBottomNavItem(Icons.more_horiz, "Daha Fazla", false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessCard(String title, IconData icon, Color bgColor) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? Colors.teal : Colors.grey, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.teal : Colors.grey,
            fontSize: 9,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}