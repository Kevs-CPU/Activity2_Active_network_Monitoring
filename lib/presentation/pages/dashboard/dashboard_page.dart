import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../state/app_state.dart';
import '../../widgets/activity_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.pushNamed(
              context,
              AppRoutes.settings,
            );
          },
        ),
        title: const Text('Home Dashboard'),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor:
                        theme.colorScheme.primary,
                    child: Text(
                      appState.userName.isNotEmpty
                          ? appState.userName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, ${appState.userName}',
                          style: theme.textTheme.titleLarge
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 2),

                        Text(
                          appState.isDarkMode
                              ? 'Dark mode is on'
                              : 'Light mode is on',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              Text(
                'Activities',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              // Vertical activity list
              Expanded(
                child: StreamBuilder<List<ConnectivityResult>>(
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

                    return ListView(
                      padding: const EdgeInsets.only(
                        bottom: 16,
                      ),
                      children: [
                        ActivityCard(
                          title: 'Activity One',
                          subtitle: 'Local counter demo',
                          icon: Icons.looks_one,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.activityOne,
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        ActivityCard(
                          title: 'Activity Two',
                          subtitle: 'Local input demo',
                          icon: Icons.looks_two,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.activityTwo,
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        ActivityCard(
                          title: 'Network Monitor',
                          subtitle:
                              'Active network & handover',
                          icon: Icons.network_check,
                          showNetworkStatus: true,
                          networkStatus: networkStatus,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.networkMonitor,
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}