import 'package:flutter/material.dart';

import '../../../../providers/network_diagnostic_provider.dart';
import 'live_performance_wave.dart';

// ============================================================
// ACTIVITY 3
// Completed / Live Monitoring Card
// ============================================================

class NetworkDiagnosticCompletedTestCard
    extends StatelessWidget {
  final NetworkDiagnosticProvider provider;

  const NetworkDiagnosticCompletedTestCard({
    super.key,
    required this.provider,
  });

  static const Color _success =
      Color(0xFF45D483);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    return Container(
      height: 63,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color: provider.isMonitoring
              ? _success.withValues(
                  alpha: 0.55,
                )
              : colorScheme.primary,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: provider.isMonitoring
                  ? _success.withValues(
                      alpha: 0.10,
                    )
                  : colorScheme.primary
                      .withValues(
                      alpha: 0.10,
                    ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              provider.isMonitoring
                  ? Icons
                      .monitor_heart_rounded
                  : Icons.speed_rounded,
              color: provider.isMonitoring
                  ? _success
                  : colorScheme.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  provider.isMonitoring
                      ? 'LIVE MONITORING'
                      : 'CURRENT TEST',
                  style: TextStyle(
                    color: colorScheme
                        .onSurface
                        .withValues(
                      alpha: 0.40,
                    ),
                    fontSize: 7,
                    fontWeight:
                        FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  provider.isMonitoring
                      ? 'Monitoring Performance'
                      : 'Completed',
                  style: TextStyle(
                    color:
                        colorScheme.onSurface,
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (provider.isMonitoring)
            SizedBox(
              width: 82,
              height: 38,
              child: LivePerformanceWave(
                strength: provider
                    .livePerformanceStrength,
              ),
            )
          else
            Text(
              'Diagnostic finished',
              style: TextStyle(
                color: colorScheme
                    .onSurface
                    .withValues(
                  alpha: 0.60,
                ),
                fontSize: 9,
              ),
            ),
        ],
      ),
    );
  }
}