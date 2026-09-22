enum NetworkType {   // Activity 2: Network Monitor
                              // Domain entity for representing the current network state.
  wifi,
  cellular,
  offline,
}

enum NetworkHealth { //activity 3 extintion 
  excellent,
  fair,
  poor,
  degraded,
  unknown,
}                   //activity 3 extintion 

class NetworkStatus {
  final NetworkType type;

  const NetworkStatus({
    required this.type,
  });

  bool get isConnected => type != NetworkType.offline;

  String get displayName {
    switch (type) {
      case NetworkType.wifi:
        return 'Wi-Fi';
      case NetworkType.cellular:
        return 'Cellular';
      case NetworkType.offline:
        return 'Offline';
    }
  }
}