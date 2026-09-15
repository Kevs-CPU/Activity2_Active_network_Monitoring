import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';
import '../../widgets/activity_card.dart';

class ActivityTwoPage extends StatefulWidget {
  const ActivityTwoPage({super.key});

  @override
  State<ActivityTwoPage> createState() => _ActivityTwoPageState();
}

class _ActivityTwoPageState extends State<ActivityTwoPage> {
  final TextEditingController _controller = TextEditingController();
  String _preview = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Two'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Type something',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() => _preview = value);
                },
              ),

              const SizedBox(height: 24),

              Text(
                _preview.isEmpty
                    ? 'Preview will appear here'
                    : _preview,
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 24),

              StreamBuilder<List<ConnectivityResult>>(
                stream: Connectivity().onConnectivityChanged,
                builder: (context, snapshot) {
                  final connectivity = snapshot.data ??
                      const <ConnectivityResult>[];

                  String networkStatus;

                  if (connectivity
                      .contains(ConnectivityResult.wifi)) {
                    networkStatus = 'Wi-Fi';
                  } else if (connectivity
                      .contains(ConnectivityResult.mobile)) {
                    networkStatus = 'Cellular';
                  } else {
                    networkStatus = 'Offline';
                  }

                  return ActivityCard(
                    title: 'Network Monitor',
                    subtitle: 'Active network & handover',
                    icon: Icons.network_check,
                    showNetworkStatus: true,
                    networkStatus: networkStatus,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.networkMonitor,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}