import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountBalanceNotifier extends Notifier<double> {
  static const double initialBalance = 689.43;

  @override
  double build() => initialBalance;

  bool canTransfer(double amount) {
    return amount > 0 && amount <= state;
  }

  void deduct(double amount) {
    if (!canTransfer(amount)) {
      return;
    }

    state = double.parse((state - amount).toStringAsFixed(2));
  }

  void reset() {
    state = initialBalance;
  }
}

final accountBalanceProvider = NotifierProvider<AccountBalanceNotifier, double>(
  () => AccountBalanceNotifier(),
);