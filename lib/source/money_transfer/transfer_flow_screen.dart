import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../action/money_transfer/account_provider.dart';
import '../../action/money_transfer/transfer_manager.dart';
import '../../core/repositories/providers.dart';
import '../components/primary_button.dart';

class TransferFlowScreen extends ConsumerStatefulWidget {
  final int initialTabIndex;

  const TransferFlowScreen({super.key, this.initialTabIndex = 0});

  @override
  ConsumerState<TransferFlowScreen> createState() => _TransferFlowScreenState();
}

class _TransferFlowScreenState extends ConsumerState<TransferFlowScreen> with SingleTickerProviderStateMixin {
  bool _isSending = false;
  String? _ibanOwnerName;
  bool _ibanLookupLoading = false;
  String? _ibanLookupError;
  Timer? _ibanDebounce;
  late TabController _tabController;
  int _activeTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this, initialIndex: widget.initialTabIndex);
    _activeTab = widget.initialTabIndex;
    _tabController.addListener(() {
      if (_tabController.indexIsChanging || _tabController.index != _activeTab) {
        setState(() => _activeTab = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _ibanDebounce?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  void _onIbanChanged(String value, WidgetRef ref) {
    ref.read(transferProvider.notifier).setRecipientInfo(value);
    _ibanDebounce?.cancel();
    // TR IBAN'ı 26 karakter
    if (value.length == 26) {
      setState(() {
        _ibanLookupLoading = true;
        _ibanOwnerName = null;
        _ibanLookupError = null;
      });
      _ibanDebounce = Timer(const Duration(milliseconds: 400), () async {
        final repo = ref.read(transferRepositoryProvider);
        final name = await repo.lookupIban(value);
        if (!mounted) return;
        setState(() {
          _ibanLookupLoading = false;
          if (name != null) {
            _ibanOwnerName = name;
            _ibanLookupError = null;
          } else {
            _ibanOwnerName = null;
            _ibanLookupError = 'Bu IBAN bulunamadı';
          }
        });
      });
    } else {
      setState(() {
        _ibanOwnerName = null;
        _ibanLookupError = null;
        _ibanLookupLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transferProvider);
    final accountsAsync = ref.watch(accountsProvider);
    final senderAccount = accountsAsync.asData?.value.firstOrNull as Map<String, dynamic>?;
    final accountBalance = double.tryParse(senderAccount?['balance']?.toString() ?? '0') ?? 0.0;

    // Sender account ID'yi state'e kaydet
    if (senderAccount != null && state.senderAccountId.isEmpty) {
      Future.microtask(() {
        ref.read(transferProvider.notifier).setSenderAccountId(senderAccount['id'] as String);
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          state.step == TransferStep.input ? "Başka Hesaba (Havale / EFT / FAST)" : "İşlem Onayı",
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () {
            if (state.step == TransferStep.confirm) {
              ref.read(transferProvider.notifier).reset();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          if (state.step == TransferStep.input)
            TextButton(onPressed: () {}, child: const Text("Limitler", style: TextStyle(color: Colors.teal)))
        ],
      ),
      body: _buildBody(state, ref, context, accountBalance, senderAccount),
    );
  }

  Widget _buildBody(TransferFormState state, WidgetRef ref, BuildContext context, double accountBalance, Map<String, dynamic>? senderAccount) {
    switch (state.step) {
      case TransferStep.input:
        return _buildInputView(ref, state, accountBalance, context, senderAccount);
      case TransferStep.confirm:
        return _buildConfirmView(state, ref, context);
      case TransferStep.success:
        return _buildSuccessView(state, ref, context);
    }
  }

  // --- 1. ADIM: GELİŞMİŞ GİRİŞ EKRANI (SEKMELİ) ---
  Widget _buildInputView(WidgetRef ref, TransferFormState state, double accountBalance, BuildContext context, Map<String, dynamic>? senderAccount) {
    return Column(
        children: [
          // Sekme Başlıkları
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.teal,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: "IBAN"),
                Tab(text: "Hesap"),
                Tab(text: "Telefon No"),
                Tab(text: "TR Karekod"),
                Tab(text: "Diğer"),
                Tab(text: "Hesaplarım"),
              ],
            ),
          ),
          
          // Gönderen Hesap Bilgisi (Resimdeki kart)
          _buildSenderInfo(accountBalance, senderAccount),

          // Sekme İçerikleri
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildIbanTab(ref, accountBalance),
                _buildAccountTab(ref, accountBalance),
                _buildPhoneTab(ref, accountBalance),
                _buildQrTab(),
                _buildOtherTab(),
                _buildInterAccountTab(ref, accountBalance),
              ],
            ),
          ),

          // Alt Buton Alanı — Hesaplarım sekmesinde gösterme (kendi butonu var)
          if (_activeTab != 5)
            _buildBottomArea(ref, state, accountBalance, context),
        ],
      );
  }

  // --- TELEFON NO SEKMESİ ---
  Widget _buildPhoneTab(WidgetRef ref, double accountBalance) {
    final state = ref.watch(transferProvider);
    
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _customInput(
          label: "Telefon No",
          hint: "(5xx) xxx xx xx",
          icon: Icons.contact_page_outlined,
          onChanged: (value) => ref.read(transferProvider.notifier).setRecipientInfo(value),
          initialValue: state.recipientInfo,
        ),
        _buildDatePickerField(label: "İşlem Tarihi"),
        _buildBalanceSwitchRow(ref, state, accountBalance),
        _buildTutarInput(ref, state),
        _customInput(label: "Ödeme Türü Seçimi", hint: "Bireysel Ödeme", icon: Icons.chevron_right),
        _customInput(
          label: "Açıklama",
          hint: "İsteğe Bağlı",
          onChanged: (value) => ref.read(transferProvider.notifier).setDescription(value),
          initialValue: state.description,
        ),
        _buildSwitchRow("Kayıtlı işlemlere ekle"),
      ],
    );
  }

  // --- YARDIMCI WIDGETLAR (TASARIM İÇİN) ---

  Widget _buildSenderInfo(double accountBalance, Map<String, dynamic>? senderAccount) {
    final iban = senderAccount?['iban'] as String? ?? '';
    final shortIban = iban.length > 8 ? iban.substring(iban.length - 8) : iban;
    final name = senderAccount?['name'] as String? ?? 'Cari Hesap';
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Text("Gönderen", style: TextStyle(color: Colors.grey)),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(shortIban, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("$name >", style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text("${_formatAmount(accountBalance)} TL", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            ],
          )
        ],
      ),
    );
  }

  Widget _customInput({required String label, required String hint, IconData? icon, String? suffix, ValueChanged<String>? onChanged, String? initialValue}) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13))),
          Expanded(
            flex: 3,
            child: TextField(
              textAlign: TextAlign.right,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                border: InputBorder.none,
                suffixIcon: icon != null ? Icon(icon, color: Colors.orange, size: 20) : null,
                suffixText: suffix,
                suffixStyle: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13)),
        Switch(value: false, onChanged: (v) {}, activeColor: Colors.teal),
      ],
    );
  }

  Widget _buildBalanceSwitchRow(WidgetRef ref, TransferFormState state, double accountBalance) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Bakiyenin tümünü kullan", style: const TextStyle(color: Colors.black54, fontSize: 13)),
          Switch(
            value: state.useFullBalance,
            onChanged: (v) {
              ref.read(transferProvider.notifier).toggleUseFullBalance(accountBalance);
            },
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildTutarInput(WidgetRef ref, TransferFormState state) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: const Text("Tutar", style: TextStyle(color: Colors.black54, fontSize: 13)),
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              key: ValueKey('amount_input_${state.useFullBalance}'),
              initialValue: state.amount > 0 ? _formatAmountForInput(state.amount) : "",
              textAlign: TextAlign.right,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                final amount = double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
                ref.read(transferProvider.notifier).setAmount(amount);
              },
              decoration: const InputDecoration(
                hintText: "Giriniz",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                border: InputBorder.none,
                suffixText: "TL",
                suffixStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerField({required String label}) {
    return Builder(
      builder: (context) {
        return Container(
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateTime.now().toString().split(' ')[0].split('-').reversed.join('.'),
                  style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: Colors.orange, size: 20),
              ],
            ),
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                // Seçilen tarihi formatla (DD.MM.YYYY)
                String formattedDate = 
                    "${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}";
                // Burada tarihi state'e kaydedebilirsin
                print("Seçilen tarih: $formattedDate");
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildBottomArea(WidgetRef ref, TransferFormState state, double accountBalance, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          const Text("fast", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 20, fontStyle: FontStyle.italic)),
          const SizedBox(height: 8),
          PrimaryButton(
            text: "İleri",
            onPressed: () {
              if (state.amount <= 0) {
                return;
              }

              if (state.amount > accountBalance) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Yetersiz bakiye")),
                );
                return;
              }

              ref.read(transferProvider.notifier).nextToConfirm(
                state.recipientInfo,
                state.recipientName,
                state.amount,
              );
            },
          ),
        ],
      ),
    );
  }

  // Diğer boş sekmeler için taslaklar
  Widget _buildIbanTab(WidgetRef ref, double accountBalance) {
    final state = ref.watch(transferProvider);
    
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // Uyarı Mesajı
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3CD),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            "Kayıtlı İşlemlerden Yap",
            style: TextStyle(color: Color(0xFFB8860B), fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        _customInput(
          label: "IBAN",
          hint: "Giriniz",
          icon: Icons.camera_alt,
          onChanged: (value) => _onIbanChanged(value, ref),
          initialValue: state.recipientInfo,
        ),
        if (_ibanLookupLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.teal)),
                SizedBox(width: 8),
                Text("IBAN sorgulanıyor...", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          )
        else if (_ibanOwnerName != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.teal, size: 16),
                const SizedBox(width: 6),
                Text(_ibanOwnerName!, style: const TextStyle(fontSize: 13, color: Colors.teal, fontWeight: FontWeight.w600)),
              ],
            ),
          )
        else if (_ibanLookupError != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 16),
                const SizedBox(width: 6),
                Text(_ibanLookupError!, style: const TextStyle(fontSize: 12, color: Colors.red)),
              ],
            ),
          ),
        _customInput(
          label: "Alıcı Adı Soyadı",
          hint: _ibanOwnerName ?? "Giriniz",
          onChanged: (value) => ref.read(transferProvider.notifier).setRecipientName(value),
          initialValue: state.recipientName,
        ),
        _buildDatePickerField(label: "İşlem Tarihi"),
        _buildBalanceSwitchRow(ref, state, accountBalance),
        _buildTutarInput(ref, state),
        _customInput(label: "Ödeme Türü Seçimi", hint: "Bireysel Ödeme", icon: Icons.chevron_right),
        _customInput(
          label: "Açıklama",
          hint: "İsteğe Bağlı",
          onChanged: (value) => ref.read(transferProvider.notifier).setDescription(value),
          initialValue: state.description,
        ),
        _buildSwitchRow("Kayıtlı işlemlere ekle"),
      ],
    );
  }
  Widget _buildAccountTab(WidgetRef ref, double accountBalance) {
    final state = ref.watch(transferProvider);
    
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // Uyarı Mesajı
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3CD),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            "Kayıtlı İşlemlerden Yap",
            style: TextStyle(color: Color(0xFFB8860B), fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        _customInput(
          label: "Hesap No",
          hint: "Giriniz",
          onChanged: (value) => ref.read(transferProvider.notifier).setRecipientInfo(value),
          initialValue: state.recipientInfo,
        ),
        _customInput(
          label: "Alıcı Adı Soyadı",
          hint: "Giriniz",
          onChanged: (value) => ref.read(transferProvider.notifier).setRecipientName(value),
          initialValue: state.recipientName,
        ),
        _buildDatePickerField(label: "İşlem Tarihi"),
        _buildBalanceSwitchRow(ref, state, accountBalance),
        _buildTutarInput(ref, state),
        _customInput(label: "Ödeme Türü Seçimi", hint: "Bireysel Ödeme", icon: Icons.chevron_right),
        _customInput(
          label: "Açıklama",
          hint: "İsteğe Bağlı",
          onChanged: (value) => ref.read(transferProvider.notifier).setDescription(value),
          initialValue: state.description,
        ),
        _buildSwitchRow("Kayıtlı işlemlere ekle"),
      ],
    );
  }
  Widget _buildQrTab() => const Center(child: Text("QR Kod Okuyucu"));
  Widget _buildOtherTab() => const Center(child: Text("Diğer İşlemler"));

  // --- HESAPLARIM ARASI TRANSFER ---
  Widget _buildInterAccountTab(WidgetRef ref, double accountBalance) {
    final state = ref.watch(transferProvider);
    final accountsAsync = ref.watch(accountsProvider);
    final accounts = accountsAsync.asData?.value.cast<Map<String, dynamic>>() ?? [];
    final sender = accounts.isNotEmpty ? accounts.first : null;
    final receiver = accounts.length > 1 ? accounts[1] : null;
    // Hesabıma sekmesi için alıcı IBAN'ı local olarak tut, global state'i kirletme
    final interAccountIban = receiver?['iban'] as String? ?? '';

    Widget accountCard(Map<String, dynamic>? acc, String label, Color borderColor) {
      if (acc == null) return const SizedBox();
      final iban = acc['iban'] as String? ?? '';
      final shortIban = iban.length > 8 ? iban.substring(iban.length - 8) : iban;
      final balance = double.tryParse(acc['balance'].toString()) ?? 0.0;
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Text(shortIban, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(acc['name'] as String? ?? '', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text("${_formatAmount(balance)} TL",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 16),
        accountCard(sender, "Gönderen Hesap", Colors.teal.shade200),
        const SizedBox(height: 16),
        Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.teal.shade100),
            child: const Icon(Icons.arrow_downward, color: Colors.teal),
          ),
        ),
        const SizedBox(height: 16),
        accountCard(receiver, "Alıcı Hesap", Colors.orange.shade200),
        const SizedBox(height: 16),
        _buildBalanceSwitchRow(ref, state, accountBalance),
        const SizedBox(height: 8),
        // Tutar Input
        Container(
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const Expanded(
                flex: 2,
                child: Text("Tutar", style: TextStyle(color: Colors.black54, fontSize: 13)),
              ),
              Expanded(
                flex: 3,
                child: TextFormField(
                  key: ValueKey('inter_account_amount_${state.useFullBalance}'),
                  initialValue: state.amount > 0 ? _formatAmountForInput(state.amount) : "",
                  textAlign: TextAlign.right,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    final amount = double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
                    ref.read(transferProvider.notifier).setAmount(amount);
                  },
                  decoration: const InputDecoration(
                    hintText: "Giriniz",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    border: InputBorder.none,
                    suffixText: "TL",
                    suffixStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Açıklama
        _customInput(
          label: "Açıklama",
          hint: "İsteğe Bağlı",
          onChanged: (value) => ref.read(transferProvider.notifier).setDescription(value),
          initialValue: state.description,
        ),
        const SizedBox(height: 16),
        // Hesaplarım sekmesine özel İleri butonu
        Builder(builder: (context) {
          return PrimaryButton(
            text: "İleri",
            onPressed: () {
              if (state.amount <= 0) return;
              if (state.amount > accountBalance) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Yetersiz bakiye")),
                );
                return;
              }
              final receiverName = receiver != null ? (receiver['name'] as String? ?? '') : '';
              ref.read(transferProvider.notifier).nextToConfirm(
                interAccountIban,
                receiverName,
                state.amount,
              );
            },
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }

  // --- ONAY VE BAŞARI EKRANLARI (SENİN KODUNDAKİLERLE AYNI) ---
  Widget _buildConfirmView(TransferFormState state, WidgetRef ref, BuildContext context) {
    // senderAccountId'yi her zaman anlık accountsProvider'dan al
    final accountsAsync = ref.watch(accountsProvider);
    final senderAccount = accountsAsync.asData?.value.firstOrNull as Map<String, dynamic>?;
    final senderAccountId = senderAccount?['id'] as String? ?? '';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text("Lütfen bilgileri kontrol ediniz.", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _confirmRow("Alıcı", state.recipientName.isEmpty ? '-' : state.recipientName),
                  _confirmRow("IBAN", state.recipientInfo),
                  const Divider(),
                  _confirmRow("Tutar", "${_formatAmount(state.amount)} TL", isBold: true),
                  _confirmRow("Masraf", "0,00 TL"),
                  if (state.description.isNotEmpty) _confirmRow("Açıklama", state.description),
                ],
              ),
            ),
          ),
          const Spacer(),
          if (_isSending)
            const SizedBox(
              height: 50,
              child: Center(child: CircularProgressIndicator(color: Colors.teal, strokeWidth: 3)),
            )
          else
            PrimaryButton(
              text: "Onayla ve Gönder",
              onPressed: () async {
                if (senderAccountId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Gönderen hesap bilgisi alınamadı")),
                  );
                  return;
                }
                setState(() => _isSending = true);
                try {
                  await ref.read(transferRepositoryProvider).sendMoney(
                    senderAccountId: senderAccountId,
                    receiverIban: state.recipientInfo,
                    amount: state.amount,
                    receiverName: state.recipientName.isEmpty ? null : state.recipientName,
                    description: state.description.isEmpty ? null : state.description,
                  );
                  ref.invalidate(accountsProvider);
                  ref.read(transferProvider.notifier).complete();
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
                    );
                  }
                  setState(() => _isSending = false);
                }
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(TransferFormState state, WidgetRef ref, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 100),
          const SizedBox(height: 20),
          const Text("İşleminiz Başarıyla Gerçekleşti", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: PrimaryButton(text: "Dekont Al", onPressed: () {}),
          ),
          TextButton(
            onPressed: () {
              ref.read(transferProvider.notifier).reset();
              Navigator.pop(context);
            },
            child: const Text("Ana Sayfaya Dön"),
          )
        ],
      ),
    );
  }

  Widget _confirmRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(2).replaceAll('.', ',');
  }

  String _formatAmountForInput(double amount) {
    return amount.toStringAsFixed(2);
  }
}