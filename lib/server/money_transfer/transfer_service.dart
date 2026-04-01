import 'dart:convert';
import 'package:flutter/services.dart';

class TransferService {
  Future<List<dynamic>> fetchAccounts() async {
    // Local JSON'u oku
    final String response = await rootBundle.loadString('assets/data/accounts.json');
    final data = await json.decode(response);
    return data['accounts'];
  }
}