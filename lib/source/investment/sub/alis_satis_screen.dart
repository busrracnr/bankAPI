import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class _KurItem {
  final String pair;
  final String subtitle;
  final String satLabel;
  final String alLabel;
  final String satValue;
  final String alValue;

  const _KurItem({
    required this.pair,
    required this.subtitle,
    required this.satLabel,
    required this.alLabel,
    required this.satValue,
    required this.alValue,
  });
}

class AlisSatisScreen extends StatefulWidget {
  const AlisSatisScreen({super.key});

  @override
  State<AlisSatisScreen> createState() => _AlisSatisScreenState();
}

class _AlisSatisScreenState extends State<AlisSatisScreen>
    with SingleTickerProviderStateMixin {
  static const Color _green = Color(0xFF006837);
  static const Color _orange = Color(0xFFE07B00);

  late DateTime _lastUpdate;
  Timer? _tickTimer;
  int _countdown = 0;
  bool _justRefreshed = false;
  late AnimationController _flashController;
  late Animation<Color?> _flashColor;

  @override
  void initState() {
    super.initState();
    _lastUpdate = DateTime.now();
    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _flashColor = ColorTween(
      begin: const Color(0xFFB9F6CA),
      end: Colors.transparent,
    ).animate(CurvedAnimation(parent: _flashController, curve: Curves.easeOut));
    _resetCountdown();
    _tickTimer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  void _resetCountdown() {
    _countdown = 30 + Random().nextInt(11); // 30-40 saniye
  }

  void _onTick(Timer _) {
    if (!mounted) return;
    setState(() {
      _countdown--;
      if (_countdown <= 0) {
        _lastUpdate = DateTime.now();
        _justRefreshed = true;
        _flashController.forward(from: 0).then((_) {
          if (mounted) setState(() => _justRefreshed = false);
        });
        _resetCountdown();
      }
    });
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    _flashController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    final day = dt.day;
    final month = months[dt.month - 1];
    final year = dt.year;
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$day $month $year $h:$m:$s';
  }

  static const List<_KurItem> _kurlar = [
    _KurItem(
      pair: 'USD / TL',
      subtitle: 'Amerikan Doları / Türk Lirası',
      satLabel: 'USD SAT',
      alLabel: 'USD AL',
      satValue: '44,1628',
      alValue: '45,1961',
    ),
    _KurItem(
      pair: 'ALT (gr) / TL',
      subtitle: 'Altın / Türk Lirası',
      satLabel: 'ALT (gr) SAT',
      alLabel: 'ALT (gr) AL',
      satValue: '6.768,43',
      alValue: '6.931,62',
    ),
    _KurItem(
      pair: 'EUR / TL',
      subtitle: 'Euro / Türk Lirası',
      satLabel: 'EUR SAT',
      alLabel: 'EUR AL',
      satValue: '52,0702',
      alValue: '53,2911',
    ),
    _KurItem(
      pair: 'GMS\n(gr) / TL',
      subtitle: 'Gümüş / Türk Lirası',
      satLabel: 'GMS (gr) SAT',
      alLabel: 'GMS (gr) AL',
      satValue: '112,2546',
      alValue: '114,6194',
    ),
    _KurItem(
      pair: 'EUR / USD',
      subtitle: 'Euro / Amerikan\nDoları',
      satLabel: 'EUR SAT',
      alLabel: 'EUR AL',
      satValue: '1,1752',
      alValue: '1,1830',
    ),
    _KurItem(
      pair: 'GBP / TL',
      subtitle: 'İngiliz Sterlini /\nTürk Lirası',
      satLabel: 'GBP SAT',
      alLabel: 'GBP AL',
      satValue: '59,7802',
      alValue: '61,4397',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Alış / Satış',
          style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: const [
                Icon(Icons.campaign_outlined, color: _green),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Size özel kurlar listelenmektedir.',
                    style: TextStyle(color: _green, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Kur listesi
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Başlık satırı
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Döviz / Kıymetli Maden',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Düzenle',
                          style: TextStyle(color: _orange, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Kur satırları
                ..._kurlar.asMap().entries.map((entry) {
                  final i = entry.key;
                  final item = entry.value;
                  return Column(
                    children: [
                      _buildKurRow(item),
                      if (i < _kurlar.length - 1) const Divider(height: 1),
                    ],
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Son güncelleme
          AnimatedBuilder(
            animation: _flashColor,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _justRefreshed
                      ? (_flashColor.value ?? Colors.transparent)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: child,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_justRefreshed)
                  const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: SizedBox(
                      width: 11,
                      height: 11,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: Color(0xFF006837),
                      ),
                    ),
                  ),
                Text(
                  'Son Güncelleme: ${_formatDate(_lastUpdate)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: _justRefreshed ? _green : Colors.grey.shade600,
                    fontWeight: _justRefreshed ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${_countdown}s)',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKurRow(_KurItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Pair name + subtitle
          SizedBox(
            width: 110,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.pair,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _green,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
          // SAT
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    item.satValue,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.satLabel,
                    style: const TextStyle(fontSize: 9, color: _green, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          // AL
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    item.alValue,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.alLabel,
                    style: const TextStyle(fontSize: 9, color: _green, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
