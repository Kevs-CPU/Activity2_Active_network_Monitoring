import 'package:flutter/material.dart';

class CheckingPreview
    extends StatelessWidget {
  const CheckingPreview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return SizedBox(
      height: 54,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(10),
          color: colorScheme.outline
              .withValues(alpha: 0.06),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              margin:
                  const EdgeInsets.only(
                left: 10,
              ),
              decoration:
                  BoxDecoration(
                borderRadius:
                    BorderRadius.circular(9),
                color: colorScheme.outline
                    .withValues(
                  alpha: 0.10,
                ),
              ),
              child: Icon(
                Icons.sync_rounded,
                size: 20,
                color: colorScheme.onSurface
                    .withValues(
                  alpha: 0.50,
                ),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                'Measuring network performance...',
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: TextStyle(
                  color: colorScheme.onSurface
                      .withValues(
                    alpha: 0.60,
                  ),
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}