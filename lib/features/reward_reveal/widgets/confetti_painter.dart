import 'dart:math' as math;

import 'package:flutter/material.dart';

class ConfettiPainter extends CustomPainter {
  ConfettiPainter({required Animation<double> repaint})
    : _progress = repaint,
      super(repaint: repaint);

  final Animation<double> _progress;

  static const List<Color> _colors = [
    Color(0xFFE4D50A),
    Color(0xFF1AB6FF),
    Color(0xFFFF4BA2),
    Color(0xFF21D974),
    Color(0xFFFF8D28),
    Color(0xFF815CFF),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final progress = _progress.value;
    final opacity = (1 - ((progress - .68) / .32)).clamp(0.0, 1.0);
    if (opacity == 0) return;

    final paint = Paint()..style = PaintingStyle.fill;
    for (var index = 0; index < 18; index++) {
      final seed = index * 19.37;
      final lane = ((math.sin(seed) + 1) / 2) * size.width;
      final speed = .78 + (index % 6) * .08;
      final y =
          ((progress * speed + (index * .083)) % 1.22) * size.height -
          size.height * .12;
      final sway = math.sin(progress * math.pi * 2 + seed) * 18;
      final x = lane + sway;
      final length = 6.0 + (index % 3) * 3;
      final width = 2.0 + (index % 2);
      final angle = progress * math.pi * 2.6 + seed;

      paint.color = _colors[index % _colors.length].withValues(
        alpha: .78 * opacity,
      );
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: width, height: length),
          const Radius.circular(4),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) {
    return oldDelegate._progress != _progress;
  }
}
