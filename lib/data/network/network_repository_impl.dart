import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/entities/network_diagnostic_result.dart';
import '../../domain/entities/network_diagnostic_update.dart';
import '../../domain/entities/network_status.dart';
import '../../domain/repositories/network_repository.dart';
import 'network_data_source.dart';

// ============================================================
// ACTIVITY 2 + ACTIVITY 3
// Network Repository Implementation
//
// Connects the Domain layer with the Data layer.
//
// ACTIVITY 2:
// - Network connectivity monitoring
//
// ACTIVITY 3:
// - Network diagnostic measurements
// - Realtime diagnostic updates
// - Live performance monitoring
// - Live performance strength
// - Live network health
// ============================================================

class NetworkRepositoryImpl implements NetworkRepository {
  final NetworkDataSource dataSource;

  // ============================================================
  // ACTIVITY 3
  // Realtime diagnostic update stream.
  // ============================================================

  final StreamController<NetworkDiagnosticUpdate>
      _diagnosticUpdateController =
      StreamController<NetworkDiagnosticUpdate>.broadcast();

  // ============================================================
  // ACTIVITY 3
  // Latest diagnostic values.
  //
  // These values are preserved between realtime updates so
  // that one changing value does not erase the others.
  // ============================================================

  double? _idlePingMs;
  double? _downloadMbps;
  double? _downloadPingMs;
  double? _uploadMbps;
  double? _uploadPingMs;
  double? _packetLossPercent;

  // ============================================================
  // ACTIVITY 3
  // Latest live performance strength.
  //
  // 0.0 = very weak
  // 0.5 = medium
  // 1.0 = very strong
  // ============================================================

  double _livePerformanceStrength = 0.5;

  // ============================================================
  // ACTIVITY 3
  // Latest COMPLETED live network health.
  //
  // During a live cycle, the DataSource keeps the previous
  // completed health until the new cycle has finished.
  // ============================================================

  NetworkHealth _liveNetworkHealth =
      NetworkHealth.unknown;

  // ============================================================
  // Constructor
  // ============================================================

  NetworkRepositoryImpl({
    required this.dataSource,
  }) {
    // ==========================================================
    // ACTIVITY 3
    // Receive realtime updates from the DataSource.
    // ==========================================================

    dataSource.onDiagnosticUpdate = (
      String stage,
      double? value,
      double? secondaryValue,
      double progress,
    ) async {
      final String normalizedStage =
          stage.toLowerCase();

      // ========================================================
      // IDLE PING
      // ========================================================

      if (normalizedStage.contains('idle ping')) {
        if (value != null) {
          _idlePingMs = value;
        }
      }

      // ========================================================
      // DOWNLOAD
      // ========================================================

      else if (normalizedStage.contains('download')) {
        if (value != null) {
          _downloadMbps = value;
        }

        if (secondaryValue != null) {
          _downloadPingMs = secondaryValue;
        }
      }

      // ========================================================
      // UPLOAD
      // ========================================================

      else if (normalizedStage.contains('upload')) {
        if (value != null) {
          _uploadMbps = value;
        }

        if (secondaryValue != null) {
          _uploadPingMs = secondaryValue;
        }
      }

      // ========================================================
      // PACKET LOSS
      // ========================================================

      else if (normalizedStage.contains('packet loss')) {
        if (value != null) {
          _packetLossPercent = value;
        }
      }

      // ========================================================
      // LIVE PERFORMANCE
      //
      // The DataSource sends its calculated performance
      // strength through the "value" field.
      // ========================================================

      else if (normalizedStage.contains('live performance')) {
        if (value != null) {
          _livePerformanceStrength =
              value.clamp(0.0, 1.0).toDouble();
        }
      }

      // ========================================================
      // ACTIVITY 3
      // Read current performance strength directly from the
      // DataSource.
      // ========================================================

      if (dataSource.isLiveMonitoring) {
        _livePerformanceStrength =
            dataSource
                .getLivePerformanceStrength()
                .clamp(0.0, 1.0)
                .toDouble();

        // ------------------------------------------------------
        // IMPORTANT:
        // The DataSource is the source of truth for live health.
        //
        // It only changes live health after a COMPLETE live
        // measurement cycle.
        // ------------------------------------------------------

        _liveNetworkHealth =
            dataSource.liveNetworkHealth;
      } else {
        // ------------------------------------------------------
        // During the initial diagnostic, calculate health from
        // the values currently received by the Repository.
        // ------------------------------------------------------

        _liveNetworkHealth =
            _calculateCurrentHealth();
      }

      // ========================================================
      // Force progress to 100% while live monitoring.
      //
      // This prevents progress from going backward after the
      // initial diagnostic is complete.
      // ========================================================

      final double effectiveProgress =
          dataSource.isLiveMonitoring
              ? 1.0
              : progress
                  .clamp(0.0, 1.0)
                  .toDouble();

      // ========================================================
      // Forward complete current diagnostic state.
      // ========================================================

      if (!_diagnosticUpdateController.isClosed) {
        _diagnosticUpdateController.add(
          NetworkDiagnosticUpdate(
            stage: stage,
            progress: effectiveProgress,

            idlePingMs: _idlePingMs,

            downloadMbps: _downloadMbps,
            downloadPingMs: _downloadPingMs,

            uploadMbps: _uploadMbps,
            uploadPingMs: _uploadPingMs,

            packetLossPercent:
                _packetLossPercent,

            // --------------------------------------------------
            // ACTIVITY 3
            // Forward the latest completed live health.
            // --------------------------------------------------

            health: _liveNetworkHealth,

            livePerformanceStrength:
                _livePerformanceStrength,
          ),
        );
      }
    };
  }

  // ============================================================
  // ACTIVITY 3
  // Calculate current network health from the latest
  // available diagnostic values.
  //
  // Used only during the initial diagnostic.
  // Live monitoring uses the DataSource's completed-cycle
  // health instead.
  // ============================================================

  NetworkHealth _calculateCurrentHealth() {
    final double? idlePing = _idlePingMs;
    final double? downloadSpeed = _downloadMbps;
    final double? downloadPing = _downloadPingMs;
    final double? uploadSpeed = _uploadMbps;
    final double? uploadPing = _uploadPingMs;
    final double? packetLoss = _packetLossPercent;

    // Some values may still be unavailable during the
    // initial diagnostic.

    if (idlePing == null ||
        downloadSpeed == null ||
        downloadPing == null ||
        uploadSpeed == null ||
        uploadPing == null ||
        packetLoss == null) {
      return NetworkHealth.unknown;
    }

    // ==========================================================
    // DEGRADED
    // ==========================================================

    if (packetLoss >= 20 ||
        idlePing >= 500 ||
        downloadPing >= 500 ||
        uploadPing >= 500) {
      return NetworkHealth.degraded;
    }

    // ==========================================================
    // EXCELLENT
    // ==========================================================

    if (downloadSpeed > 10 &&
        uploadSpeed > 10) {
      return NetworkHealth.excellent;
    }

    // ==========================================================
    // FAIR
    // ==========================================================

    if (downloadSpeed >= 2 &&
        uploadSpeed >= 2) {
      return NetworkHealth.fair;
    }

    // ==========================================================
    // POOR
    // ==========================================================

    return NetworkHealth.poor;
  }

  // ============================================================
  // ACTIVITY 2
  // Current network connectivity.
  // ============================================================

  @override
  Future<NetworkStatus> getCurrentNetwork() async {
    final List<ConnectivityResult> connectivity =
        await dataSource.getCurrentConnectivity();

    return _mapConnectivity(connectivity);
  }

  // ============================================================
  // ACTIVITY 2
  // Watch network connectivity changes.
  // ============================================================

  @override
  Stream<NetworkStatus> watchNetwork() {
    return dataSource
        .watchConnectivity()
        .map(_mapConnectivity);
  }

  // ============================================================
  // ACTIVITY 2
  // Convert connectivity_plus result to domain entity.
  // ============================================================

  NetworkStatus _mapConnectivity(
    List<ConnectivityResult> connectivity,
  ) {
    if (connectivity.contains(
      ConnectivityResult.wifi,
    )) {
      return const NetworkStatus(
        type: NetworkType.wifi,
      );
    }

    if (connectivity.contains(
      ConnectivityResult.mobile,
    )) {
      return const NetworkStatus(
        type: NetworkType.cellular,
      );
    }

    return const NetworkStatus(
      type: NetworkType.offline,
    );
  }

  // ============================================================
  // ACTIVITY 3
  // Individual network measurements.
  // ============================================================

  @override
  Future<double> measureIdlePing() {
    return dataSource.measureIdlePing();
  }

  @override
  Future<double> measureDownloadSpeed() {
    return dataSource.measureDownloadSpeed();
  }

  @override
  Future<double> measureDownloadPing() {
    return dataSource.measureDownloadPing();
  }

  @override
  Future<double> measureUploadSpeed() {
    return dataSource.measureUploadSpeed();
  }

  @override
  Future<double> measureUploadPing() {
    return dataSource.measureUploadPing();
  }

  @override
  Future<double> measurePacketLoss() {
    return dataSource.measurePacketLoss();
  }

  // ============================================================
  // ACTIVITY 3
  // Run complete diagnostic.
  //
  // Previous realtime values are cleared before a new test
  // begins so that the new test starts cleanly.
  // ============================================================

  @override
  Future<NetworkDiagnosticResult>
      runNetworkDiagnostic() async {
    // Make sure live monitoring is stopped before
    // starting a new complete diagnostic.
    await dataSource.stopLiveMonitoring();

    // Clear previous values.
    _idlePingMs = null;
    _downloadMbps = null;
    _downloadPingMs = null;
    _uploadMbps = null;
    _uploadPingMs = null;
    _packetLossPercent = null;

    // Reset live visualization strength.
    _livePerformanceStrength = 0.5;

    // Reset live health.
    _liveNetworkHealth =
        NetworkHealth.unknown;

    return dataSource.runNetworkDiagnostic();
  }

  // ============================================================
  // ACTIVITY 3
  // Realtime diagnostic stream.
  // ============================================================

  @override
  Stream<NetworkDiagnosticUpdate>
      watchDiagnosticUpdates() {
    return _diagnosticUpdateController.stream;
  }

  // ============================================================
  // ACTIVITY 3
  // Start Live Performance Monitoring.
  // ============================================================

  @override
  Future<void> startLiveMonitoring() {
    return dataSource.startLiveMonitoring();
  }

  // ============================================================
  // ACTIVITY 3
  // Stop Live Performance Monitoring.
  // ============================================================

  @override
  Future<void> stopLiveMonitoring() {
    return dataSource.stopLiveMonitoring();
  }

  // ============================================================
  // ACTIVITY 3
  // Check whether Live Performance Monitoring is active.
  // ============================================================

  @override
  bool get isLiveMonitoring {
    return dataSource.isLiveMonitoring;
  }

  // ============================================================
  // ACTIVITY 3
  // Current live performance strength.
  // ============================================================

  double get livePerformanceStrength {
    return _livePerformanceStrength
        .clamp(0.0, 1.0)
        .toDouble();
  }

  // ============================================================
  // ACTIVITY 3
  // Current live network health.
  // ============================================================

  NetworkHealth get liveNetworkHealth {
    return _liveNetworkHealth;
  }

  // ============================================================
  // ACTIVITY 3
  // Dispose repository resources.
  // ============================================================

  Future<void> dispose() async {
    // Stop live monitoring first so that no new updates
    // are generated while the stream is being closed.
    await dataSource.stopLiveMonitoring();

    await _diagnosticUpdateController.close();
  }
}