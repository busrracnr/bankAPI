import 'package:dio/dio.dart';
import '../network/api_client.dart';

class AccountRepository {
  final ApiClient _client;

  AccountRepository(this._client);

  Future<List<dynamic>> getAccounts() async {
    try {
      final response = await _client.dio.get('/accounts');
      return response.data['accounts'] as List;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getAccount(String id) async {
    try {
      final response = await _client.dio.get('/accounts/$id');
      return response.data['account'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> createAccount({
    required String name,
    String currency = 'TRY',
    String accountType = 'checking',
  }) async {
    try {
      final response = await _client.dio.post('/accounts', data: {
        'name': name,
        'currency': currency,
        'account_type': accountType,
      });
      return response.data['account'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['error'] != null) {
      return data['error'] as String;
    }
    return 'Bağlantı hatası oluştu.';
  }
}
