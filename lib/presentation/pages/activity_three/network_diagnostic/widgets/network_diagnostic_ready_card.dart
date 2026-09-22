import 'package:flutter/material.dart';

// ============================================================
// ACTIVITY 3
// Ready Card
// ============================================================

class NetworkDiagnosticReadyCard
    extends StatelessWidget {
  const NetworkDiagnosticReadyCard({
    super.key,
  });

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
          color: colorScheme.outline,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.speed_rounded,
            color: colorScheme.onSurface
                .withValues(
              alpha: 0.60,
            ),
            size: 19,
          ),
          const SizedBox(width: 9),
          Text(
            'Ready for diagnostic',
            style: TextStyle(
              color:
                  colorScheme.onSurface,
              fontSize: 11,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            'Press Start',
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