import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final String optionText;
  final VoidCallback onTap;

  const OptionCard({super.key, required this.optionText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        elevation: 0,
        color: const Color(0xFFF4F8FC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE1EAF2), width: 1.5),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Center(
            child: Text(
              optionText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0B2D4A),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
