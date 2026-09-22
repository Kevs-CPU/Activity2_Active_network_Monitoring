import 'package:flutter/material.dart';

import 'network_health_helper.dart';

class HighQualityMediaPainter
    extends CustomPainter {
  final double strength;
  final Color color;

  const HighQualityMediaPainter({
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

    final Paint backgroundPaint =
        Paint()
          ..color =
              color.withValues(
            alpha:
                0.10 +
                    (safe * 0.10),
          );

    canvas.drawRect(
      Offset.zero & size,
      backgroundPaint,
    );

    final Paint circlePaint =
        Paint()
          ..color =
              color.withValues(
            alpha:
                0.10 +
                    (safe * 0.12),
          );

    canvas.drawCircle(
      Offset(
        size.width * 0.78,
        size.height * 0.30,
      ),
      size.height * 0.48,
      circlePaint,
    );

    final Paint mountainPaint =
        Paint()
          ..color =
              color.withValues(
            alpha:
                0.16 +
                    (safe * 0.16),
          );

    final Path mountain = Path()
      ..moveTo(
        0,
        size.height,
      )
      ..lineTo(
        size.width * 0.25,
        size.height * 0.42,
      )
      ..lineTo(
        size.width * 0.43,
        size.height * 0.68,
      )
      ..lineTo(
        size.width * 0.58,
        size.height * 0.30,
      )
      ..lineTo(
        size.width * 0.78,
        size.height * 0.64,
      )
      ..lineTo(
        size.width,
        size.height * 0.40,
      )
      ..lineTo(
        size.width,
        size.height,
      )
      ..close();

    canvas.drawPath(
      mountain,
      mountainPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant HighQualityMediaPainter
        oldDelegate,
  ) {
    return oldDelegate.strength !=
            strength ||
        oldDelegate.color != color;
  }
}