import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/repositories/providers.dart';

enum TransferStep { input, confirm, success }
enum TransferType { iban, hesap, telefon, karekod, diger }

class TransferFormState {
  final TransferStep step; // Akış adımı
  final TransferType type;
  final String recipientInfo;
  final String recipientName;
  final double amount;
  final String description;
  final bool useFullBalance; // Bakiyenin tümünü kullan toggle
  final String senderAccountId;

  TransferFormState({
    this.step = TransferStep.input,
    this.type = TransferType.iban,
    this.recipientInfo = "",
    this.recipientName = "",
    this.amount = 0.0,
    this.description = "",
    this.useFullBalance = false,
    this.senderAccountId = "",
  });

  TransferFormState copyWith({
    TransferStep? step,
    TransferType? type,
    String? recipientInfo,
    String? recipientName,
    double? amount,
    String? description,
    bool? useFullBalance,
    String? senderAccountId,
  }) {
    return TransferFormState(
      step: step ?? this.step,
      type: type ?? this.type,
      recipientInfo: recipientInfo ?? this.recipientInfo,
      recipientName: recipientName ?? this.recipientName,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      useFullBalance: useFullBalance ?? this.useFullBalance,
      senderAccountId: senderAccountId ?? this.senderAccountId,
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

  void setSenderAccountId(String id) {
    state = state.copyWith(senderAccountId: id);
  }

  void setAmount(double amount) {
    state = state.copyWith(amount: amount);
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
  }

  void setRecipientInfo(String info) {
    state = state.copyWith(recipientInfo: info);
  }

  void setRecipientName(String name) {
    state = state.copyWith(recipientName: name);
  }

  void toggleUseFullBalance(double balance) {
    bool newValue = !state.useFullBalance;
    state = state.copyWith(
      useFullBalance: newValue,
      amount: newValue ? balance : 0.0,
    );
  }

  void complete() => state = state.copyWith(step: TransferStep.success);
  void reset() => state = TransferFormState();
}

final transferProvider = NotifierProvider<TransferNotifier, TransferFormState>(() => TransferNotifier());

// API üzerinden para gönderme
final sendMoneyProvider = FutureProvider.family<void, Map<String, dynamic>>((ref, params) async {
  final repo = ref.watch(transferRepositoryProvider);
  await repo.sendMoney(
    senderAccountId: params['senderAccountId'] as String,
    receiverIban: params['receiverIban'] as String,
    amount: params['amount'] as double,
    receiverName: params['receiverName'] as String?,
    description: params['description'] as String?,
  );
});