import 'package:flutter/material.dart';

import '../../../../providers/network_diagnostic_provider.dart';
import 'network_diagnostic_helpers.dart';

// ============================================================
// ACTIVITY 3
// Network Diagnostic Status Card
// ============================================================

class NetworkDiagnosticStatusCard
    extends StatelessWidget {
  final NetworkDiagnosticProvider provider;

  const NetworkDiagnosticStatusCard({
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

    final bool running =
        provider.isRunning;

    final bool monitoring =
        provider.isMonitoring;

    final bool completed =
        provider.result != null;

    final Color color = running
        ? colorScheme.primary
        : monitoring
            ? _success
            : completed
                ? _success
                : colorScheme.onSurface
                    .withValues(
                    alpha: 0.60,
                  );

    final String title = running
        ? 'Diagnostic Running'
        : monitoring
            ? 'Live Monitoring Active'
            : completed
                ? 'Diagnostic Complete'
                : 'Diagnostic Ready';

    final String description = running
        ? NetworkDiagnosticHelpers
            .statusDescription(provider)
        : monitoring
            ? 'Continuously measuring network performance'
            : completed
                ? 'Latest network test is available'
                : 'Ready to measure connection performance';

    return Container(
      height: 72,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: monitoring
              ? _success.withValues(
                  alpha: 0.30,
                )
              : completed
                  ? _success.withValues(
                      alpha: 0.30,
                    )
                  : colorScheme.outline,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color:
                  color.withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              running
                  ? Icons.sync_rounded
                  : monitoring
                      ? Icons
                          .monitor_heart_rounded
                      : completed
                          ? Icons
                              .check_circle_outline_rounded
                          : Icons
                              .network_check_rounded,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
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
          ),
          if (running)
            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primary
                    .withValues(
                  alpha: 0.10,
                ),
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: Text(
                NetworkDiagnosticHelpers
                    .shortStage(
                  provider.currentStage,
                ),
                style: TextStyle(
                  color:
                      colorScheme.primary,
                  fontSize: 8,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),
          if (monitoring)
            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: _success.withValues(
                  alpha: 0.12,
                ),
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(
                  color: _success,
                  fontSize: 8,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),
          if (completed && !monitoring)
            const Icon(
              Icons.check_circle_rounded,
              color: _success,
              size: 21,
            ),
        ],
      ),
    );
  }
}