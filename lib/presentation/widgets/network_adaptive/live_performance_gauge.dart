import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'network_health_helper.dart';

class LivePerformanceGauge
    extends StatelessWidget {
  final double strength;
  final Color color;

  const LivePerformanceGauge({
    super.key,
    required this.strength,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LivePerformanceGaugePainter(
        strength: strength,
        color: color,
      ),
    );
  }
}

class LivePerformanceGaugePainter
    extends CustomPainter {
  final double strength;
  final Color color;

  const LivePerformanceGaugePainter({
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

    final Paint trackPaint = Paint()
      ..color =
          Colors.grey.withValues(
        alpha: 0.20,
      )
      ..style =
          PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap =
          StrokeCap.round;

    final Paint progressPaint = Paint()
      ..color = color
      ..style =
          PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap =
          StrokeCap.round;

    final Offset center = Offset(
      size.width / 2,
      size.height * 0.78,
    );

    final double radius =
        size.width * 0.38;

    final Rect arcRect =
        Rect.fromCircle(
      center: center,
      radius: radius,
    );

    const double startAngle = 3.55;
    const double totalAngle = 3.05;

    canvas.drawArc(
      arcRect,
      startAngle,
      totalAngle,
      false,
      trackPaint,
    );

    canvas.drawArc(
      arcRect,
      startAngle,
      totalAngle * safe,
      false,
      progressPaint,
    );

    final double needleAngle =
        startAngle +
            (totalAngle * safe);

    final Offset needleEnd =
        Offset(
      center.dx +
          radius *
              0.72 *
              math.cos(
                needleAngle,
              ),
      center.dy +
          radius *
              0.72 *
              math.sin(
                needleAngle,
              ),
    );

    final Paint needlePaint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap =
          StrokeCap.round;

    canvas.drawLine(
      center,
      needleEnd,
      needlePaint,
    );

    final Paint centerPaint = Paint()
      ..color = color
      ..style =
          PaintingStyle.fill;

    canvas.drawCircle(
      center,
      2,
      centerPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant
        LivePerformanceGaugePainter
            oldDelegate,
  ) {
    return oldDelegate.strength !=
            strength ||
        oldDelegate.color != color;
  }
}