import 'package:flutter/material.dart';

import '../../providers/network_diagnostic_provider.dart';
import 'high_quality_media_painter.dart';
import 'network_health_helper.dart';

class HighQualityPreview
    extends StatelessWidget {
  final NetworkDiagnosticProvider provider;

  const HighQualityPreview({
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
          gradient: LinearGradient(
            colors: [
              colorScheme.primary.withValues(
                alpha: 0.18,
              ),
              colorScheme.primary.withValues(
                alpha: 0.05,
              ),
            ],
          ),
        ),
        clipBehavior:
            Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter:
                    HighQualityMediaPainter(
                  strength: strength,
                  color:
                      colorScheme.primary,
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration:
                    BoxDecoration(
                  gradient:
                      LinearGradient(
                    begin:
                        Alignment.centerLeft,
                    end:
                        Alignment.centerRight,
                    colors: [
                      Colors.black.withValues(
                        alpha: 0.25,
                      ),
                      Colors.transparent,
                    ],
                  ),
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
                      color: Colors.white
                          .withValues(
                        alpha: 0.16,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        11,
                      ),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 26,
                      color: Colors.white,
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
                        const Text(
                          'High-quality multimedia',
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
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
                          style:
                              const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.hd_rounded,
                    color: Colors.white,
                    size: 21,
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