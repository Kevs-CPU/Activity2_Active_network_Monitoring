import 'package:flutter/material.dart';

import 'network_health_helper.dart';

class OptimizedMediaPainter
    extends CustomPainter {
  final double strength;
  final Color color;

  const OptimizedMediaPainter({
    required this.strength,
    required this.color,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final double safe =
        safeStrength(strength);

    final Paint basePaint =
        Paint()
          ..color =
              color.withValues(
            alpha:
                0.07 +
                    (safe * 0.06),
          );

    canvas.drawRect(
      Offset.zero & size,
      basePaint,
    );

    final Paint linePaint =
        Paint()
          ..color =
              color.withValues(
            alpha:
                0.10 +
                    (safe * 0.10),
          )
          ..style =
              PaintingStyle.stroke
          ..strokeWidth = 2;

    for (int i = 0; i < 5; i++) {
      final double y =
          size.height *
              (0.15 + i * 0.18);

      canvas.drawLine(
        Offset(
          size.width * 0.45,
          y,
        ),
        Offset(
          size.width * 0.95,
          y,
        ),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant OptimizedMediaPainter
        oldDelegate,
  ) {
    return oldDelegate.strength !=
            strength ||
        oldDelegate.color != color;
  }
}