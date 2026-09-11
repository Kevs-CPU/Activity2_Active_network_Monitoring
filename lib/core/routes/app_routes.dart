import 'package:flutter/material.dart'; 
import '../../presentation/pages/activity_one/activity_one_page.dart'; 
import '../../presentation/pages/activity_two/activity_two_page.dart'; 
import '../../presentation/pages/dashboard/dashboard_page.dart'; 
import '../../presentation/pages/settings/settings_page.dart'; 
import '../../presentation/pages/network_monitor/network_monitor_page.dart'; 
 
class AppRoutes { 
  static const String dashboard = '/'; 
  static const String activityOne = '/activity-one'; 
  static const String activityTwo = '/activity-two'; 
  static const String networkMonitor = '/network-monitor';
  static const String settings = '/settings'; 
 
  static Route<dynamic> onGenerateRoute(RouteSettings settings) { 
    switch (settings.name) { 
      case dashboard: 
        return MaterialPageRoute(builder: (_) => const DashboardPage()); 
      case activityOne: 
        return MaterialPageRoute(builder: (_) => const ActivityOnePage()); 
      case activityTwo: 
        return MaterialPageRoute(builder: (_) => const ActivityTwoPage()); 
      case AppRoutes.settings: 
        return MaterialPageRoute(builder: (_) => const SettingsPage()); 
        case networkMonitor:
        return MaterialPageRoute(builder: (_) => const NetworkMonitorPage());
      default: 
        return MaterialPageRoute(builder: (_) => const DashboardPage()); 
    } 
  } 
}