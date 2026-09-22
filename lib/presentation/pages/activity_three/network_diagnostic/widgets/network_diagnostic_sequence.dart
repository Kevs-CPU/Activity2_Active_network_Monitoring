import 'package:flutter/material.dart';

import '../../../../providers/network_diagnostic_provider.dart';
import 'network_diagnostic_helpers.dart';

// ============================================================
// ACTIVITY 3
// Diagnostic Sequence
// ============================================================

class NetworkDiagnosticSequence
    extends StatelessWidget {
  final NetworkDiagnosticProvider provider;

  const NetworkDiagnosticSequence({
    super.key,
    required this.provider,
  });

  static const Color _success =
      Color(0xFF45D483);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final int activeStep =
        NetworkDiagnosticHelpers
            .getActiveStep(provider);

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
                        .withValues(
                        alpha: 0.30,
                      );

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 25,
                          height: 25,
                          decoration:
                              BoxDecoration(
                            color: completed
                                ? _success
                                    .withValues(
                                    alpha: 0.12,
                                  )
                                : Colors
                                    .transparent,
                            shape:
                                BoxShape.circle,
                            border:
                                Border.all(
                              color: color,
                              width: 1.4,
                            ),
                          ),
                          child: Center(
                            child: completed
                                ? const Icon(
                                    Icons
                                        .check_rounded,
                                    color:
                                        _success,
                                    size: 14,
                                  )
                                : Text(
                                    '${index + 1}',
                                    style:
                                        TextStyle(
                                      color: active
                                          ? colorScheme
                                              .primary
                                          : colorScheme
                                              .onSurface
                                              .withValues(
                                              alpha:
                                                  0.40,
                                            ),
                                      fontSize: 8,
                                      fontWeight:
                                          FontWeight
                                              .w700,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          steps[index],
                          maxLines: 1,
                          overflow:
                              TextOverflow
                                  .ellipsis,
                          style: TextStyle(
                            color: active ||
                                    completed
                                ? colorScheme
                                    .onSurface
                                : colorScheme
                                    .onSurface
                                    .withValues(
                                    alpha:
                                        0.40,
                                  ),
                            fontSize: 7,
                            fontWeight: active
                                ? FontWeight
                                    .w600
                                : FontWeight
                                    .w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index <
                      steps.length - 1)
                    Container(
                      width: 9,
                      height: 1,
                      color: completed
                          ? _success
                              .withValues(
                              alpha: 0.45,
                            )
                          : colorScheme
                              .outline,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}