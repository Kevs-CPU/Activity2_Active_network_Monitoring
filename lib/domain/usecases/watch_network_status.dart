import '../entities/network_status.dart';
import '../repositories/network_repository.dart';

// Activity 2: Network Monitor
// Use case for observing real-time network status changes.

class WatchNetworkStatus {
  final NetworkRepository repository;

  WatchNetworkStatus({
    required this.repository,
  });

  Stream<NetworkStatus> call() {
    return repository.watchNetwork();
  }
}