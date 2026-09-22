import 'network_status.dart';

// Activity 3 Network Diagnostic
//
// Domain entity containing the complete result of a network diagnostic.

class NetworkDiagnosticResult {
  final double idlePingMs;

  final double downloadMbps;
  final double downloadPingMs;

  final double uploadMbps;
  final double uploadPingMs;

  final double packetLossPercent;

  final NetworkHealth health;

  const NetworkDiagnosticResult({
    required this.idlePingMs,
    required this.downloadMbps,
    required this.downloadPingMs,
    required this.uploadMbps,
    required this.uploadPingMs,
    required this.packetLossPercent,///activity extintion 
    required this.health,
  });
}

///activity extintion 
//////activity extintion 
//////activity extintion 
///