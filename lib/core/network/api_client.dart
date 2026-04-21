import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static const String _baseUrl = 'http://localhost:3000/api';
  static const _storage = FlutterSecureStorage();

  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (DioException e, handler) {
        handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  static Future<String?> getToken() async {
    return _storage.read(key: 'auth_token');
  }
}
