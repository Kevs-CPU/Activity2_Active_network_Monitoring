import 'package:flutter/material.dart';

import '../../../domain/entities/network_status.dart';

double safeStrength(double? value) {
  if (value == null || value.isNaN || value.isInfinite) {
    return 0.0;
  }

  return value.clamp(0.0, 1.0).toDouble();
}

String formatMbps(double? value) {
  if (value == null ||
      value.isNaN ||
      value.isInfinite ||
      value <= 0) {
    return '— Mbps';
  }

  return '${value.toStringAsFixed(1)} Mbps';
}

String healthLabel(NetworkHealth? health) {
  switch (health) {
    case NetworkHealth.excellent:
      return 'EXCELLENT';

    case NetworkHealth.fair:
      return 'FAIR';

    case NetworkHealth.poor:
      return 'POOR';

    case NetworkHealth.degraded:
      return 'DEGRADED';

    case NetworkHealth.unknown:
    case null:
      return 'MEASURING';
  }
}

Color healthColor(
  NetworkHealth? health,
  ColorScheme colorScheme,
) {
  switch (health) {
    case NetworkHealth.excellent:
      return Colors.greenAccent;

    case NetworkHealth.fair:
      return Colors.orange;

    case NetworkHealth.poor:
      return Colors.redAccent;

    case NetworkHealth.degraded:
      return Colors.red;

    case NetworkHealth.unknown:
    case null:
      return colorScheme.onSurface.withValues(
        alpha: 0.45,
      );
  }
}

Color performanceColor(double strength) {
  final double safe = safeStrength(strength);

  if (safe >= 0.80) {
    return Colors.greenAccent;
  }

  if (safe >= 0.65) {
    return Colors.green;
  }

  if (safe >= 0.45) {
    return Colors.lightGreen;
  }

  if (safe >= 0.25) {
    return Colors.orange;
  }

  return Colors.red;
}