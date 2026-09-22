import 'package:flutter/material.dart';

import '../../../../providers/network_diagnostic_provider.dart';

// ============================================================
// ACTIVITY 3
// Network Health Card
//
// Separated from NetworkDiagnosticPage for cleaner structure.
// ============================================================

class NetworkHealthCard extends StatelessWidget {
  final NetworkDiagnosticProvider provider;

  const NetworkHealthCard({
    super.key,
    required this.provider,
  });

  // ============================================================
  // ACTIVITY 3
  // Diagnostic Colors
  // ============================================================

  static const Color _success = Color(0xFF45D483);
  static const Color _warning = Color(0xFFFFC857);
  static const Color _orange = Color(0xFFFF9B54);
  static const Color _danger = Color(0xFFFF7272);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final String health = _healthName(
      provider.health ?? provider.result!.health,
    );

    final Color color = _healthColor(
      health,
      colorScheme,
    );

    return Container(
      // SAME SIZE AS EXISTING CARD
      height: 75,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.30),
        ),
      ),
      child: Row(
        children: [
          // ======================================================
          // Health Icon + Health Name + Health Bar
          // ======================================================

          SizedBox(
           width: 110,
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    health.toLowerCase() == 'excellent'
                        ? Icons.shield_rounded
                        : Icons.shield_outlined,
                    color: color,
                    size: 18,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NETWORK HEALTH',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colorScheme.onSurface
                              .withValues(alpha: 0.40),
                          fontSize: 6,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.7,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        health.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 5),

                      // ==================================================
                      // HEALTH PERFORMANCE BAR
                      // Uses actual live performance strength
                      // ==================================================

                      _buildHealthBar(
                        context,
                        color,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ======================================================
          // Download
          // ======================================================

          Expanded(
            child: _buildHealthMiniStat(
              context,
              _formatNumber(
                provider.downloadMbps,
                'Mbps',
                decimals: 1,
              ),
              'Download',
            ),
          ),

          _buildVerticalDivider(context),

          // ======================================================
          // Upload
          // ======================================================

          Expanded(
            child: _buildHealthMiniStat(
              context,
              _formatNumber(
                provider.uploadMbps,
                'Mbps',
                decimals: 1,
              ),
              'Upload',
            ),
          ),

          _buildVerticalDivider(context),

          // ======================================================
          // Ping
          // ======================================================

          Expanded(
            child: _buildHealthMiniStat(
              context,
              _formatNumber(
                provider.downloadPingMs,
                'ms',
                decimals: 0,
              ),
              'Ping',
            ),
          ),

          _buildVerticalDivider(context),

          // ======================================================
          // Packet Loss
          // ======================================================

          Expanded(
            child: _buildHealthMiniStat(
              context,
              _formatNumber(
                provider.packetLossPercent,
                '%',
                decimals: 0,
              ),
              'Loss',
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTIVITY 3
  // Network Health Performance Bar
  //
  // Uses actual livePerformanceStrength from provider.
  //
  // 0.0 = weak
  // 1.0 = strong
  //
  // The bar is intentionally compact so the existing
  // 75px card size remains unchanged.
  // ============================================================

  Widget _buildHealthBar(
    BuildContext context,
    Color color,
  ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final double strength = provider.livePerformanceStrength
        .clamp(0.0, 1.0)
        .toDouble();

    return SizedBox(
      height: 4,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            // ==================================================
            // Background
            // ==================================================

            Container(
              width: double.infinity,
              height: 4,
              color: colorScheme.onSurface.withValues(
                alpha: 0.08,
              ),
            ),

            // ==================================================
            // Actual Performance
            // ==================================================

            FractionallySizedBox(
              widthFactor: strength,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ACTIVITY 3
  // Health Mini Statistic
  // ============================================================

  Widget _buildHealthMiniStat(
    BuildContext context,
    String value,
    String label,
  ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colorScheme.onSurface.withValues(
              alpha: 0.40,
            ),
            fontSize: 6,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ACTIVITY 3
  // Divider
  // ============================================================

  Widget _buildVerticalDivider(
    BuildContext context,
  ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      width: 1,
      height: 24,
      margin: const EdgeInsets.symmetric(
        horizontal: 1,
      ),
      color: colorScheme.outline,
    );
  }

  // ============================================================
  // ACTIVITY 3
  // Health Name
  // ============================================================

  String _healthName(
    dynamic health,
  ) {
    final String name =
        health.toString().split('.').last;

    switch (name) {
      case 'excellent':
        return 'Excellent';

      case 'fair':
        return 'Fair';

      case 'poor':
        return 'Poor';

      case 'degraded':
        return 'Degraded';

      default:
        return 'Unknown';
    }
  }

  // ============================================================
  // ACTIVITY 3
  // Health Color
  // ============================================================

  Color _healthColor(
    String health,
    ColorScheme colorScheme,
  ) {
    switch (health.toLowerCase()) {
      case 'excellent':
        return _success;

      case 'fair':
        return _warning;

      case 'poor':
        return _orange;

      case 'degraded':
        return _danger;

      default:
        return colorScheme.onSurface.withValues(
          alpha: 0.60,
        );
    }
  }

  // ============================================================
  // ACTIVITY 3
  // Number Formatting
  // ============================================================

  String _formatNumber(
    double? value,
    String unit, {
    required int decimals,
  }) {
    if (value == null) {
      return '--';
    }

    final String formatted =
        value.toStringAsFixed(decimals);

    return unit.isEmpty
        ? formatted
        : '$formatted $unit';
  }
}