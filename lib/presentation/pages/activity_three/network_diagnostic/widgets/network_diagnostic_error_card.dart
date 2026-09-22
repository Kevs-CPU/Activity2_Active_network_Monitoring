import 'package:flutter/material.dart';

// ============================================================
// ACTIVITY 3
// Error Card
// ============================================================

class NetworkDiagnosticErrorCard
    extends StatelessWidget {
  final String message;

  const NetworkDiagnosticErrorCard({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

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
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
      ),
      decoration: BoxDecoration(
        color: errorBackground,
        borderRadius:
            BorderRadius.circular(8),
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
              overflow:
                  TextOverflow.ellipsis,
              style: TextStyle(
                color:
                    colorScheme.error,
                fontSize: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}