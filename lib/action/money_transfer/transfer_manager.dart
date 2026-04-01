import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TransferStep { input, confirm, success }
enum TransferType { iban, hesap, telefon, karekod, diger }

class TransferFormState {
  final TransferStep step; // Akış adımı
  final TransferType type;
  final String recipientInfo;
  final String recipientName;
  final double amount;

  TransferFormState({
    this.step = TransferStep.input,
    this.type = TransferType.iban,
    this.recipientInfo = "",
    this.recipientName = "",
    this.amount = 0.0,
  });

  TransferFormState copyWith({
    TransferStep? step,
    TransferType? type,
    String? recipientInfo,
    String? recipientName,
    double? amount,
  }) {
    return TransferFormState(
      step: step ?? this.step,
      type: type ?? this.type,
      recipientInfo: recipientInfo ?? this.recipientInfo,
      recipientName: recipientName ?? this.recipientName,
      amount: amount ?? this.amount,
    );
  }
}

class TransferNotifier extends Notifier<TransferFormState> {
  @override
  TransferFormState build() => TransferFormState();

  void nextToConfirm(String info, String name, double amount) {
    state = state.copyWith(
      step: TransferStep.confirm,
      recipientInfo: info,
      recipientName: name,
      amount: amount,
    );
  }

  void complete() => state = state.copyWith(step: TransferStep.success);
  void reset() => state = TransferFormState();
}

final transferProvider = NotifierProvider.autoDispose<TransferNotifier, TransferFormState>(() => TransferNotifier());