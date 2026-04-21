import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/repositories/providers.dart';

// Hesapları API'den getiren asenkron Provider
final accountsProvider = FutureProvider<List<dynamic>>((ref) async {
  final repo = ref.watch(accountRepositoryProvider);
  return repo.getAccounts();
});