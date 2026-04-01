import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../action/money_transfer/eft_provider.dart';
import '../components/primary_button.dart';

class EftScreen extends ConsumerWidget {
  const EftScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eftState = ref.watch(eftProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Para Transferi")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _buildFlow(eftState, ref),
      ),
    );
  }

  Widget _buildFlow(EftState state, WidgetRef ref) {
    switch (state.step) {
      case EftStep.input: return const _InputView();
      case EftStep.confirm: return _ConfirmView(state: state, ref: ref);
      case EftStep.success: return _SuccessView(ref: ref);
    }
  }
}

// 1. ADIM: VALIDASYONLU GİRİŞ
class _InputView extends StatefulWidget {
  const _InputView();

  @override
  State<_InputView> createState() => _InputViewState();
}

class _InputViewState extends State<_InputView> {
  final _formKey = GlobalKey<FormState>();
  final _ibanController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _ibanController,
            decoration: const InputDecoration(labelText: "Alıcı IBAN", hintText: "TR...", border: OutlineInputBorder()),
            validator: (value) {
              if (value == null || value.isEmpty) return "IBAN boş bırakılamaz";
              if (!value.startsWith("TR")) return "Geçerli bir IBAN giriniz";
              if (value.length < 26) return "IBAN eksik karakter içeriyor";
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Tutar", suffixText: "TL", border: OutlineInputBorder()),
            validator: (value) {
              if (value == null || value.isEmpty) return "Lütfen tutar girin";
              if (double.tryParse(value) == null) return "Sadece rakam giriniz";
              if (double.parse(value) <= 0) return "Tutar 0'dan büyük olmalı";
              return null;
            },
          ),
          const SizedBox(height: 40),
          // Consumer kullanarak sadece butonu Riverpod'a bağlıyoruz
          Consumer(builder: (context, ref, child) {
            return PrimaryButton(
              text: "Devam Et",
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ref.read(eftProvider.notifier).nextStep(
                    _ibanController.text, 
                    double.parse(_amountController.text)
                  );
                }
              },
            );
          }),
        ],
      ),
    );
  }
}

// 2. ADIM: ONAY
class _ConfirmView extends StatelessWidget {
  final EftState state;
  final WidgetRef ref;

  const _ConfirmView({required this.state, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Transferi onaylıyor musunuz?"),
        Text("IBAN: ${state.targetIban}"),
        Text("Tutar: ${state.amount} TL"),
        const SizedBox(height: 20),
        PrimaryButton(
          text: "Onayla",
          onPressed: () => ref.read(eftProvider.notifier).completeTransfer(),
        ),
      ],
    );
  }
}

// 3. ADIM: BAŞARILI
class _SuccessView extends StatelessWidget {
  final WidgetRef ref;

  const _SuccessView({required this.ref});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 64),
        const Text("Transfer Başarıyla Tamamlandı!"),
        const SizedBox(height: 20),
        PrimaryButton(
          text: "Yeni Transfer",
          onPressed: () => ref.read(eftProvider.notifier).reset(),
        ),
      ],
    );
  }
}