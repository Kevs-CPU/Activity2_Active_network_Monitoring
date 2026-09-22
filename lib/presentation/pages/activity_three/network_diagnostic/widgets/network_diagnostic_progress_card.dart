import 'package:flutter/material.dart';

import '../../../../providers/network_diagnostic_provider.dart';
import 'live_rainbow_performance_wave.dart';
import 'network_diagnostic_helpers.dart';
import 'rainbow_arch_progress.dart';

// ============================================================
// ACTIVITY 3
// Network Diagnostic Progress Card
// ============================================================

class NetworkDiagnosticProgressCard
    extends StatelessWidget {
  final NetworkDiagnosticProvider provider;

  const NetworkDiagnosticProgressCard({
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

    final double percentage =
        (provider.progress * 100)
            .clamp(0.0, 100.0)
            .toDouble();

    final bool completed =
        provider.result != null;

    return Container(
      height: 82,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: completed
              ? _success.withValues(
                  alpha: 0.25,
                )
              : colorScheme.outline,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.fromLTRB(
              12,
              11,
              12,
              0,
            ),
            child: Row(
              children: [
                Icon(
                  completed
                      ? Icons
                          .check_circle_outline_rounded
                      : Icons.speed_rounded,
                  color: completed
                      ? _success
                      : colorScheme.primary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Diagnostic Progress',
                    style: TextStyle(
                      color:
                          colorScheme.onSurface,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color:
                        colorScheme.onSurface,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
              ),
              child: SizedBox(
                width: double.infinity,
                child: completed
                    ? LiveRainbowPerformanceWave(
                        strength: provider
                            .livePerformanceStrength,
                      )
                    : RainbowArchProgress(
                        progress: provider
                            .progress
                            .clamp(
                              0.0,
                              1.0,
                            )
                            .toDouble(),
                      ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.fromLTRB(
              12,
              0,
              12,
              7,
            ),
            child: Align(
              alignment:
                  Alignment.centerLeft,
              child: Text(
                NetworkDiagnosticHelpers
                    .progressDescription(
                  provider,
                ),
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: TextStyle(
                  color: colorScheme
                      .onSurface
                      .withValues(
                    alpha: 0.60,
                  ),
                  fontSize: 8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}