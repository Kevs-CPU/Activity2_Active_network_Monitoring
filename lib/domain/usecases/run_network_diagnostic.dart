import '../entities/network_diagnostic_result.dart';
import '../entities/network_diagnostic_update.dart';
import '../repositories/network_repository.dart';

// ============================================================
// ACTIVITY 3
// Network Diagnostic Use Case
//
// Responsible for starting the complete network diagnostic
// and exposing realtime diagnostic updates.
//
// Clean Architecture:
// Presentation
//     ↓
// Use Case
//     ↓
// Repository
//     ↓
// Data Source
// ============================================================

class RunNetworkDiagnostic {
  final NetworkRepository repository;

  RunNetworkDiagnostic({
    required this.repository,
  });

  // ==========================================================
  // ACTIVITY 3
  // Run the complete network diagnostic.
  // ==========================================================

  Future<NetworkDiagnosticResult> call() {
    return repository.runNetworkDiagnostic();
  }

  // ==========================================================
  // ACTIVITY 3
  // Watch realtime diagnostic updates.
  //
  // The Provider will listen to this stream so the UI can
  // update while the diagnostic is still running.
  // ==========================================================

  Future<void> startLiveMonitoring() {
  return repository.startLiveMonitoring();
}

Future<void> stopLiveMonitoring() {
  return repository.stopLiveMonitoring();
}

bool get isLiveMonitoring =>
    repository.isLiveMonitoring;

  Stream<NetworkDiagnosticUpdate> watchUpdates() {
    return repository.watchDiagnosticUpdates();
  }
}