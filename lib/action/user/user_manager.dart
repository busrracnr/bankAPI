import 'package:flutter_riverpod/flutter_riverpod.dart';

class User {
  final String name;
  final String password;
  final String id;

  User({
    required this.name,
    required this.password,
    required this.id,
  });
}

class UserManager extends StateNotifier<User?> {
  UserManager() : super(null) {
    // Uygulama başladığında varsayılan kullanıcı yükle
    _initializeUser();
  }

  void _initializeUser() {
    // Zeynep Büşra Çınar kullanıcısı
    state = User(
      name: "Zeynep Büşra Çınar",
      password: "1234", // Belirlenen şifre
      id: "12345678901",
    );
  }

  bool authenticate(String password) {
    if (state != null && state!.password == password) {
      return true;
    }
    return false;
  }

  String? getCurrentUserName() {
    return state?.name;
  }

  void logout() {
    // Oturumu kapat (opsiyonel)
  }
}

final userProvider = StateNotifierProvider<UserManager, User?>((ref) {
  return UserManager();
});

final isAuthenticatedProvider = StateNotifierProvider<IsAuthenticatedNotifier, bool>((ref) {
  return IsAuthenticatedNotifier();
});

class IsAuthenticatedNotifier extends StateNotifier<bool> {
  IsAuthenticatedNotifier() : super(false);

  void setAuthenticated(bool value) {
    state = value;
  }

  bool get isAuthenticated => state;
}
