import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../action/money_transfer/account_provider.dart';
import '../../action/money_transfer/transfer_manager.dart';
import '../../action/user/user_manager.dart';
import '../../core/repositories/auth_repository.dart';
import '../components/primary_button.dart';
import '../home/home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isLoading = false;
  String? _savedEmail;   // kayıtlı e-posta
  String? _savedName;    // kayıtlı ad soyad
  bool _switchingAccount = false; // "Başka hesapla gir" aktif mi

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _loadSavedUser();
  }

  Future<void> _loadSavedUser() async {
    final email = await AuthRepository.getLastUserEmail();
    final name = await AuthRepository.getLastUserName();
    if (mounted) {
      setState(() {
        _savedEmail = email;
        _savedName = name;
        if (email != null) {
          _emailController.text = email;
        }
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lütfen e-posta ve şifrenizi giriniz"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(userProvider.notifier).loginWithApi(email, password);
      // Yeni kullanıcının hesapları yüklensin, eski cache'i temizle
      ref.invalidate(accountsProvider);
      ref.invalidate(transferProvider);
      ref.read(isAuthenticatedProvider.notifier).setAuthenticated(true);

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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      setState(() => _isLoading = false);
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
          "bankAPI",
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
                  // "Merhaba" her zaman göster
                  const Text(
                    "Merhaba",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Kayıtlı kullanıcı varsa ve başka hesap seçilmiyorsa adı göster
                  if (_savedName != null && !_switchingAccount)
                    Text(
                      _savedName!,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 16),
                  // E-posta alanı: sadece kayıtlı kullanıcı yoksa VEYA "Başka hesapla gir" seçildiyse göster
                  if (_savedEmail == null || _switchingAccount)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintText: "E-posta giriniz",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
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
                  // Şifremi Unuttum
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
                  // Başka hesapla gir — sadece kayıtlı kullanıcı varsa ve switch aktif değilse göster
                  if (_savedEmail != null && !_switchingAccount)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _switchingAccount = true;
                          _emailController.clear();
                          _passwordController.clear();
                        });
                      },
                      child: const Text(
                        "Başka hesapla gir >",
                        style: TextStyle(
                          color: Colors.teal,
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