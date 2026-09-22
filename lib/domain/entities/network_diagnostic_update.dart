import 'network_status.dart';

class NetworkDiagnosticUpdate {
  final String stage;
  final double progress;

  final double? idlePingMs;
  final double? downloadMbps;
  final double? downloadPingMs;
  final double? uploadMbps;
  final double? uploadPingMs;
  final double? packetLossPercent;

  final NetworkHealth? health;

  // ============================================================
  // ACTIVITY 3
  // Live Performance Strength
  //
  // 0.0 = very weak performance
  // 1.0 = very strong performance
  // ============================================================

  final double livePerformanceStrength;

  const NetworkDiagnosticUpdate({
    required this.stage,
    required this.progress,

    this.idlePingMs,
    this.downloadMbps,
    this.downloadPingMs,
    this.uploadMbps,
    this.uploadPingMs,
    this.packetLossPercent,

    this.health,

    // Default keeps existing update objects compatible.
    this.livePerformanceStrength = 0.5,
  });
}