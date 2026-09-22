import 'package:flutter/material.dart';

// ============================================================
// ACTIVITY 3
// Waiting Health Card
// ============================================================

class NetworkDiagnosticWaitingHealthCard
    extends StatelessWidget {
  const NetworkDiagnosticWaitingHealthCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    return Container(
      height: 57,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.shield_outlined,
            color: colorScheme.onSurface
                .withValues(
              alpha: 0.40,
            ),
            size: 19,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'Network Health',
              style: TextStyle(
                color:
                    colorScheme.onSurface,
                fontSize: 11,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
          Text(
            'Waiting for results',
            style: TextStyle(
              color: colorScheme.onSurface
                  .withValues(
                alpha: 0.40,
              ),
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}