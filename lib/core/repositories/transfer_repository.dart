import 'package:dio/dio.dart';
import '../network/api_client.dart';

class TransferRepository {
  final ApiClient _client;

  TransferRepository(this._client);

  Future<List<dynamic>> getTransfers() async {
    try {
      final response = await _client.dio.get('/transfers');
      return response.data['transfers'] as List;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> getAccountTransfers(String accountId) async {
    try {
      final response = await _client.dio.get('/transfers/account/$accountId');
      return response.data['transfers'] as List;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> sendMoney({
    required String senderAccountId,
    required String receiverIban,
    required double amount,
    String? receiverName,
    String? description,
  }) async {
    try {
      final response = await _client.dio.post('/transfers', data: {
        'sender_account_id': senderAccountId,
        'receiver_iban': receiverIban,
        'amount': amount,
        if (receiverName != null) 'receiver_name': receiverName,
        if (description != null) 'description': description,
      });
      return response.data['transfer'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// IBAN'a göre hesap sahibinin adını döner. Bulunamazsa null döner.
  Future<String?> lookupIban(String iban) async {
    try {
      final response = await _client.dio.get('/accounts/lookup', queryParameters: {'iban': iban});
      return response.data['full_name'] as String?;
    } on DioException {
      return null;
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
