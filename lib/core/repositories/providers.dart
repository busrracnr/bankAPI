import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import 'auth_repository.dart';
import 'account_repository.dart';
import 'transfer_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(apiClientProvider));
});

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return AccountRepository(ref.watch(apiClientProvider));
});

final transferRepositoryProvider = Provider<TransferRepository>((ref) {
  return TransferRepository(ref.watch(apiClientProvider));
});
