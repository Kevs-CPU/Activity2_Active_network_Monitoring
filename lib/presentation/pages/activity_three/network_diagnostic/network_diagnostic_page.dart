import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/network_diagnostic_provider.dart';
import 'widgets/network_diagnostic_button.dart';
import 'widgets/network_diagnostic_completed_test_card.dart';
import 'widgets/network_diagnostic_current_test_card.dart';
import 'widgets/network_diagnostic_error_card.dart';
import 'widgets/network_diagnostic_metrics_grid.dart';
import 'widgets/network_diagnostic_progress_card.dart';
import 'widgets/network_diagnostic_ready_card.dart';
import 'widgets/network_diagnostic_section_header.dart';
import 'widgets/network_diagnostic_sequence.dart';
import 'widgets/network_diagnostic_status_card.dart';
import 'widgets/network_diagnostic_waiting_health_card.dart';
import 'widgets/network_health_card.dart';


class NetworkDiagnosticPage extends StatelessWidget {
  const NetworkDiagnosticPage({
    super.key,
  });


  static const double _designWidth = 390;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // ==========================================================
      // APP BAR
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
          crossAxisAlignment:
              CrossAxisAlignment.start,
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
      // PROVIDER
      // ==========================================================

      body: Consumer<NetworkDiagnosticProvider>(
        builder: (
          context,
          provider,
          child,
        ) {
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
  //
  // All individual UI components are now separated into their
  // own widget files.
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
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          // ======================================================
          // STATUS
          // ======================================================

          NetworkDiagnosticStatusCard(
            provider: provider,
          ),

          const SizedBox(height: 8),

          // ======================================================
          // PROGRESS
          // ======================================================

          NetworkDiagnosticProgressCard(
            provider: provider,
          ),

          const SizedBox(height: 10),

          // ======================================================
          // LIVE PERFORMANCE
          // ======================================================

          const NetworkDiagnosticSectionHeader(
            icon: Icons.show_chart_rounded,
            title: 'Live Performance',
          ),

          const SizedBox(height: 6),

          NetworkDiagnosticMetricsGrid(
            provider: provider,
          ),

          const SizedBox(height: 8),

          // ======================================================
          // CURRENT / COMPLETED / READY
          // ======================================================

          if (provider.isRunning)
            NetworkDiagnosticCurrentTestCard(
              provider: provider,
            )
          else if (provider.result != null)
            NetworkDiagnosticCompletedTestCard(
              provider: provider,
            )
          else
            const NetworkDiagnosticReadyCard(),

          const SizedBox(height: 8),

          // ======================================================
          // NETWORK HEALTH
          // ======================================================

          if (provider.result != null)
            NetworkHealthCard(
              provider: provider,
            )
          else
            const NetworkDiagnosticWaitingHealthCard(),

          const SizedBox(height: 8),

          // ======================================================
          // DIAGNOSTIC SEQUENCE
          // ======================================================

          const NetworkDiagnosticSectionHeader(
            icon: Icons.route_rounded,
            title: 'Diagnostic Sequence',
          ),

          const SizedBox(height: 4),

          NetworkDiagnosticSequence(
            provider: provider,
          ),

          // ======================================================
          // ERROR
          // ======================================================

          if (provider.errorMessage != null) ...[
            const SizedBox(height: 5),

            NetworkDiagnosticErrorCard(
              message: provider.errorMessage!,
            ),
          ],

          const SizedBox(height: 8),

          // ======================================================
          // START / RUN AGAIN
          // ======================================================

          NetworkDiagnosticButton(
            provider: provider,
          ),
        ],
      ),
    );
  }
}