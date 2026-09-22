import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../state/app_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();

    final String userName = appState.userName.isNotEmpty
        ? appState.userName
        : 'Your Name';

    final String userInitial = appState.userName.isNotEmpty
        ? appState.userName[0].toUpperCase()
        : '?';

    final String? imagePath = appState.profileImagePath;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ============================================================
              // PROFILE PHOTO
              // ============================================================

              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor:
                        theme.colorScheme.primary,
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
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),

                  // Camera button
                  Material(
                    color: theme.colorScheme.primary,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        _changeProfileImage(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(9),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ============================================================
              // ADD / CHANGE PHOTO
              // ============================================================

              TextButton.icon(
                onPressed: () {
                  _changeProfileImage(context);
                },
                icon: const Icon(
                  Icons.add_a_photo_outlined,
                ),
                label: Text(
                  imagePath == null
                      ? 'Add Profile Photo'
                      : 'Change Profile Photo',
                ),
              ),

              const SizedBox(height: 8),

              // ============================================================
              // USER NAME
              // ============================================================

              Text(
                userName,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 4),

              Text(
                'Network Monitor User',
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(height: 30),

              // ============================================================
              // PROFILE INFORMATION
              // ============================================================

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.person_outline,
                        ),
                        title: const Text('Name'),
                        subtitle: Text(userName),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(
                          Icons.palette_outlined,
                        ),
                        title: const Text('Appearance'),
                        subtitle: Text(
                          appState.isDarkMode
                              ? 'Dark mode'
                              : 'Light mode',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ============================================================
              // EDIT PROFILE
              // ============================================================

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.settings,
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profile'),
                ),
              ),

              const SizedBox(height: 12),

              // ============================================================
              // SETTINGS
              // ============================================================

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.settings,
                    );
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('Settings'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}