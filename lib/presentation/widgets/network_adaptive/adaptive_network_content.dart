import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/network_status.dart';
import '../../providers/network_diagnostic_provider.dart';
import 'adaptive_network_card.dart';
import 'checking_preview.dart';
import 'high_quality_preview.dart';
import 'lightweight_preview.dart';
import 'network_saving_card.dart';
import 'optimized_preview.dart';

class AdaptiveNetworkContent extends StatelessWidget {
  const AdaptiveNetworkContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkDiagnosticProvider>(
      builder: (context, provider, _) {
        switch (provider.health) {
          case NetworkHealth.excellent:
            return _buildExcellent(
              provider,
            );

          case NetworkHealth.fair:
            return _buildFair(
              provider,
            );

          case NetworkHealth.poor:
            return _buildPoor(
              provider,
            );

          case NetworkHealth.degraded:
            return NetworkSavingCard(
              provider: provider,
            );

          case NetworkHealth.unknown:
          case null:
            return _buildChecking(
              provider,
            );
        }
      },
    );
  }

  Widget _buildExcellent(
    NetworkDiagnosticProvider provider,
  ) {
    return AdaptiveNetworkCard(
      provider: provider,
      icon: Icons.high_quality_rounded,
      title: 'High Performance Mode',
      description: 'High-quality multimedia is enabled.',
      statusLabel: 'FULL QUALITY',
      statusIcon: Icons.check_circle_rounded,
      statusColor: Colors.green,
      content: HighQualityPreview(
        provider: provider,
      ),
    );
  }

  Widget _buildFair(
    NetworkDiagnosticProvider provider,
  ) {
    return AdaptiveNetworkCard(
      provider: provider,
      icon: Icons.speed_rounded,
      title: 'Optimized Mode',
      description: 'Multimedia quality is adjusted.',
      statusLabel: 'OPTIMIZED',
      statusIcon: Icons.tune_rounded,
      statusColor: Colors.orange,
      content: OptimizedPreview(
        provider: provider,
      ),
    );
  }

  Widget _buildPoor(
    NetworkDiagnosticProvider provider,
  ) {
    return AdaptiveNetworkCard(
      provider: provider,
      icon: Icons.data_saver_on_rounded,
      title: 'Lightweight Mode',
      description: 'Lightweight multimedia is active.',
      statusLabel: 'LIGHTWEIGHT',
      statusIcon: Icons.data_saver_on_rounded,
      statusColor: Colors.orange,
      content: LightweightPreview(
        provider: provider,
      ),
    );
  }

  Widget _buildChecking(
    NetworkDiagnosticProvider provider,
  ) {
    return AdaptiveNetworkCard(
      provider: provider,
      icon: Icons.network_check_rounded,
      title: 'Checking Network',
      description: 'Waiting for network health result.',
      statusLabel: 'MEASURING',
      statusIcon: Icons.sync_rounded,
      statusColor: Colors.blueGrey,
      content: const CheckingPreview(),
    );
  }
}