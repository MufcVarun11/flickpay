import 'package:flutter/material.dart';

class DotFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE4D50A).withValues(alpha: .28);
    const gap = 10.0;
    for (var row = 0; row < 18; row++) {
      for (var col = 0; col < 28; col++) {
        final fade = (1 - row / 18).clamp(0.0, 1.0);
        paint.color = const Color(0xFFE4D50A).withValues(alpha: .18 * fade);
        canvas.drawCircle(
          Offset(col * gap + (row.isEven ? 0 : gap / 2), row * gap),
          1.05,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant DotFieldPainter oldDelegate) => false;
}
