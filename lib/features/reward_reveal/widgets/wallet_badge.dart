import 'package:flutter/material.dart';

class WalletBadge extends StatelessWidget {
  const WalletBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 78,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE5DB1B), Color(0xFFAEB000), Color(0xFF727B00)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE4D50A).withValues(alpha: .36),
            blurRadius: 34,
            spreadRadius: 1,
            offset: const Offset(0, 18),
          ),
          const BoxShadow(
            color: Colors.black38,
            blurRadius: 18,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 12,
            top: 11,
            child: Container(
              width: 58,
              height: 9,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .14),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          const Center(
            child: Icon(
              Icons.currency_rupee_rounded,
              color: Colors.white,
              size: 40,
              weight: 800,
            ),
          ),
        ],
      ),
    );
  }
}
