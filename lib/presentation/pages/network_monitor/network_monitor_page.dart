import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../../data/network/network_data_source.dart';
import '../../../data/network/network_repository_impl.dart';
import '../../../domain/entities/network_status.dart';
import '../../../domain/usecases/watch_network_status.dart';

class NetworkMonitorPage extends StatefulWidget {
  const NetworkMonitorPage({super.key});

  @override
  State<NetworkMonitorPage> createState() =>
      _NetworkMonitorPageState();
}

class _NetworkMonitorPageState extends State<NetworkMonitorPage> {
  late final WatchNetworkStatus _watchNetworkStatus;

  StreamSubscription<NetworkStatus>? _networkSubscription;

  // Activity 2: Current network status.
  NetworkStatus? _networkStatus;

  // Activity 2: Request queue state.
  int _pendingRequests = 0;
  String _requestStatus = 'No pending request';

  @override
  void initState() {
    super.initState();

    // Activity 2: Create Clean Architecture dependencies.
    final dataSource = NetworkDataSource(
      connectivity: Connectivity(),
    );

    final repository = NetworkRepositoryImpl(
      dataSource: dataSource,
    );

    _watchNetworkStatus = WatchNetworkStatus(
      repository: repository,
    );

    // Activity 2: Get the current network immediately.
    _loadCurrentNetwork();

    // Activity 2: Listen for real-time network changes.
    _networkSubscription = _watchNetworkStatus().listen(
      _handleNetworkChange,
    );
  }

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

    _resumeQueuedRequestIfConnected();
  }

  void _handleNetworkChange(NetworkStatus status) {
    if (!mounted) return;

    setState(() {
      _networkStatus = status;
    });

    // Activity 2: Automatically resume queued request
    // when Wi-Fi or Cellular connection returns.
    if (status.isConnected && _pendingRequests > 0) {
      _resumeQueuedRequestIfConnected();
    }
  }

  void _resumeQueuedRequestIfConnected() {
    if (_networkStatus == null ||
        !_networkStatus!.isConnected ||
        _pendingRequests == 0) {
      return;
    }

    setState(() {
      _requestStatus =
          'Connection restored - retrying request...';
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      if (_networkStatus?.isConnected == true) {
        setState(() {
          _pendingRequests = 0;
          _requestStatus =
              'Request completed successfully';
        });
      }
    });
  }

  // Activity 2: Simulate a long-running network request.
  Future<void> _simulateNetworkRequest() async {
    if (_pendingRequests > 0) return;

    setState(() {
      _pendingRequests = 1;
      _requestStatus = 'Request in progress...';
    });

    // Simulate a long-running request.
    for (int i = 0; i < 5; i++) {
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      // Connection was lost during the request.
      if (_networkStatus?.isConnected != true) {
        setState(() {
          _requestStatus =
              'Request queued - waiting for connection';
        });

        return;
      }
    }

    if (!mounted) return;

    setState(() {
      _pendingRequests = 0;
      _requestStatus =
          'Request completed successfully';
    });
  }

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

  Color _statusColor() {
    if (_networkStatus?.isConnected == true) {
      return Colors.green;
    }

    if (_networkStatus?.type == NetworkType.offline) {
      return Colors.red;
    }

    return Colors.grey;
  }

  String _networkName() {
    if (_networkStatus == null) {
      return 'Checking...';
    }

    return _networkStatus!.displayName;
  }

  String _connectionText() {
    if (_networkStatus == null) {
      return 'Checking connection...';
    }

    return _networkStatus!.isConnected
        ? 'Connected'
        : 'Offline';
  }

  @override
  void dispose() {
    _networkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Monitor'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // Activity 2: Current active network.
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor:
                            statusColor.withValues(alpha: 0.12),
                        child: Icon(
                          _networkIcon(),
                          color: statusColor,
                          size: 28,
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              _networkName(),
                              style: theme
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _connectionText(),
                              style: TextStyle(
                                color: statusColor,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Activity 2: Live connection indicator.
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Network Status',
                style:
                    theme.textTheme.titleMedium,
              ),

              const SizedBox(height: 12),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListTile(
                        leading:
                            const Icon(Icons.network_check),
                        title:
                            const Text('Active Network'),
                        subtitle:
                            Text(_networkName()),
                      ),

                      const Divider(),

                      ListTile(
                        leading:
                            const Icon(Icons.cloud_queue),
                        title:
                            const Text('Pending Requests'),
                        subtitle: Text(
                          '$_pendingRequests request'
                          '${_pendingRequests == 1 ? '' : 's'}',
                        ),
                      ),

                      const Divider(),

                      ListTile(
                        leading:
                            const Icon(Icons.sync),
                        title:
                            const Text('Request Status'),
                        subtitle:
                            Text(_requestStatus),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _pendingRequests == 0
                      ? _simulateNetworkRequest
                      : null,
                  icon:
                      const Icon(Icons.download),
                  label: const Text(
                    'Simulate Network Request',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}