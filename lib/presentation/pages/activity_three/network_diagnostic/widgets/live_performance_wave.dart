import 'dart:math' as math;

import 'package:flutter/material.dart';

// ============================================================
// ACTIVITY 3
// Live Performance Wave
// ============================================================

class LivePerformanceWave extends StatefulWidget {
  final double strength;

  const LivePerformanceWave({
    super.key,
    required this.strength,
  });

  @override
  State<LivePerformanceWave> createState() =>
      _LivePerformanceWaveState();
}

class _LivePerformanceWaveState
    extends State<LivePerformanceWave>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1400,
      ),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: LivePerformanceWavePainter(
            progress: _controller.value,
            strength: widget.strength,
          ),
        );
      },
    );
  }
}

// ============================================================
// ACTIVITY 3
// Live Performance Wave Painter
// ============================================================

class LivePerformanceWavePainter extends CustomPainter {
  final double progress;
  final double strength;

  const LivePerformanceWavePainter({
    required this.progress,
    required this.strength,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final double normalizedStrength =
        strength.clamp(0.0, 1.0).toDouble();

    final double amplitudeFactor =
        0.20 +
            (normalizedStrength * 0.80);

    final double amplitude =
        size.height *
            0.30 *
            amplitudeFactor;

    final double opacity =
        0.45 +
            (normalizedStrength * 0.55);

    final Color waveColor =
        const Color(0xFF45D483).withValues(
      alpha: opacity,
    );

    final Color glowColor =
        const Color(0xFF45D483).withValues(
      alpha:
          0.08 +
              (normalizedStrength * 0.14),
    );

    final Paint glowPaint = Paint()
      ..color = glowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final Paint wavePaint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Path wave = Path();

    final double centerY =
        size.height / 2;

    const int points = 18;

    final double animationSpeed =
        0.65 +
            (normalizedStrength * 0.55);

    for (int i = 0; i <= points; i++) {
      final double x =
          size.width * i / points;

      final double phase =
          (i / points) *
              math.pi *
              4;

      final double animatedPhase =
          phase -
              progress *
                  math.pi *
                  2 *
                  animationSpeed;

      final double y =
          centerY +
              math.sin(animatedPhase) *
                  amplitude;

      if (i == 0) {
        wave.moveTo(x, y);
      } else {
        wave.lineTo(x, y);
      }
    }

    canvas.drawPath(
      wave,
      glowPaint,
    );

    canvas.drawPath(
      wave,
      wavePaint,
    );

    final double endPhase =
        math.pi * 4 -
            progress *
                math.pi *
                2 *
                animationSpeed;

    final double endY =
        centerY +
            math.sin(endPhase) *
                amplitude;

    final Paint dotPaint = Paint()
      ..color = waveColor;

    canvas.drawCircle(
      Offset(
        size.width,
        endY,
      ),
      2.5,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant LivePerformanceWavePainter
        oldDelegate,
  ) {
    return oldDelegate.progress != progress ||
        oldDelegate.strength != strength;
  }
}