import 'package:flutter/material.dart';

import '../../providers/network_diagnostic_provider.dart';
import 'network_health_helper.dart';
import 'optimized_media_painter.dart';

class OptimizedPreview
    extends StatelessWidget {
  final NetworkDiagnosticProvider provider;

  const OptimizedPreview({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    final double strength =
        safeStrength(
      provider.livePerformanceStrength,
    );

    return AspectRatio(
      aspectRatio: 16 / 6.5,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(10),
          color: colorScheme.secondary
              .withValues(alpha: 0.08),
        ),
        clipBehavior:
            Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter:
                    OptimizedMediaPainter(
                  strength: strength,
                  color:
                      colorScheme.secondary,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.all(10),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration:
                        BoxDecoration(
                      color: colorScheme
                          .secondary
                          .withValues(
                        alpha: 0.16,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        11,
                      ),
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: 25,
                      color:
                          colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Optimized multimedia',
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colorScheme
                                .onSurface,
                            fontSize: 11,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          formatMbps(
                            provider.downloadMbps,
                          ),
                          style: TextStyle(
                            color: colorScheme
                                .onSurface
                                .withValues(
                              alpha: 0.55,
                            ),
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.tune_rounded,
                    size: 20,
                    color:
                        colorScheme.secondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}