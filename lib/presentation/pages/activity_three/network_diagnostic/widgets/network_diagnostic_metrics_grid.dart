import 'package:flutter/material.dart';

import '../../../../providers/network_diagnostic_provider.dart';
import 'network_diagnostic_helpers.dart';
import 'network_diagnostic_metric_tile.dart';

// ============================================================
// ACTIVITY 3
// Network Diagnostic Metrics Grid
// ============================================================

class NetworkDiagnosticMetricsGrid
    extends StatelessWidget {
  final NetworkDiagnosticProvider provider;

  const NetworkDiagnosticMetricsGrid({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    return SizedBox(
      height: 174,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child:
                      NetworkDiagnosticMetricTile(
                    icon:
                        Icons.access_time_rounded,
                    iconColor:
                        colorScheme.onSurface
                            .withValues(
                      alpha: 0.60,
                    ),
                    title: 'Idle Ping',
                    value:
                        NetworkDiagnosticHelpers
                            .formatNumber(
                      provider.idlePingMs,
                      'ms',
                      decimals: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child:
                      NetworkDiagnosticMetricTile(
                    icon:
                        Icons.download_rounded,
                    iconColor:
                        colorScheme.primary,
                    title: 'Download',
                    value:
                        NetworkDiagnosticHelpers
                            .formatNumber(
                      provider.downloadMbps,
                      'Mbps',
                      decimals: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 7),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child:
                      NetworkDiagnosticMetricTile(
                    icon:
                        Icons.network_ping_rounded,
                    iconColor:
                        colorScheme.onSurface
                            .withValues(
                      alpha: 0.60,
                    ),
                    title: 'Download Ping',
                    value:
                        NetworkDiagnosticHelpers
                            .formatNumber(
                      provider.downloadPingMs,
                      'ms',
                      decimals: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child:
                      NetworkDiagnosticMetricTile(
                    icon:
                        Icons.upload_rounded,
                    iconColor:
                        colorScheme.primary,
                    title: 'Upload',
                    value:
                        NetworkDiagnosticHelpers
                            .formatNumber(
                      provider.uploadMbps,
                      'Mbps',
                      decimals: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 7),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child:
                      NetworkDiagnosticMetricTile(
                    icon:
                        Icons.network_ping_rounded,
                    iconColor:
                        colorScheme.onSurface
                            .withValues(
                      alpha: 0.60,
                    ),
                    title: 'Upload Ping',
                    value:
                        NetworkDiagnosticHelpers
                            .formatNumber(
                      provider.uploadPingMs,
                      'ms',
                      decimals: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child:
                      NetworkDiagnosticMetricTile(
                    icon:
                        Icons.shield_outlined,
                    iconColor:
                        const Color(0xFF45D483),
                    title: 'Packet Loss',
                    value:
                        NetworkDiagnosticHelpers
                            .formatNumber(
                      provider.packetLossPercent,
                      '%',
                      decimals: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}