import 'package:flutter/material.dart';

// ============================================================
// ACTIVITY 3
// Section Header
// ============================================================

class NetworkDiagnosticSectionHeader
    extends StatelessWidget {
  final IconData icon;
  final String title;

  const NetworkDiagnosticSectionHeader({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

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
            color:
                colorScheme.onSurface,
            fontSize: 12,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ],
    );
  }
}