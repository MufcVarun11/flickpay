import 'package:flutter/material.dart';

import 'dot_field_painter.dart';

class Backdrop extends StatelessWidget {
  const Backdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF4D4A06).withValues(alpha: .88),
            const Color(0xFF202026),
            const Color(0xFF111218),
          ],
          stops: const [0, .5, 1],
        ),
      ),
      child: CustomPaint(painter: DotFieldPainter()),
    );
  }
}
