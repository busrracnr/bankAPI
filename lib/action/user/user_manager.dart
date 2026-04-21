import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/repositories/providers.dart';

class User {
  final String name;
  final String email;
  final String id;

  User({
    required this.name,
    required this.email,
    required this.id,
  });
}

class UserNotifier extends Notifier<User?> {
  @override
  User? build() => null;

  Future<void> loginWithApi(String email, String password) async {
    final repo = ref.read(authRepositoryProvider);
    final data = await repo.login(email, password);
    final userMap = data['user'] as Map<String, dynamic>;
    state = User(
      name: userMap['full_name'] as String,
      email: userMap['email'] as String,
      id: userMap['id'] as String,
    );
  }

  String? getCurrentUserName() {
    return state?.name;
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
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
