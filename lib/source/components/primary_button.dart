import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      // Hiçbir renk vermiyoruz, otomatik Theme içindeki primary'i kullanır
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}