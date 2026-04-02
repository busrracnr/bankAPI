import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../action/money_transfer/transfer_manager.dart';
import '../components/primary_button.dart';

class TransferFlowScreen extends ConsumerWidget {
  final int initialTabIndex;
  
  const TransferFlowScreen({super.key, this.initialTabIndex = 0});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transferProvider);

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
      body: _buildBody(state, ref, context),
    );
  }

  Widget _buildBody(TransferFormState state, WidgetRef ref, BuildContext context) {
    switch (state.step) {
      case TransferStep.input:
        return _buildInputView(ref); // BURAYI DÜZELTTİK
      case TransferStep.confirm:
        return _buildConfirmView(state, ref);
      case TransferStep.success:
        return _buildSuccessView(state, ref, context);
    }
  }

  // --- 1. ADIM: GELİŞMİŞ GİRİŞ EKRANI (SEKMELİ) ---
  Widget _buildInputView(WidgetRef ref) {
    return DefaultTabController(
      length: 5,
      initialIndex: initialTabIndex,
      child: Column(
        children: [
          // Sekme Başlıkları
          Container(
            color: Colors.white,
            child: const TabBar(
              isScrollable: true,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.teal,
              indicatorWeight: 3,
              tabs: [
                Tab(text: "IBAN"),
                Tab(text: "Hesap"),
                Tab(text: "Telefon No"),
                Tab(text: "TR Karekod"),
                Tab(text: "Diğer"),
              ],
            ),
          ),
          
          // Gönderen Hesap Bilgisi (Resimdeki kart)
          _buildSenderInfo(),

          // Sekme İçerikleri
          Expanded(
            child: TabBarView(
              children: [
                _buildIbanTab(ref),
                _buildAccountTab(ref),
                _buildPhoneTab(ref), // İSTEDİĞİN TELEFON KISMI BURADA
                _buildQrTab(),
                _buildOtherTab(),
              ],
            ),
          ),

          // Alt Buton Alanı
          _buildBottomArea(ref),
        ],
      ),
    );
  }

  // --- TELEFON NO SEKMESİ ---
  Widget _buildPhoneTab(WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _customInput(label: "Telefon No", hint: "(5xx) xxx xx xx", icon: Icons.contact_page_outlined),
        _customInput(label: "İşlem Tarihi", hint: "02.04.2026", icon: Icons.chevron_right),
        _buildSwitchRow("Bakiyenin tümünü kullan"),
        _customInput(label: "Tutar", hint: "Giriniz", suffix: "TL"),
        _customInput(label: "Ödeme Türü Seçimi", hint: "Bireysel Ödeme", icon: Icons.chevron_right),
        _customInput(label: "Açıklama", hint: "İsteğe Bağlı"),
        _buildSwitchRow("Kayıtlı işlemlere ekle"),
      ],
    );
  }

  // --- YARDIMCI WIDGETLAR (TASARIM İÇİN) ---

  Widget _buildSenderInfo() {
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
            children: const [
              Text("98750438-1", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Cari Hesap >", style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text("427,63 TL", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            ],
          )
        ],
      ),
    );
  }

  Widget _customInput({required String label, required String hint, IconData? icon, String? suffix}) {
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

  Widget _buildBottomArea(WidgetRef ref) {
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
              // Burada şimdilik dummy verilerle onay ekranına geçiyoruz
              ref.read(transferProvider.notifier).nextToConfirm("532 XXX XX XX", "Zeynep Büşra", 100.0);
            }
          ),
        ],
      ),
    );
  }

  // Diğer boş sekmeler için taslaklar
  Widget _buildIbanTab(WidgetRef ref) {
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
        _customInput(label: "IBAN", hint: "Giriniz", icon: Icons.camera_alt),
        _customInput(label: "Alıcı Adı Soyadı", hint: "Giriniz"),
        _buildDatePickerField(label: "İşlem Tarihi"),
        _buildSwitchRow("Bakiyenin tümünü kullan"),
        _customInput(label: "Tutar", hint: "Giriniz", suffix: "TL"),
        _customInput(label: "Ödeme Türü Seçimi", hint: "Bireysel Ödeme", icon: Icons.chevron_right),
        _customInput(label: "Açıklama", hint: "İsteğe Bağlı"),
        _buildSwitchRow("Kayıtlı işlemlere ekle"),
      ],
    );
  }
  Widget _buildAccountTab(WidgetRef ref) {
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
        _customInput(label: "Hesap No", hint: "Giriniz"),
        _customInput(label: "Alıcı Adı Soyadı", hint: "Giriniz"),
        _buildDatePickerField(label: "İşlem Tarihi"),
        _buildSwitchRow("Bakiyenin tümünü kullan"),
        _customInput(label: "Tutar", hint: "Giriniz", suffix: "TL"),
        _customInput(label: "Ödeme Türü Seçimi", hint: "Bireysel Ödeme", icon: Icons.chevron_right),
        _customInput(label: "Açıklama", hint: "İsteğe Bağlı"),
        _buildSwitchRow("Kayıtlı işlemlere ekle"),
      ],
    );
  }
  Widget _buildQrTab() => const Center(child: Text("QR Kod Okuyucu"));
  Widget _buildOtherTab() => const Center(child: Text("Diğer İşlemler"));

  // --- ONAY VE BAŞARI EKRANLARI (SENİN KODUNDAKİLERLE AYNI) ---
  Widget _buildConfirmView(TransferFormState state, WidgetRef ref) {
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
                  _confirmRow("Alıcı", state.recipientName),
                  _confirmRow("Bilgi", state.recipientInfo),
                  const Divider(),
                  _confirmRow("Tutar", "${state.amount} TL", isBold: true),
                  _confirmRow("Masraf", "0,00 TL"),
                ],
              ),
            ),
          ),
          const Spacer(),
          PrimaryButton(
            text: "Onayla ve Gönder",
            onPressed: () => ref.read(transferProvider.notifier).complete(),
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
}