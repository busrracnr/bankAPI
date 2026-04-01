import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../server/money_transfer/transfer_service.dart';

// Servis sınıfını projeye tanıtıyoruz
final transferServiceProvider = Provider((ref) => TransferService());

// Hesapları getiren asenkron Provider
final accountsProvider = FutureProvider<List<dynamic>>((ref) async {
  final service = ref.watch(transferServiceProvider);
  return service.fetchAccounts();
});