import 'dart:math' as math;

import 'package:flutter/material.dart';

// ============================================================
// ACTIVITY 3
// Live Rainbow Performance Wave
// ============================================================

class LiveRainbowPerformanceWave
    extends StatefulWidget {
  final double strength;

  const LiveRainbowPerformanceWave({
    super.key,
    required this.strength,
  });

  @override
  State<LiveRainbowPerformanceWave> createState() =>
      _LiveRainbowPerformanceWaveState();
}

class _LiveRainbowPerformanceWaveState
    extends State<LiveRainbowPerformanceWave>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1500,
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
          painter:
              LiveRainbowPerformanceWavePainter(
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
// Live Rainbow Performance Wave Painter
// ============================================================

class LiveRainbowPerformanceWavePainter
    extends CustomPainter {
  final double progress;
  final double strength;

  const LiveRainbowPerformanceWavePainter({
    required this.progress,
    required this.strength,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    if (size.width <= 0 ||
        size.height <= 0) {
      return;
    }

    final double normalizedStrength =
        strength.clamp(0.0, 1.0).toDouble();

    final double amplitudeFactor =
        0.20 +
            (normalizedStrength * 0.80);

    final double amplitude =
        size.height *
            0.30 *
            amplitudeFactor;

    final double centerY =
        size.height * 0.52;

    final double opacity =
        0.45 +
            (normalizedStrength * 0.55);

    final double animationSpeed =
        0.65 +
            (normalizedStrength * 0.55);

    final List<Color> colors = [
      const Color(0xFFFF4D6D),
      const Color(0xFFFF9F1C),
      const Color(0xFFFFD166),
      const Color(0xFF45D483),
      const Color(0xFF2EC4B6),
      const Color(0xFF4D96FF),
      const Color(0xFF9B5DE5),
    ];

    final List<double> stops = [
      0.0,
      0.16,
      0.32,
      0.50,
      0.67,
      0.84,
      1.0,
    ];

    final Rect waveRect =
        Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    );

    final Shader rainbowShader =
        LinearGradient(
      colors: colors,
      stops: stops,
    ).createShader(waveRect);

    final Path wavePath = Path();

    const int pointCount = 36;

    for (int i = 0;
        i < pointCount;
        i++) {
      final double t =
          i / (pointCount - 1);

      final double x =
          size.width * t;

      final double phase =
          progress *
              math.pi *
              2 *
              animationSpeed;

      final double primaryWave =
          math.sin(
            (t * math.pi * 2.4) +
                phase,
          );

      final double secondaryWave =
          math.sin(
            (t * math.pi * 5.0) -
                (phase * 0.65),
          ) *
          0.20;

      final double y =
          centerY +
              ((primaryWave +
                      secondaryWave) *
                  amplitude);

      if (i == 0) {
        wavePath.moveTo(
          x,
          y,
        );
      } else {
        wavePath.lineTo(
          x,
          y,
        );
      }
    }

    final Paint glowPaint =
        Paint()
          ..style =
              PaintingStyle.stroke
          ..strokeWidth = 8.0
          ..strokeCap =
              StrokeCap.round
          ..strokeJoin =
              StrokeJoin.round
          ..shader = rainbowShader
          ..maskFilter =
              const MaskFilter.blur(
            BlurStyle.normal,
            3.5,
          )
          ..color = Colors.white.withValues(
            alpha:
                0.10 * opacity,
          );

    canvas.drawPath(
      wavePath,
      glowPaint,
    );

    final Paint wavePaint =
        Paint()
          ..style =
              PaintingStyle.stroke
          ..strokeWidth = 3.6
          ..strokeCap =
              StrokeCap.round
          ..strokeJoin =
              StrokeJoin.round
          ..shader = rainbowShader;

    canvas.drawPath(
      wavePath,
      wavePaint,
    );

    final double dotT =
        ((progress *
                animationSpeed) %
            1.0);

    final double dotPhase =
        progress *
            math.pi *
            2 *
            animationSpeed;

    final double dotPrimary =
        math.sin(
          (dotT * math.pi * 2.4) +
              dotPhase,
        );

    final double dotSecondary =
        math.sin(
              (dotT * math.pi * 5.0) -
                  (dotPhase * 0.65),
            ) *
            0.20;

    final double dotY =
        centerY +
            ((dotPrimary +
                    dotSecondary) *
                amplitude);

    final double dotX =
        size.width * dotT;

    final Offset dotPosition =
        Offset(
      dotX,
      dotY,
    );

    final Paint dotGlow =
        Paint()
          ..style =
              PaintingStyle.fill
          ..color = Colors.white.withValues(
            alpha:
                0.18 * opacity,
          )
          ..maskFilter =
              const MaskFilter.blur(
            BlurStyle.normal,
            4,
          );

    canvas.drawCircle(
      dotPosition,
      6,
      dotGlow,
    );

    final Paint dot =
        Paint()
          ..style =
              PaintingStyle.fill
          ..shader = rainbowShader;

    canvas.drawCircle(
      dotPosition,
      3.0,
      dot,
    );
  }

  @override
  bool shouldRepaint(
    covariant
        LiveRainbowPerformanceWavePainter
            oldDelegate,
  ) {
    return oldDelegate.progress !=
            progress ||
        oldDelegate.strength !=
            strength;
  }
}