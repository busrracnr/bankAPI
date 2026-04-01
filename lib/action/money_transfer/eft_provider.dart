import 'package:flutter_riverpod/flutter_riverpod.dart';

enum EftStep { input, confirm, success }

class EftState {
  final EftStep step;
  final String targetIban;
  final double amount;
  
  EftState({this.step = EftStep.input, this.targetIban = '', this.amount = 0});

  EftState copyWith({EftStep? step, String? targetIban, double? amount}) {
    return EftState(
      step: step ?? this.step,
      targetIban: targetIban ?? this.targetIban,
      amount: amount ?? this.amount,
    );
  }
}

class EftNotifier extends Notifier<EftState> {
  @override
  EftState build() {
    return EftState();
  }

  void nextStep(String iban, double amount) {
    state = state.copyWith(step: EftStep.confirm, targetIban: iban, amount: amount);
  }

  void completeTransfer() {
    state = state.copyWith(step: EftStep.success);
  }

  void reset() {
    state = EftState();
  }
}

final eftProvider = NotifierProvider<EftNotifier, EftState>(() => EftNotifier());