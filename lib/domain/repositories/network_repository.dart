import '../entities/network_diagnostic_result.dart';
import '../entities/network_diagnostic_update.dart';
import '../entities/network_status.dart';

// ============================================================
// ACTIVITY 2: Network Monitor
//
// Repository contract for:
// - Network connectivity monitoring
// - Network performance diagnostics
// - Live performance monitoring
// ============================================================

abstract class NetworkRepository {
  // ------------------------------------------------------------
  // Connectivity monitoring
  // ------------------------------------------------------------

  Future<NetworkStatus> getCurrentNetwork();

  Stream<NetworkStatus> watchNetwork();

  // ------------------------------------------------------------
  // ACTIVITY 3: Network Diagnostic
  // ------------------------------------------------------------

  Future<double> measureIdlePing();

  Future<double> measureDownloadSpeed();

  Future<double> measureDownloadPing();

  Future<double> measureUploadSpeed();

  Future<double> measureUploadPing();

  Future<double> measurePacketLoss();

  Future<NetworkDiagnosticResult> runNetworkDiagnostic();

  // ------------------------------------------------------------
  // ACTIVITY 3: Realtime Diagnostic Updates
  // ------------------------------------------------------------

  Stream<NetworkDiagnosticUpdate> watchDiagnosticUpdates();

  // ------------------------------------------------------------
  // ACTIVITY 3: Live Performance Monitoring
  //
  // Starts and stops continuous network measurements after
  // the initial diagnostic has completed.
  // ------------------------------------------------------------

  Future<void> startLiveMonitoring();

  Future<void> stopLiveMonitoring();

  bool get isLiveMonitoring;
}