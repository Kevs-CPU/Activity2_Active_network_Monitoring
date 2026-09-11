import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  final String? networkStatus;
  final bool showNetworkStatus;

  final VoidCallback onTap;

  const ActivityCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.networkStatus,
    this.showNetworkStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isConnected =
        networkStatus == 'Wi-Fi' ||
        networkStatus == 'Cellular';

    final statusColor =
        isConnected ? Colors.green : Colors.red;

    return Card(
      elevation: 2,
      shadowColor: Colors.black26,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium,
                    ),

                    if (showNetworkStatus) ...[
                      const SizedBox(height: 8),

                      Text(
                        isConnected
                            ? 'Connected • $networkStatus'
                            : 'Offline',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right,
                size: 30,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ],
          ),
        ),
      ),
    );
  }
}