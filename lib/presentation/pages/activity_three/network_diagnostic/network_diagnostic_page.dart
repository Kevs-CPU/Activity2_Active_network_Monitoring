import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/network_diagnostic_provider.dart';
import 'widgets/network_health_card.dart';
import 'widgets/rainbow_arch_progress.dart';

// ============================================================
// ACTIVITY 3
// Network Diagnostic Dashboard
// ============================================================

class NetworkDiagnosticPage extends StatelessWidget {
  const NetworkDiagnosticPage({super.key});

  // ============================================================
  // ACTIVITY 3
  // Design Width
  // ============================================================

  static const double _designWidth = 390;

  // ============================================================
  // ACTIVITY 3
  // Diagnostic Colors
  // ============================================================

  static const Color _success = Color(0xFF45D483);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // ==========================================================
      // ACTIVITY 3
      // App Bar
      // ==========================================================

      appBar: AppBar(
        backgroundColor:
            theme.appBarTheme.backgroundColor ??
                theme.scaffoldBackgroundColor,
        foregroundColor:
            theme.appBarTheme.foregroundColor ??
                colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        toolbarHeight: 58,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Network Diagnostic',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Real-time connection performance',
              style: TextStyle(
                color: colorScheme.onSurface.withValues(
                  alpha: 0.60,
                ),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),

      // ==========================================================
      // ACTIVITY 3
      // Provider
      // ==========================================================

      body: Consumer<NetworkDiagnosticProvider>(
        builder: (context, provider, child) {
          return SafeArea(
            top: false,
            bottom: true,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: _designWidth,
                ),
                child: _buildDashboard(
                  context,
                  provider,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // ACTIVITY 3
  // Main Dashboard
  // ============================================================

  Widget _buildDashboard(
    BuildContext context,
    NetworkDiagnosticProvider provider,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        12,
        4,
        12,
        8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildStatusCard(
            context,
            provider,
          ),

          const SizedBox(height: 8),

          _buildProgressCard(
            context,
            provider,
          ),

          const SizedBox(height: 10),

          _buildSectionHeader(
            context,
            Icons.show_chart_rounded,
            'Live Performance',
          ),

          const SizedBox(height: 6),

          _buildMetricsGrid(
            context,
            provider,
          ),

          const SizedBox(height: 8),

          provider.isRunning
              ? _buildCurrentTestCard(
                  context,
                  provider,
                )
              : provider.result != null
                  ? _buildCompletedTestCard(
                      context,
                      provider,
                    )
                  : _buildReadyCard(context),

          const SizedBox(height: 8),

          provider.result != null
              ? _buildHealthCard(
                  context,
                  provider,
                )
              : _buildWaitingHealthCard(context),

          const SizedBox(height: 8),

          _buildSectionHeader(
            context,
            Icons.route_rounded,
            'Diagnostic Sequence',
          ),

          const SizedBox(height: 4),

          _buildDiagnosticSequence(
            context,
            provider,
          ),

          if (provider.errorMessage != null) ...[
            const SizedBox(height: 5),
            _buildErrorCard(
              context,
              provider.errorMessage!,
            ),
          ],

          const SizedBox(height: 8),

          _buildDiagnosticButton(
            context,
            provider,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTIVITY 3
  // Status Card
  // ============================================================

  Widget _buildStatusCard(
    BuildContext context,
    NetworkDiagnosticProvider provider,
  ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final bool running = provider.isRunning;
    final bool monitoring = provider.isMonitoring;
    final bool completed = provider.result != null;

    final Color color = running
        ? colorScheme.primary
        : monitoring
            ? _success
            : completed
                ? _success
                : colorScheme.onSurface.withValues(alpha: 0.60);

    final String title = running
        ? 'Diagnostic Running'
        : monitoring
            ? 'Live Monitoring Active'
            : completed
                ? 'Diagnostic Complete'
                : 'Diagnostic Ready';

    final String description = running
        ? _statusDescription(provider)
        : monitoring
            ? 'Continuously measuring network performance'
            : completed
                ? 'Latest network test is available'
                : 'Ready to measure connection performance';

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: monitoring
              ? _success.withValues(alpha: 0.30)
              : completed
                  ? _success.withValues(alpha: 0.30)
                  : colorScheme.outline,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              running
                  ? Icons.sync_rounded
                  : monitoring
                      ? Icons.monitor_heart_rounded
                      : completed
                          ? Icons.check_circle_outline_rounded
                          : Icons.network_check_rounded,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(
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
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(
                  alpha: 0.10,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _shortStage(provider.currentStage),
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          if (monitoring)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: _success.withValues(
                  alpha: 0.12,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(
                  color: _success,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
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

  // ============================================================
  // ACTIVITY 3
  // Status Description
  // ============================================================

  String _statusDescription(
    NetworkDiagnosticProvider provider,
  ) {
    final String stage =
        provider.currentStage.toLowerCase();

    if (stage.contains('download')) {
      return 'Measuring download bandwidth and ping';
    }

    if (stage.contains('upload')) {
      return 'Measuring upload bandwidth and ping';
    }

    if (stage.contains('packet')) {
      return 'Checking packet loss';
    }

    if (stage.contains('idle')) {
      return 'Measuring baseline latency';
    }

    return 'Running network performance test';
  }

  // ============================================================
  // ACTIVITY 3
  // Progress Card
  //
  // UPDATED:
  //
  // Before completion:
  //     RainbowArchProgress
  //
  // After completion:
  //     Animated rainbow live-performance wave
  //
  // Card size remains exactly 82px.
  // ============================================================

  Widget _buildProgressCard(
    BuildContext context,
    NetworkDiagnosticProvider provider,
  ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

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
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: completed
              ? _success.withValues(alpha: 0.25)
              : colorScheme.outline,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              12,
              11,
              12,
              0,
            ),
            child: Row(
              children: [
                Icon(
                  completed
                      ? Icons.check_circle_outline_rounded
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
                      color: colorScheme.onSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
              ),
              child: SizedBox(
                width: double.infinity,
                child: completed
                    ? _LiveRainbowPerformanceWave(
                        strength:
                            provider.livePerformanceStrength,
                      )
                    : RainbowArchProgress(
                        progress: provider.progress
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
            padding: const EdgeInsets.fromLTRB(
              12,
              0,
              12,
              7,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _progressDescription(provider),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(
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

  // ============================================================
  // ACTIVITY 3
  // Live Metrics
  // ============================================================

  Widget _buildMetricsGrid(
    BuildContext context,
    NetworkDiagnosticProvider provider,
  ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return SizedBox(
      height: 174,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    context,
                    Icons.access_time_rounded,
                    colorScheme.onSurface.withValues(
                      alpha: 0.60,
                    ),
                    'Idle Ping',
                    _formatNumber(
                      provider.idlePingMs,
                      'ms',
                      decimals: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricTile(
                    context,
                    Icons.download_rounded,
                    colorScheme.primary,
                    'Download',
                    _formatNumber(
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
                  child: _buildMetricTile(
                    context,
                    Icons.network_ping_rounded,
                    colorScheme.onSurface.withValues(
                      alpha: 0.60,
                    ),
                    'Download Ping',
                    _formatNumber(
                      provider.downloadPingMs,
                      'ms',
                      decimals: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricTile(
                    context,
                    Icons.upload_rounded,
                    colorScheme.primary,
                    'Upload',
                    _formatNumber(
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
                  child: _buildMetricTile(
                    context,
                    Icons.network_ping_rounded,
                    colorScheme.onSurface.withValues(
                      alpha: 0.60,
                    ),
                    'Upload Ping',
                    _formatNumber(
                      provider.uploadPingMs,
                      'ms',
                      decimals: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricTile(
                    context,
                    Icons.shield_outlined,
                    _success,
                    'Packet Loss',
                    _formatNumber(
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

  // ============================================================
  // ACTIVITY 3
  // Metric Tile
  // ============================================================

  Widget _buildMetricTile(
    BuildContext context,
    IconData icon,
    Color iconColor,
    String title,
    String value,
  ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: colorScheme.outline,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 31,
            height: 31,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(
                      alpha: 0.60,
                    ),
                    fontSize: 8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTIVITY 3
  // Current Test Card
  // ============================================================

  Widget _buildCurrentTestCard(
    BuildContext context,
    NetworkDiagnosticProvider provider,
  ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final String stage = provider.currentStage;
    final String lower = stage.toLowerCase();

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
        ? _formatNumber(
            provider.downloadMbps,
            'Mbps',
            decimals: 2,
          )
        : upload
            ? _formatNumber(
                provider.uploadMbps,
                'Mbps',
                decimals: 2,
              )
            : packet
                ? _formatNumber(
                    provider.packetLossPercent,
                    '%',
                    decimals: 1,
                  )
                : _formatNumber(
                    provider.idlePingMs,
                    'ms',
                    decimals: 1,
                  );

    final String secondary = download
        ? _formatNumber(
            provider.downloadPingMs,
            'ms',
            decimals: 1,
          )
        : upload
            ? _formatNumber(
                provider.uploadPingMs,
                'ms',
                decimals: 1,
              )
            : '';

    return Container(
      height: 63,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withValues(
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
              color: colorScheme.primary.withValues(
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
                    color: colorScheme.onSurface
                        .withValues(alpha: 0.40),
                    fontSize: 7,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
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
              margin: const EdgeInsets.symmetric(
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
              packet ? 'Loss' : 'Latency',
            ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTIVITY 3
  // Completed / Live Monitoring Card
  // ============================================================

  Widget _buildCompletedTestCard(
    BuildContext context,
    NetworkDiagnosticProvider provider,
  ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      height: 63,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: provider.isMonitoring
              ? _success.withValues(alpha: 0.55)
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
                  ? _success.withValues(alpha: 0.10)
                  : colorScheme.primary.withValues(
                      alpha: 0.10,
                    ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              provider.isMonitoring
                  ? Icons.monitor_heart_rounded
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
                    color: colorScheme.onSurface
                        .withValues(alpha: 0.40),
                    fontSize: 7,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  provider.isMonitoring
                      ? 'Monitoring Performance'
                      : 'Completed',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // ========================================================
          // Existing green live-performance wave.
          // This is preserved.
          // ========================================================

          if (provider.isMonitoring)
            SizedBox(
              width: 82,
              height: 38,
              child: _LivePerformanceWave(
                strength:
                    provider.livePerformanceStrength,
              ),
            )
          else
            Text(
              'Diagnostic finished',
              style: TextStyle(
                color:
                    colorScheme.onSurface.withValues(
                  alpha: 0.60,
                ),
                fontSize: 9,
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTIVITY 3
  // Ready Card
  // ============================================================

  Widget _buildReadyCard(
    BuildContext context,
  ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      height: 63,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.speed_rounded,
            color: colorScheme.onSurface.withValues(
              alpha: 0.60,
            ),
            size: 19,
          ),
          const SizedBox(width: 9),
          Text(
            'Ready for diagnostic',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            'Press Start',
            style: TextStyle(
              color: colorScheme.onSurface.withValues(
                alpha: 0.40,
              ),
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTIVITY 3
  // Small Value
  // ============================================================

  Widget _buildSmallValue(
    BuildContext context,
    String value,
    String label,
  ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: colorScheme.onSurface.withValues(
              alpha: 0.40,
            ),
            fontSize: 7,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ACTIVITY 3
  // Waiting Health Card
  // ============================================================

  Widget _buildWaitingHealthCard(
    BuildContext context,
  ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      height: 57,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.shield_outlined,
            color: colorScheme.onSurface.withValues(
              alpha: 0.40,
            ),
            size: 19,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'Network Health',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            'Waiting for results',
            style: TextStyle(
              color: colorScheme.onSurface.withValues(
                alpha: 0.40,
              ),
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTIVITY 3
  // Network Health
  //
  // Separated into NetworkHealthCard for cleaner structure.
  // ============================================================

  Widget _buildHealthCard(
    BuildContext context,
    NetworkDiagnosticProvider provider,
  ) {
    return NetworkHealthCard(
      provider: provider,
    );
  }

  // ============================================================
  // ACTIVITY 3
  // Diagnostic Sequence
  // ============================================================

  Widget _buildDiagnosticSequence(
    BuildContext context,
    NetworkDiagnosticProvider provider,
  ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final int activeStep =
        _getActiveStep(provider);

    const List<String> steps = [
      'Ping',
      'Download',
      'Upload',
      'Loss',
      'Health',
    ];

    final bool completedAll =
        provider.result != null;

    return SizedBox(
      height: 48,
      child: Row(
        children: List.generate(
          steps.length,
          (index) {
            final bool completed =
                completedAll ||
                    index < activeStep;

            final bool active =
                !completedAll &&
                    index == activeStep;

            final Color color = completed
                ? _success
                : active
                    ? colorScheme.primary
                    : colorScheme.onSurface
                        .withValues(alpha: 0.30);

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: completed
                                ? _success.withValues(
                                    alpha: 0.12,
                                  )
                                : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: color,
                              width: 1.4,
                            ),
                          ),
                          child: Center(
                            child: completed
                                ? const Icon(
                                    Icons.check_rounded,
                                    color: _success,
                                    size: 14,
                                  )
                                : Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: active
                                          ? colorScheme.primary
                                          : colorScheme.onSurface
                                              .withValues(
                                              alpha: 0.40,
                                            ),
                                      fontSize: 8,
                                      fontWeight:
                                          FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          steps[index],
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: TextStyle(
                            color: active || completed
                                ? colorScheme.onSurface
                                : colorScheme.onSurface
                                    .withValues(
                                    alpha: 0.40,
                                  ),
                            fontSize: 7,
                            fontWeight: active
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index < steps.length - 1)
                    Container(
                      width: 9,
                      height: 1,
                      color: completed
                          ? _success.withValues(
                              alpha: 0.45,
                            )
                          : colorScheme.outline,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // ACTIVITY 3
  // Diagnostic Button
  // ============================================================

  Widget _buildDiagnosticButton(
    BuildContext context,
    NetworkDiagnosticProvider provider,
  ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final bool running = provider.isRunning;

    final Color buttonBackground = running
        ? colorScheme.primary.withValues(
            alpha: 0.35,
          )
        : colorScheme.primary;

    final Color buttonForeground =
        colorScheme.onPrimary;

    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: running
            ? null
            : provider.runDiagnostic,
        icon: running
            ? SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: buttonForeground,
                ),
              )
            : const Icon(
                Icons.play_arrow_rounded,
                size: 19,
              ),
        label: Text(
          running
              ? 'Running Diagnostic...'
              : provider.result != null
                  ? 'Run Diagnostic Again'
                  : 'Start Diagnostic',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBackground,
          foregroundColor: buttonForeground,
          disabledForegroundColor:
              colorScheme.onPrimary,
          disabledBackgroundColor:
              colorScheme.primary.withValues(
            alpha: 0.35,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ACTIVITY 3
  // Section Header
  // ============================================================

  Widget _buildSectionHeader(
    BuildContext context,
    IconData icon,
    String title,
  ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          color: colorScheme.onSurface,
          size: 17,
        ),
        const SizedBox(width: 7),
        Text(
          title,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ACTIVITY 3
  // Error Card
  // ============================================================

  Widget _buildErrorCard(
    BuildContext context,
    String message,
  ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final Color errorBackground =
        colorScheme.error.withValues(
      alpha: 0.10,
    );

    final Color errorBorder =
        colorScheme.error.withValues(
      alpha: 0.35,
    );

    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
      ),
      decoration: BoxDecoration(
        color: errorBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: errorBorder,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: colorScheme.error,
            size: 15,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colorScheme.error,
                fontSize: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTIVITY 3
  // Active Diagnostic Step
  // ============================================================

  int _getActiveStep(
    NetworkDiagnosticProvider provider,
  ) {
    if (provider.result != null) {
      return 5;
    }

    final String stage =
        provider.currentStage.toLowerCase();

    if (stage.contains('packet') ||
        stage.contains('loss')) {
      return 3;
    }

    if (stage.contains('upload')) {
      return 2;
    }

    if (stage.contains('download')) {
      return 1;
    }

    if (stage.contains('idle') ||
        stage.contains('ping')) {
      return 0;
    }

    return 0;
  }

  // ============================================================
  // ACTIVITY 3
  // Progress Description
  // ============================================================

  String _progressDescription(
    NetworkDiagnosticProvider provider,
  ) {
    if (provider.isMonitoring) {
      return 'Live performance monitoring • Progress complete';
    }

    if (provider.result != null) {
      return 'Diagnostic completed successfully';
    }

    final String stage =
        provider.currentStage.toLowerCase();

    if (stage.contains('download')) {
      return 'Measuring download bandwidth + ping';
    }

    if (stage.contains('upload')) {
      return 'Measuring upload bandwidth + ping';
    }

    if (stage.contains('packet') ||
        stage.contains('loss')) {
      return 'Checking packet loss';
    }

    if (stage.contains('idle') ||
        stage.contains('ping')) {
      return 'Measuring baseline latency';
    }

    if (provider.isRunning) {
      return 'Running network performance test';
    }

    return 'Ready to test connection performance';
  }

  // ============================================================
  // ACTIVITY 3
  // Short Stage
  // ============================================================

  String _shortStage(
    String stage,
  ) {
    final String value =
        stage.toLowerCase();

    if (value.contains('download')) {
      return 'DOWNLOAD';
    }

    if (value.contains('upload')) {
      return 'UPLOAD';
    }

    if (value.contains('packet') ||
        value.contains('loss')) {
      return 'PACKET LOSS';
    }

    if (value.contains('idle') ||
        value.contains('ping')) {
      return 'IDLE PING';
    }

    return 'TESTING';
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

// ============================================================
// ACTIVITY 3
// Existing Live Performance Wave
//
// This is the original green waveform used by the
// Completed / Live Monitoring card.
//
// It remains unchanged.
// ============================================================

class _LivePerformanceWave extends StatefulWidget {
  final double strength;

  const _LivePerformanceWave({
    required this.strength,
  });

  @override
  State<_LivePerformanceWave> createState() =>
      _LivePerformanceWaveState();
}

class _LivePerformanceWaveState
    extends State<_LivePerformanceWave>
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
          painter: _LivePerformanceWavePainter(
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
// Existing Live Performance Wave Painter
// ============================================================

class _LivePerformanceWavePainter
    extends CustomPainter {
  final double progress;
  final double strength;

  const _LivePerformanceWavePainter({
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
    covariant _LivePerformanceWavePainter
        oldDelegate,
  ) {
    return oldDelegate.progress != progress ||
        oldDelegate.strength != strength;
  }
}

// ============================================================
// ACTIVITY 3
// NEW: Live Rainbow Performance Wave
//
// Used ONLY inside the Diagnostic Progress card after the
// diagnostic reaches 100%.
//
// The existing RainbowArchProgress is still used before
// completion.
//
// No random values.
// Uses provider.livePerformanceStrength.
// ============================================================

class _LiveRainbowPerformanceWave
    extends StatefulWidget {
  final double strength;

  const _LiveRainbowPerformanceWave({
    required this.strength,
  });

  @override
  State<_LiveRainbowPerformanceWave> createState() =>
      _LiveRainbowPerformanceWaveState();
}

class _LiveRainbowPerformanceWaveState
    extends State<_LiveRainbowPerformanceWave>
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
              _LiveRainbowPerformanceWavePainter(
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

class _LiveRainbowPerformanceWavePainter
    extends CustomPainter {
  final double progress;
  final double strength;

  const _LiveRainbowPerformanceWavePainter({
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

    // ----------------------------------------------------------
    // ACTUAL NETWORK PERFORMANCE STRENGTH
    //
    // 0.0 = weak
    // 1.0 = strong
    // ----------------------------------------------------------

    final double normalizedStrength =
        strength.clamp(0.0, 1.0).toDouble();

    // ----------------------------------------------------------
    // Strength controls the wave amplitude.
    // ----------------------------------------------------------

    final double amplitudeFactor =
        0.20 +
            (normalizedStrength * 0.80);

    final double amplitude =
        size.height *
            0.30 *
            amplitudeFactor;

    final double centerY =
        size.height * 0.52;

    // ----------------------------------------------------------
    // Strength controls visual intensity.
    // ----------------------------------------------------------

    final double opacity =
        0.45 +
            (normalizedStrength * 0.55);

    // ----------------------------------------------------------
    // Strength also controls animation energy.
    // ----------------------------------------------------------

    final double animationSpeed =
        0.65 +
            (normalizedStrength * 0.55);

    // ----------------------------------------------------------
    // Rainbow colors.
    // ----------------------------------------------------------

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

    // ----------------------------------------------------------
    // Create animated zigzag/sine wave.
    // ----------------------------------------------------------

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

    // ----------------------------------------------------------
    // Rainbow glow.
    // ----------------------------------------------------------

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

    // ----------------------------------------------------------
    // Main rainbow wave.
    // ----------------------------------------------------------

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

    // ----------------------------------------------------------
    // Moving live-performance dot.
    // ----------------------------------------------------------

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

    // ----------------------------------------------------------
    // Dot glow.
    // ----------------------------------------------------------

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

    // ----------------------------------------------------------
    // Dot itself.
    // ----------------------------------------------------------

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
        _LiveRainbowPerformanceWavePainter
            oldDelegate,
  ) {
    return oldDelegate.progress !=
            progress ||
        oldDelegate.strength !=
            strength;
  }
}