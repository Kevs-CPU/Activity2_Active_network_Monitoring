import '../entities/network_status.dart';

// Activity 2: Network Monitor
// Repository contract for network status monitoring.

abstract class NetworkRepository {
  Future<NetworkStatus> getCurrentNetwork();

  Stream<NetworkStatus> watchNetwork();
}