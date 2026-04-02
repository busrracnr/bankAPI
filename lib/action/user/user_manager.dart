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

class UserNotifier extends Notifier<User?> {
  @override
  User? build() {
    return User(
      name: "Zeynep Büşra Çınar",
      password: "1234",
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
    state = null;
  }
}

class AuthNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setAuthenticated(bool value) {
    state = value;
  }

  void logout() {
    state = false;
  }
}

final userProvider = NotifierProvider<UserNotifier, User?>(() {
  return UserNotifier();
});

final isAuthenticatedProvider = NotifierProvider<AuthNotifier, bool>(() {
  return AuthNotifier();
});
