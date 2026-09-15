import 'package:flutter/material.dart';

class NetworkInfoCard extends StatelessWidget {
  final String networkName;
  final int pendingRequests;
  final String requestStatus;

  const NetworkInfoCard({
    super.key,
    required this.networkName,
    required this.pendingRequests,
    required this.requestStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.network_check),
              title: const Text('Active Network'),
              subtitle: Text(networkName),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.cloud_queue),
              title: const Text('Pending Requests'),
              subtitle: Text(
                '$pendingRequests request'
                '${pendingRequests == 1 ? '' : 's'}',
              ),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.sync),
              title: const Text('Request Status'),
              subtitle: Text(requestStatus),
            ),
          ],
        ),
      ),
    );
  }
}