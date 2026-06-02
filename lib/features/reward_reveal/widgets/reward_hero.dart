import 'package:flutter/material.dart';

import 'wallet_badge.dart';

class RewardHero extends StatelessWidget {
  const RewardHero({
    required this.walletScale,
    required this.textOpacity,
    required this.drift,
    super.key,
  });

  final double walletScale;
  final double textOpacity;
  final double drift;

  @override
  Widget build(BuildContext context) {
    final iconLift = -10 + drift * 5;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.translate(
          offset: Offset(0, iconLift),
          child: Transform.rotate(
            angle: -.18 + drift * .03,
            child: AnimatedScale(
              scale: .62 + walletScale * .38,
              duration: const Duration(milliseconds: 440),
              curve: Curves.easeOutBack,
              child: const WalletBadge(),
            ),
          ),
        ),
        const SizedBox(height: 18),
        AnimatedOpacity(
          opacity: textOpacity,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOut,
          child: Column(
            children: [
              Text(
                'FlickPay',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .74),
                  fontSize: 21,
                  height: .9,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'MONEY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    height: .95,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
