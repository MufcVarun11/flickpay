import 'package:flutter/material.dart';

class MoneyActions extends StatelessWidget {
  const MoneyActions({required this.visibleCount, super.key});

  final int visibleCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StaggeredReveal(
          visible: visibleCount >= 1,
          child: const _BenefitCard(
            imagePath: 'assets/images/single tap.png',
            title: 'Single tap payments',
            subtitle: 'Enjoy seamless payments without the wait for OTPs',
          ),
        ),
        const SizedBox(height: 10),
        _StaggeredReveal(
          visible: visibleCount >= 2,
          child: const _BenefitCard(
            imagePath: 'assets/images/failure icon.png',
            title: 'Zero failures',
            subtitle: 'Zero payment failures ensure you never miss an order',
          ),
        ),
        const SizedBox(height: 10),
        _StaggeredReveal(
          visible: visibleCount >= 3,
          child: const _BenefitCard(
            imagePath: 'assets/images/refund icon.png',
            title: 'Real-time refunds',
            subtitle:
                'No need to wait for refunds. FlickPay refunds are instant!',
          ),
        ),
        const SizedBox(height: 14),
        _StaggeredReveal(
          visible: visibleCount >= 4,
          child: const _AddMoneyButton(),
        ),
        const SizedBox(height: 16),
        _StaggeredReveal(
          visible: visibleCount >= 5,
          child: const _GiftCardTile(),
        ),
        const SizedBox(height: 26),
        _StaggeredReveal(
          visible: visibleCount >= 6,
          child: const _FooterMessage(),
        ),
      ],
    );
  }
}

class _StaggeredReveal extends StatelessWidget {
  const _StaggeredReveal({required this.visible, required this.child});

  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: visible ? Offset.zero : const Offset(0, .08),
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        child: child,
      ),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  final String imagePath;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A41).withValues(alpha: .90),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: .08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .16),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _IconTile(imagePath: imagePath),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    height: 1.12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .78),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF171820),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          color: Colors.white,
          colorBlendMode: BlendMode.srcIn,
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }
}

class _AddMoneyButton extends StatelessWidget {
  const _AddMoneyButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        onPressed: () {},
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF2C8F12),
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text('Add Money'),
      ),
    );
  }
}

class _GiftCardTile extends StatelessWidget {
  const _GiftCardTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF24242C).withValues(alpha: .92),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xFF9C6A16), Color(0xFFE0BC47)],
              ),
            ),
            child: const Icon(Icons.card_giftcard_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Claim Gift Card',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Enter gift card details to claim your gift card',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .62),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.white70),
        ],
      ),
    );
  }
}

class _FooterMessage extends StatelessWidget {
  const _FooterMessage();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Enjoy seamless\none tap payments',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white.withValues(alpha: .18),
        fontSize: 30,
        fontWeight: FontWeight.w900,
        height: 1.12,
        letterSpacing: .2,
      ),
    );
  }
}
