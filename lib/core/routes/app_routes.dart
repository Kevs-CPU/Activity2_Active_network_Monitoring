import 'package:flutter/material.dart';

import '../../presentation/pages/activity_one/activity_one_page.dart';
import '../../presentation/pages/activity_two/activity_two_page.dart';
import '../../presentation/pages/dashboard/dashboard_page.dart';
import '../../presentation/pages/settings/settings_page.dart';
import '../../presentation/pages/activity_two/network_monitor/network_monitor_page.dart';

// ============================================================
// ACTIVITY 3
// Network Diagnostic Page
// ============================================================

import '../../presentation/pages/activity_three/network_diagnostic/network_diagnostic_page.dart';

// ============================================================
// PROFILE
// ============================================================

import '../../presentation/pages/profile/profile_page.dart';

class AppRoutes {
  static const String dashboard = '/';
  static const String activityOne = '/activity-one';
  static const String activityTwo = '/activity-two';

  // ============================================================
  // ACTIVITY 2
  // Network Monitor
  // ============================================================

  static const String networkMonitor =
      '/network-monitor';

  // ============================================================
  // ACTIVITY 3
  // Network Diagnostic
  // ============================================================

  static const String networkDiagnostic =
      '/network-diagnostic';

  // ============================================================
  // SETTINGS
  // ============================================================

  static const String settings = '/settings';

  // ============================================================
  // PROFILE
  // ============================================================

  static const String profile = '/profile';

  static Route<dynamic> onGenerateRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      // ========================================================
      // DASHBOARD
      // ========================================================

      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const DashboardPage(),
        );

      // ========================================================
      // ACTIVITY 1
      // ========================================================

      case activityOne:
        return MaterialPageRoute(
          builder: (_) => const ActivityOnePage(),
        );

      // ========================================================
      // ACTIVITY 2
      // ========================================================

      case activityTwo:
        return MaterialPageRoute(
          builder: (_) => const ActivityTwoPage(),
        );

      // ========================================================
      // ACTIVITY 2
      // Network Monitor
      // ========================================================

      case networkMonitor:
        return MaterialPageRoute(
          builder: (_) => const NetworkMonitorPage(),
        );

      // ========================================================
      // ACTIVITY 3
      // Network Diagnostic Dashboard
      // ========================================================

      case networkDiagnostic:
        return MaterialPageRoute(
          builder: (_) => const NetworkDiagnosticPage(),
        );

      // ========================================================
      // SETTINGS
      // ========================================================

      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsPage(),
        );

      // ========================================================
      // PROFILE
      // ========================================================

      case profile:
        return MaterialPageRoute(
          builder: (_) => const ProfilePage(),
        );

      // ========================================================
      // DEFAULT
      // ========================================================

      default:
        return MaterialPageRoute(
          builder: (_) => const DashboardPage(),
        );
    }
  }
}