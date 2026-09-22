import 'package:flutter/material.dart';

import '../../providers/network_diagnostic_provider.dart';
import 'network_health_helper.dart';

class LightweightPreview
    extends StatelessWidget {
  final NetworkDiagnosticProvider provider;

  const LightweightPreview({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 16 / 6.5,
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(10),
          color: colorScheme.outline
              .withValues(alpha: 0.06),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration:
                  BoxDecoration(
                borderRadius:
                    BorderRadius.circular(11),
                color: colorScheme.outline
                    .withValues(
                  alpha: 0.12,
                ),
              ),
              child: Icon(
                Icons
                    .image_not_supported_outlined,
                size: 22,
                color: colorScheme.onSurface
                    .withValues(
                  alpha: 0.45,
                ),
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
                    'Lightweight multimedia',
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color:
                          colorScheme.onSurface,
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
                      color: colorScheme.onSurface
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
              Icons.data_saver_on_rounded,
              size: 20,
              color: colorScheme.onSurface
                  .withValues(alpha: 0.45),
            ),
          ],
        ),
      ),
    );
  }
}