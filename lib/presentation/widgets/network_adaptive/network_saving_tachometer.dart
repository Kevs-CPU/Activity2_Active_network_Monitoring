import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'network_health_helper.dart';

class NetworkSavingTachometer
    extends StatelessWidget {
  final double strength;
  final Color color;

  const NetworkSavingTachometer({
    super.key,
    required this.strength,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter:
          NetworkSavingTachometerPainter(
        strength: strength,
        color: color,
      ),
    );
  }
}

class NetworkSavingTachometerPainter
    extends CustomPainter {
  final double strength;
  final Color color;

  const NetworkSavingTachometerPainter({
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

    final Offset center = Offset(
      size.width * 0.50,
      size.height * 0.82,
    );

    final double radius = math.min(
      size.width * 0.38,
      size.height * 0.64,
    );

    const double startAngle = 3.55;
    const double totalAngle = 3.05;

    final Rect arcRect =
        Rect.fromCircle(
      center: center,
      radius: radius,
    );

    final Paint trackPaint = Paint()
      ..style =
          PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap =
          StrokeCap.round
      ..color =
          Colors.grey.withValues(
        alpha: 0.18,
      );

    canvas.drawArc(
      arcRect,
      startAngle,
      totalAngle,
      false,
      trackPaint,
    );

    final Paint glowPaint = Paint()
      ..style =
          PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap =
          StrokeCap.round
      ..color = color.withValues(
        alpha:
            0.08 +
                (safe * 0.25),
      );

    canvas.drawArc(
      arcRect,
      startAngle,
      totalAngle * safe,
      false,
      glowPaint,
    );

    final Paint progressPaint =
        Paint()
          ..style =
              PaintingStyle.stroke
          ..strokeWidth =
              5 + (safe * 1.0)
          ..strokeCap =
              StrokeCap.round
          ..color = color;

    canvas.drawArc(
      arcRect,
      startAngle,
      totalAngle * safe,
      false,
      progressPaint,
    );

    final Paint tickPaint = Paint()
      ..style =
          PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap =
          StrokeCap.round
      ..color =
          Colors.grey.withValues(
        alpha: 0.35,
      );

    const int tickCount = 7;

    for (int i = 0;
        i < tickCount;
        i++) {
      final double ratio =
          i / (tickCount - 1);

      final double angle =
          startAngle +
              (totalAngle * ratio);

      final double outerRadius =
          radius + 4;

      final double innerRadius =
          radius + 1.5;

      final Offset outer =
          Offset(
        center.dx +
            math.cos(angle) *
                outerRadius,
        center.dy +
            math.sin(angle) *
                outerRadius,
      );

      final Offset inner =
          Offset(
        center.dx +
            math.cos(angle) *
                innerRadius,
        center.dy +
            math.sin(angle) *
                innerRadius,
      );

      canvas.drawLine(
        inner,
        outer,
        tickPaint,
      );
    }

    final double needleAngle =
        startAngle +
            (totalAngle * safe);

    final double needleLength =
        radius - 2;

    final Offset needleEnd =
        Offset(
      center.dx +
          math.cos(needleAngle) *
              needleLength,
      center.dy +
          math.sin(needleAngle) *
              needleLength,
    );

    final Paint needleGlowPaint =
        Paint()
          ..style =
              PaintingStyle.stroke
          ..strokeWidth = 5
          ..strokeCap =
              StrokeCap.round
          ..color =
              color.withValues(
            alpha:
                0.10 +
                    (safe * 0.22),
          );

    canvas.drawLine(
      center,
      needleEnd,
      needleGlowPaint,
    );

    final Paint needlePaint =
        Paint()
          ..style =
              PaintingStyle.stroke
          ..strokeWidth =
              2 + (safe * 0.8)
          ..strokeCap =
              StrokeCap.round
          ..color = color;

    canvas.drawLine(
      center,
      needleEnd,
      needlePaint,
    );

    final Paint hubGlowPaint =
        Paint()
          ..style =
              PaintingStyle.fill
          ..color =
              color.withValues(
            alpha:
                0.10 +
                    (safe * 0.22),
          );

    canvas.drawCircle(
      center,
      6,
      hubGlowPaint,
    );

    final Paint hubPaint =
        Paint()
          ..style =
              PaintingStyle.fill
          ..color = color;

    canvas.drawCircle(
      center,
      2.7,
      hubPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant
        NetworkSavingTachometerPainter
            oldDelegate,
  ) {
    return oldDelegate.strength !=
            strength ||
        oldDelegate.color != color;
  }
}