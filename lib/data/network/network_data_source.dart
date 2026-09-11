import 'package:connectivity_plus/connectivity_plus.dart';

// Activity 2: Network Monitor
// Data source for reading real-time network connectivity changes.

class NetworkDataSource {
  final Connectivity connectivity;

  NetworkDataSource({
    required this.connectivity,
  });

  Future<List<ConnectivityResult>> getCurrentConnectivity() {
    return connectivity.checkConnectivity();
  }

  Stream<List<ConnectivityResult>> watchConnectivity() {
    return connectivity.onConnectivityChanged;
  }
}