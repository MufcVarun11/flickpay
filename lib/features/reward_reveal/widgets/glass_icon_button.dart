import 'package:flutter/material.dart';

class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: .12),
        foregroundColor: Colors.white,
        fixedSize: const Size(42, 42),
      ),
    );
  }
}
