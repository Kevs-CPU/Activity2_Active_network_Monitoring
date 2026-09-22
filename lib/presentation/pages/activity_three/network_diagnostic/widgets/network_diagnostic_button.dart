import 'package:flutter/material.dart';

import '../../../../providers/network_diagnostic_provider.dart';

// ============================================================
// ACTIVITY 3
// Diagnostic Button
// ============================================================

class NetworkDiagnosticButton
    extends StatelessWidget {
  final NetworkDiagnosticProvider provider;

  const NetworkDiagnosticButton({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final bool running =
        provider.isRunning;

    final Color buttonBackground =
        running
            ? colorScheme.primary
                .withValues(
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
                child:
                    CircularProgressIndicator(
                  strokeWidth: 2,
                  color:
                      buttonForeground,
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
            fontWeight:
                FontWeight.w700,
          ),
        ),
        style:
            ElevatedButton.styleFrom(
          backgroundColor:
              buttonBackground,
          foregroundColor:
              buttonForeground,
          disabledForegroundColor:
              colorScheme.onPrimary,
          disabledBackgroundColor:
              colorScheme.primary
                  .withValues(
            alpha: 0.35,
          ),
          elevation: 0,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}