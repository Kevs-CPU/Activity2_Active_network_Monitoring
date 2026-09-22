import 'package:flutter/material.dart';

class RainbowArchProgress extends StatelessWidget {
  final double progress;

  const RainbowArchProgress({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: RainbowArchProgressPainter(
          progress: progress,
        ),
      ),
    );
  }
}

class RainbowArchProgressPainter extends CustomPainter {
  final double progress;

  const RainbowArchProgressPainter({
    required this.progress,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    if (size.width <= 0 || size.height <= 0) {
      return;
    }

    final double safeProgress =
        progress.clamp(0.0, 1.0).toDouble();

    // ============================================================
    // Horizontal Inset
    // ============================================================

    const double horizontalInset = 14.0;

    const double left = horizontalInset;

    final double right =
        size.width - horizontalInset;

    final double arcWidth =
        right - left;

    if (arcWidth <= 0) {
      return;
    }

    // ============================================================
    // Flat Arch Geometry
    // ============================================================

    final double baseline =
        size.height * 0.72;

    final double archHeight =
        size.height * 0.25;

    final double centerY =
        baseline - archHeight;

    final Path archPath = Path();

    archPath.moveTo(
      left,
      baseline,
    );

    archPath.quadraticBezierTo(
      left + arcWidth * 0.25,
      centerY,
      left + arcWidth * 0.50,
      centerY,
    );

    archPath.quadraticBezierTo(
      left + arcWidth * 0.75,
      centerY,
      right,
      baseline,
    );

    // ============================================================
    // Background Arc
    // ============================================================

    final Paint backgroundPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5.0
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFF303438);

    canvas.drawPath(
      archPath,
      backgroundPaint,
    );

    if (safeProgress <= 0) {
      return;
    }

    // ============================================================
    // Rainbow Gradient
    // ============================================================

    final Shader rainbowShader =
        const LinearGradient(
      colors: [
        Color(0xFFFF4D6D),
        Color(0xFFFF9F43),
        Color(0xFFFFD93D),
        Color(0xFF45D483),
        Color(0xFF35C7C9),
        Color(0xFF4D9DE0),
        Color(0xFF9B6DFF),
      ],
      stops: [
        0.0,
        0.16,
        0.32,
        0.50,
        0.67,
        0.84,
        1.0,
      ],
    ).createShader(
      Rect.fromLTWH(
        left,
        0,
        arcWidth,
        size.height,
      ),
    );

    final Paint progressPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5.0
          ..strokeCap = StrokeCap.round
          ..shader = rainbowShader;

    // ============================================================
    // Progress Endpoint
    // ============================================================

    final double progressEndX =
        left + arcWidth * safeProgress;

    // ============================================================
    // Clip Rainbow Progress
    // ============================================================

    canvas.save();

    canvas.clipRect(
      Rect.fromLTRB(
        left,
        0,
        progressEndX,
        size.height,
      ),
    );

    canvas.drawPath(
      archPath,
      progressPaint,
    );

    canvas.restore();

    // ============================================================
    // Active Progress Glow
    // ============================================================

    if (safeProgress > 0.0) {
      final Paint glowPaint =
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 8.0
            ..strokeCap = StrokeCap.round
            ..color = Colors.white.withValues(
              alpha: 0.08,
            );

      canvas.save();

      canvas.clipRect(
        Rect.fromLTRB(
          left,
          0,
          progressEndX,
          size.height,
        ),
      );

      canvas.drawPath(
        archPath,
        glowPaint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(
    covariant RainbowArchProgressPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress;
  }
}