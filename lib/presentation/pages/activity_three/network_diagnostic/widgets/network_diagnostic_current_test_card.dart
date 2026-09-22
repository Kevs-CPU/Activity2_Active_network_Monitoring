import 'package:flutter/material.dart';

import '../../../../providers/network_diagnostic_provider.dart';
import 'network_diagnostic_helpers.dart';

// ============================================================
// ACTIVITY 3
// Current Test Card
// ============================================================

class NetworkDiagnosticCurrentTestCard
    extends StatelessWidget {
  final NetworkDiagnosticProvider provider;

  const NetworkDiagnosticCurrentTestCard({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final String stage =
        provider.currentStage;

    final String lower =
        stage.toLowerCase();

    final bool download =
        lower.contains('download');

    final bool upload =
        lower.contains('upload');

    final bool packet =
        lower.contains('packet') ||
            lower.contains('loss');

    final bool idle =
        lower.contains('idle') ||
            lower.contains('ping');

    final IconData icon = download
        ? Icons.download_rounded
        : upload
            ? Icons.upload_rounded
            : packet
                ? Icons.shield_outlined
                : Icons.speed_rounded;

    final String title = download
        ? 'Download Bandwidth'
        : upload
            ? 'Upload Bandwidth'
            : packet
                ? 'Packet Loss'
                : idle
                    ? 'Idle Ping'
                    : 'Network Test';

    final String value = download
        ? NetworkDiagnosticHelpers
            .formatNumber(
          provider.downloadMbps,
          'Mbps',
          decimals: 2,
        )
        : upload
            ? NetworkDiagnosticHelpers
                .formatNumber(
              provider.uploadMbps,
              'Mbps',
              decimals: 2,
            )
            : packet
                ? NetworkDiagnosticHelpers
                    .formatNumber(
                  provider.packetLossPercent,
                  '%',
                  decimals: 1,
                )
                : NetworkDiagnosticHelpers
                    .formatNumber(
                  provider.idlePingMs,
                  'ms',
                  decimals: 1,
                );

    final String secondary = download
        ? NetworkDiagnosticHelpers
            .formatNumber(
          provider.downloadPingMs,
          'ms',
          decimals: 1,
        )
        : upload
            ? NetworkDiagnosticHelpers
                .formatNumber(
              provider.uploadPingMs,
              'ms',
              decimals: 1,
            )
            : '';

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
          color: colorScheme.primary
              .withValues(
            alpha: 0.45,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: colorScheme.primary
                  .withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: colorScheme.primary,
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
                  'CURRENT TEST',
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
                  title,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
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
          if (download || upload) ...[
            _buildSmallValue(
              context,
              value,
              'Speed',
            ),
            Container(
              height: 27,
              width: 1,
              margin:
                  const EdgeInsets.symmetric(
                horizontal: 9,
              ),
              color: colorScheme.outline,
            ),
            _buildSmallValue(
              context,
              secondary,
              'Ping',
            ),
          ] else
            _buildSmallValue(
              context,
              value,
              packet
                  ? 'Loss'
                  : 'Latency',
            ),
        ],
      ),
    );
  }

  Widget _buildSmallValue(
    BuildContext context,
    String value,
    String label,
  ) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      crossAxisAlignment:
          CrossAxisAlignment.end,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow:
              TextOverflow.ellipsis,
          style: TextStyle(
            color:
                colorScheme.onSurface,
            fontSize: 11,
            fontWeight:
                FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: colorScheme.onSurface
                .withValues(
              alpha: 0.40,
            ),
            fontSize: 7,
          ),
        ),
      ],
    );
  }
}