import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../network/api_client.dart';

class AuthRepository {
  final ApiClient _client;
  static const _storage = FlutterSecureStorage();

  AuthRepository(this._client);

  static Future<String?> getLastUserEmail() => _storage.read(key: 'last_email');
  static Future<String?> getLastUserName() => _storage.read(key: 'last_name');

  static Future<void> _saveLastUser(String email, String name) async {
    await _storage.write(key: 'last_email', value: email);
    await _storage.write(key: 'last_name', value: name);
  }

  static Future<void> clearLastUser() async {
    await _storage.delete(key: 'last_email');
    await _storage.delete(key: 'last_name');
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _client.dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      final token = response.data['token'] as String;
      await ApiClient.saveToken(token);
      final fullName = (response.data['user'] as Map<String, dynamic>)['full_name'] as String? ?? '';
      await _saveLastUser(email, fullName);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final response = await _client.dio.post('/auth/register', data: {
        'full_name': fullName,
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
      });
      final token = response.data['token'] as String;
      await ApiClient.saveToken(token);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getMe() async {
    try {
      final response = await _client.dio.get('/auth/me');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    await ApiClient.deleteToken();
    await AuthRepository.clearLastUser();
  }

  String _handleError(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['error'] != null) {
      return data['error'] as String;
    }
    return 'Bağlantı hatası oluştu.';
  }
}
