import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../action/user/user_manager.dart';
import '../components/primary_button.dart';
import '../home/home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _passwordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final userNotifier = ref.read(userProvider.notifier);
    final authNotifier = ref.read(isAuthenticatedProvider.notifier);
    final password = _passwordController.text.trim();

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lütfen şifreyi giriniz"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Şifre doğrulaması
    if (userNotifier.authenticate(password)) {
      authNotifier.setAuthenticated(true);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Giriş başarılı!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Şifre hatalı! Lütfen tekrar deneyiniz."),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }
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
                      color: Colors.teal.shade50,
                    ),
                    child: const Icon(
                      Icons.account_circle,
                      size: 70,
                      color: Colors.teal,
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
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        textAlign: TextAlign.center,
                        onSubmitted: (_) => _handleLogin(),
                        decoration: const InputDecoration(
                          hintText: "Şifre giriniz",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Giriş Yap Butonu
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _isLoading
                        ? const SizedBox(
                            height: 50,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                                strokeWidth: 3,
                              ),
                            ),
                          )
                        : PrimaryButton(
                            text: "Giriş Yap",
                            onPressed: _handleLogin,
                          ),
                  ),
                  const SizedBox(height: 8),
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