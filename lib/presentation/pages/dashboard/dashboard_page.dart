import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../state/app_state.dart';
import '../../widgets/activity_card.dart';
import '../../widgets/network_adaptive/adaptive_network_content.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Future<void> _changeProfileImage(
    BuildContext context,
  ) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) {
      return;
    }

    if (!context.mounted) {
      return;
    }

    context.read<AppState>().updateProfileImage(
          image.path,
        );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);

    final String? imagePath = appState.profileImagePath;

    final String userInitial = appState.userName.isNotEmpty
        ? appState.userName[0].toUpperCase()
        : '?';

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
              // ============================================================
              // Welcome Section
              // ============================================================

              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _changeProfileImage(context);
                    },
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: theme.colorScheme.primary,
                      backgroundImage: imagePath != null
                          ? FileImage(
                              File(imagePath),
                            )
                          : null,
                      child: imagePath == null
                          ? Text(
                              userInitial,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            )
                          : null,
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
                          style: theme
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight:
                                    FontWeight.w600,
                              ),
                          overflow:
                              TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 2),

                        Text(
                          appState.isDarkMode
                              ? 'Dark mode is on'
                              : 'Light mode is on',
                          style:
                              theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ============================================================
              // Activities Title
              // ============================================================

              Text(
                'Activities',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              // ============================================================
              // ADAPTIVE NETWORK CONTENT
              // Activity 3 network health controls
              // ============================================================

              const AdaptiveNetworkContent(),

              const SizedBox(height: 16),

              // ============================================================
              // Activities List
              // ============================================================

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(
                    bottom: 16,
                  ),
                  children: [
                    // ======================================================
                    // ACTIVITY 1
                    // ======================================================

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

                    // ======================================================
                    // ACTIVITY 2
                    // Network Monitor
                    // ======================================================

                    ActivityCard(
                      title: 'Activity Two',
                      subtitle:
                          'Local input & network monitor',
                      icon: Icons.looks_two,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.activityTwo,
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // ======================================================
                    // ACTIVITY 3
                    // Network Diagnostic Dashboard
                    // ======================================================

                    ActivityCard(
                      title: 'Activity Three',
                      subtitle:
                          'Network Diagnostic Dashboard',
                      icon: Icons.speed,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.networkDiagnostic,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}