import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/entities/network_status.dart';
import '../../domain/repositories/network_repository.dart';
import 'network_data_source.dart';

// Activity 2: Network Monitor
// Implementation of the network repository.

class NetworkRepositoryImpl implements NetworkRepository {
  final NetworkDataSource dataSource;

  NetworkRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<NetworkStatus> getCurrentNetwork() async {
    final connectivity = await dataSource.getCurrentConnectivity();
    return _mapConnectivity(connectivity);
  }

  @override
  Stream<NetworkStatus> watchNetwork() {
    return dataSource.watchConnectivity().map(_mapConnectivity);
  }

  NetworkStatus _mapConnectivity(List<ConnectivityResult> connectivity) {
    if (connectivity.contains(ConnectivityResult.wifi)) {
      return const NetworkStatus(
        type: NetworkType.wifi,
      );
    }

    if (connectivity.contains(ConnectivityResult.mobile)) {
      return const NetworkStatus(
        type: NetworkType.cellular,
      );
    }

    return const NetworkStatus(
      type: NetworkType.offline,
    );
  }
}