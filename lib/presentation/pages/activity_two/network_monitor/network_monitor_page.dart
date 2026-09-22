// ============================================================
// ACTIVITY 2
// Network Monitor Page
// ============================================================

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../../../data/network/network_data_source.dart';
import '../../../../data/network/network_repository_impl.dart';
import '../../../../domain/entities/network_status.dart';
import '../../../../domain/usecases/handle_network_request.dart';
import '../../../../domain/usecases/watch_network_status.dart';
import '../../../widgets/network_monitor/network_info_card.dart';
import '../../../widgets/network_monitor/network_request_button.dart';
import '../../../widgets/network_monitor/network_status_card.dart';

class NetworkMonitorPage extends StatefulWidget {
  const NetworkMonitorPage({super.key});

  @override
  State<NetworkMonitorPage> createState() =>
      _NetworkMonitorPageState();
}

class _NetworkMonitorPageState
    extends State<NetworkMonitorPage> {

  // ============================================================
  // ACTIVITY 2
  // Network monitoring dependencies
  // ============================================================

  late final WatchNetworkStatus _watchNetworkStatus;
  late final HandleNetworkRequest _handleNetworkRequest;

  StreamSubscription<NetworkStatus>?
      _networkSubscription;

  NetworkStatus? _networkStatus;

  int _pendingRequests = 0;

  String _requestStatus =
      'No pending request';

  // ============================================================
  // ACTIVITY 2
  // Initialize network monitoring
  // ============================================================

  @override
  void initState() {
    super.initState();

    final dataSource = NetworkDataSource(
      connectivity: Connectivity(),
    );

    final repository = NetworkRepositoryImpl(
      dataSource: dataSource,
    );

    _watchNetworkStatus = WatchNetworkStatus(
      repository: repository,
    );

    _handleNetworkRequest =
        HandleNetworkRequest();

    _loadCurrentNetwork();

    _networkSubscription =
        _watchNetworkStatus().listen(
      _handleNetworkChange,
    );
  }

  // ============================================================
  // ACTIVITY 2
  // Get current network
  // ============================================================

  Future<void> _loadCurrentNetwork() async {
    final dataSource = NetworkDataSource(
      connectivity: Connectivity(),
    );

    final repository = NetworkRepositoryImpl(
      dataSource: dataSource,
    );

    final currentNetwork =
        await repository.getCurrentNetwork();

    if (!mounted) return;

    setState(() {
      _networkStatus = currentNetwork;
    });
  }

  // ============================================================
  // ACTIVITY 2
  // Listen for network changes
  // ============================================================

  void _handleNetworkChange(
    NetworkStatus status,
  ) {
    if (!mounted) return;

    setState(() {
      _networkStatus = status;
    });

    // If the connection returns while there
    // is a pending request, retry it.
    if (status.isConnected &&
        _pendingRequests > 0) {
      _resumeQueuedRequest();
    }
  }

  // ============================================================
  // ACTIVITY 2
  // Resume queued request
  // ============================================================

  Future<void> _resumeQueuedRequest() async {
    setState(() {
      _requestStatus =
          'Connection restored - retrying request...';
    });

    final completed =
        await _handleNetworkRequest.resume(
      isConnected: () =>
          _networkStatus?.isConnected == true,
    );

    if (!mounted) return;

    if (completed) {
      setState(() {
        _pendingRequests = 0;

        _requestStatus =
            'Request completed successfully';
      });
    }
  }

  // ============================================================
  // ACTIVITY 2
  // Simulate network request
  // ============================================================

  Future<void> _simulateNetworkRequest() async {
    if (_pendingRequests > 0) return;

    setState(() {
      _pendingRequests = 1;

      _requestStatus =
          'Request in progress...';
    });

    final completed =
        await _handleNetworkRequest.execute(
      isConnected: () =>
          _networkStatus?.isConnected == true,
    );

    if (!mounted) return;

    if (completed) {
      setState(() {
        _pendingRequests = 0;

        _requestStatus =
            'Request completed successfully';
      });
    } else {
      setState(() {
        _requestStatus =
            'Request queued - waiting for connection';
      });
    }
  }

  // ============================================================
  // ACTIVITY 2
  // Network icon
  // ============================================================

  IconData _networkIcon() {
    switch (_networkStatus?.type) {
      case NetworkType.wifi:
        return Icons.wifi;

      case NetworkType.cellular:
        return Icons.signal_cellular_alt;

      case NetworkType.offline:
        return Icons.signal_wifi_off;

      case null:
        return Icons.network_check;
    }
  }

  // ============================================================
  // ACTIVITY 2
  // Network status color
  // ============================================================

  Color _statusColor() {
    if (_networkStatus?.isConnected == true) {
      return Colors.green;
    }

    if (_networkStatus?.type ==
        NetworkType.offline) {
      return Colors.red;
    }

    return Colors.grey;
  }

  // ============================================================
  // ACTIVITY 2
  // Network name
  // ============================================================

  String _networkName() {
    if (_networkStatus == null) {
      return 'Checking...';
    }

    return _networkStatus!.displayName;
  }

  // ============================================================
  // ACTIVITY 2
  // Connection text
  // ============================================================

  String _connectionText() {
    if (_networkStatus == null) {
      return 'Checking connection...';
    }

    return _networkStatus!.isConnected
        ? 'Connected'
        : 'Offline';
  }

  // ============================================================
  // ACTIVITY 2
  // Dispose network listener
  // ============================================================

  @override
  void dispose() {
    _networkSubscription?.cancel();

    super.dispose();
  }

  // ============================================================
  // ACTIVITY 2
  // Network Monitor UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Network Monitor',
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              // ==================================================
              // ACTIVITY 2
              // Current Network Status
              // ==================================================

              NetworkStatusCard(
                networkName: _networkName(),
                connectionText: _connectionText(),
                networkIcon: _networkIcon(),
                statusColor: _statusColor(),
              ),

              const SizedBox(height: 24),

              // ==================================================
              // ACTIVITY 2
              // Network Status Information
              // ==================================================

              Text(
                'Network Status',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium,
              ),

              const SizedBox(height: 12),

              NetworkInfoCard(
                networkName: _networkName(),
                pendingRequests: _pendingRequests,
                requestStatus: _requestStatus,
              ),

              const SizedBox(height: 24),

              // ==================================================
              // ACTIVITY 2
              // Network Request Button
              // ==================================================

              NetworkRequestButton(
                isPending:
                    _pendingRequests > 0,
                onPressed:
                    _simulateNetworkRequest,
              ),
            ],
          ),
        ),
      ),
    );
  }
}