import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountFilterState {
  final bool onlyOpenAccounts;
  final bool onlyAvailableBalance;
  final bool commonAccounts;

  AccountFilterState({
    this.onlyOpenAccounts = true,
    this.onlyAvailableBalance = false,
    this.commonAccounts = true,
  });

  AccountFilterState copyWith({
    bool? onlyOpenAccounts,
    bool? onlyAvailableBalance,
    bool? commonAccounts,
  }) {
    return AccountFilterState(
      onlyOpenAccounts: onlyOpenAccounts ?? this.onlyOpenAccounts,
      onlyAvailableBalance: onlyAvailableBalance ?? this.onlyAvailableBalance,
      commonAccounts: commonAccounts ?? this.commonAccounts,
    );
  }
}

class AccountFilterNotifier extends Notifier<AccountFilterState> {
  @override
  AccountFilterState build() {
    return AccountFilterState();
  }

  void toggleOnlyOpenAccounts() {
    state = state.copyWith(onlyOpenAccounts: !state.onlyOpenAccounts);
  }

  void toggleOnlyAvailableBalance() {
    state = state.copyWith(onlyAvailableBalance: !state.onlyAvailableBalance);
  }

  void toggleCommonAccounts() {
    state = state.copyWith(commonAccounts: !state.commonAccounts);
  }

  void applyFilter() {
    // Filtreler otomatik olarak state'e uygulanır
    // UI bu state'i dinler ve hesapları filtreleyerek gösterir
  }

  void resetFilter() {
    state = AccountFilterState();
  }
}

final accountFilterProvider = NotifierProvider<AccountFilterNotifier, AccountFilterState>(() => AccountFilterNotifier());
