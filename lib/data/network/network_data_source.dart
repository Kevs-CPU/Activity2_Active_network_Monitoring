import 'dart:async';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/network_diagnostic_result.dart';
import '../../domain/entities/network_status.dart';

class NetworkDataSource {
  final Connectivity connectivity;

  NetworkDataSource({
    required this.connectivity,
  });

  // ------------------------------------------------------------
  // Connectivity
  // ------------------------------------------------------------

  Future<List<ConnectivityResult>> getCurrentConnectivity() {
    return connectivity.checkConnectivity();
  }

  Stream<List<ConnectivityResult>> watchConnectivity() {
    return connectivity.onConnectivityChanged;
  }

  // ------------------------------------------------------------
  // Test endpoints
  // ------------------------------------------------------------

  static final Uri _pingUrl = Uri.parse(
    'https://httpbin.org/get',
  );

  static Uri _downloadUrl(int bytes) {
    return Uri.parse(
      'https://httpbin.org/bytes/$bytes',
    );
  }

  static final Uri _uploadUrl = Uri.parse(
    'https://httpbin.org/post',
  );

  // ------------------------------------------------------------
  // Initial diagnostic configuration
  // ------------------------------------------------------------

  static const int _pingAttempts = 5;

  static const int _packetLossAttempts = 10;

  // Original diagnostic sizes.
  static const int _downloadBytes = 5 * 1024 * 1024;

  static const int _uploadBytes = 5 * 1024 * 1024;

  static const int _uploadChunkSize = 64 * 1024;

  static const Duration _realtimeUpdateInterval =
      Duration(milliseconds: 100);

  // ------------------------------------------------------------
  // Live monitoring configuration
  // ------------------------------------------------------------

  // Smaller transfers are used ONLY for live monitoring.
  static const int _liveDownloadBytes = 512 * 1024;

  static const int _liveUploadBytes = 512 * 1024;

  static const Duration _liveMonitoringInterval =
      Duration(seconds: 3);

  // ------------------------------------------------------------
  // Live performance
  // ------------------------------------------------------------

  // This value is calculated from actual measurements.
  //
  // 0.0 = very weak
  // 1.0 = very strong
  double _livePerformanceStrength = 0.5;

  double get livePerformanceStrength {
    return _livePerformanceStrength
        .clamp(0.0, 1.0)
        .toDouble();
  }

  // ------------------------------------------------------------
  // Live network health cache
  // ------------------------------------------------------------

  // These values contain the latest REAL measurements received
  // during live monitoring.
  double? _lastIdlePing;

  double? _lastDownloadSpeed;

  double? _lastUploadSpeed;

  double? _lastPacketLoss;

  NetworkHealth _liveNetworkHealth =
      NetworkHealth.unknown;

  // Latest COMPLETED live health.
  NetworkHealth get liveNetworkHealth {
    return _liveNetworkHealth;
  }

  // ------------------------------------------------------------
  // Cached diagnostic values
  // ------------------------------------------------------------

  double _lastDownloadPing = 0;

  double _lastUploadPing = 0;

  double _downloadCurrentProgress = 0.20;

  // ------------------------------------------------------------
  // Live monitoring state
  // ------------------------------------------------------------

  bool _isLiveMonitoring = false;

  Future<void>? _liveMonitoringTask;

  // ------------------------------------------------------------
  // Realtime diagnostic update callback
  // ------------------------------------------------------------

  Future<void> Function(
    String stage,
    double? value,
    double? secondaryValue,
    double progress,
  )? onDiagnosticUpdate;

  // ============================================================
  // SEND DIAGNOSTIC UPDATE
  // ============================================================

  Future<void> _sendDiagnosticUpdate({
    required String stage,
    double? value,
    double? secondaryValue,
    required double progress,
  }) async {
    final callback = onDiagnosticUpdate;

    if (callback == null) {
      return;
    }

    final double effectiveProgress = _isLiveMonitoring
        ? 1.0
        : progress.clamp(0.0, 1.0).toDouble();

    await callback(
      stage,
      value,
      secondaryValue,
      effectiveProgress,
    );
  }

  // ============================================================
  // UPDATE LIVE NETWORK HEALTH
  //
  // IMPORTANT:
  // Health is recalculated ONLY after a complete live cycle.
  //
  // Complete live cycle:
  // Idle Ping
  //      ↓
  // Download + Download Ping
  //      ↓
  // Upload + Upload Ping
  //      ↓
  // Packet Loss
  //      ↓
  // Calculate Health
  //
  // This prevents temporary health changes caused by
  // incomplete measurements.
  // ============================================================

  void _updateLiveNetworkHealth() {
    if (!_isLiveMonitoring) {
      return;
    }

    final double? downloadSpeed =
        _lastDownloadSpeed;

    final double? uploadSpeed =
        _lastUploadSpeed;

    final double? idlePing =
        _lastIdlePing;

    final double? packetLoss =
        _lastPacketLoss;

    // Every required measurement must exist before
    // recalculating live health.
    if (downloadSpeed == null ||
        uploadSpeed == null ||
        idlePing == null ||
        packetLoss == null) {
      return;
    }

    // Download and upload ping values are initialized
    // to actual values after their respective transfer
    // measurements complete.
    //
    // A value of 9999 means the ping measurement failed,
    // which should correctly classify the connection
    // as degraded.
    final double downloadPing =
        _lastDownloadPing;

    final double uploadPing =
        _lastUploadPing;

    _liveNetworkHealth =
        _classifyNetworkHealth(
      downloadSpeed: downloadSpeed,
      uploadSpeed: uploadSpeed,
      idlePing: idlePing,
      downloadPing: downloadPing,
      uploadPing: uploadPing,
      packetLoss: packetLoss,
    );
  }

  // ============================================================
  // UPDATE LIVE PERFORMANCE STRENGTH
  //
  // The strength is calculated from actual measured values.
  //
  // 0.0 = very weak
  // 1.0 = very strong
  // ============================================================

  void _updateLivePerformanceStrength({
    double? downloadMbps,
    double? uploadMbps,
    double? pingMs,
    double? packetLossPercent,
  }) {
    if (!_isLiveMonitoring) {
      return;
    }

    final List<double> scores = <double>[];

    // ----------------------------------------------------------
    // Download score
    // ----------------------------------------------------------

    if (downloadMbps != null) {
      final double downloadScore =
          (downloadMbps / 20.0)
              .clamp(0.0, 1.0)
              .toDouble();

      scores.add(downloadScore);
    }

    // ----------------------------------------------------------
    // Upload score
    // ----------------------------------------------------------

    if (uploadMbps != null) {
      final double uploadScore =
          (uploadMbps / 20.0)
              .clamp(0.0, 1.0)
              .toDouble();

      scores.add(uploadScore);
    }

    // ----------------------------------------------------------
    // Ping score
    // ----------------------------------------------------------

    if (pingMs != null) {
      final double pingScore =
          (1.0 - ((pingMs - 20.0) / 480.0))
              .clamp(0.0, 1.0)
              .toDouble();

      scores.add(pingScore);
    }

    // ----------------------------------------------------------
    // Packet loss score
    // ----------------------------------------------------------

    if (packetLossPercent != null) {
      final double packetLossScore =
          (1.0 - (packetLossPercent / 20.0))
              .clamp(0.0, 1.0)
              .toDouble();

      scores.add(packetLossScore);
    }

    if (scores.isEmpty) {
      return;
    }

    final double average =
        scores.reduce(
              (double a, double b) => a + b,
            ) /
            scores.length;

    // Smooth the wave so it does not jump violently.
    _livePerformanceStrength =
        (_livePerformanceStrength * 0.65) +
            (average * 0.35);

    _livePerformanceStrength =
        _livePerformanceStrength
            .clamp(0.0, 1.0)
            .toDouble();
  }

  // ============================================================
  // IDLE PING
  // ============================================================

  Future<double> measureIdlePing() async {
    final List<double> pingResults =
        <double>[];

    if (!_isLiveMonitoring) {
      _lastDownloadPing = 0;
      _lastUploadPing = 0;
      _downloadCurrentProgress = 0.20;

      _livePerformanceStrength = 0.5;

      _lastIdlePing = null;
      _lastDownloadSpeed = null;
      _lastUploadSpeed = null;
      _lastPacketLoss = null;

      _liveNetworkHealth =
          NetworkHealth.unknown;
    }

    await _sendDiagnosticUpdate(
      stage: 'Idle Ping',
      value: null,
      secondaryValue: null,
      progress: _isLiveMonitoring
          ? 1.0
          : 0.05,
    );

    for (int i = 0;
        i < _pingAttempts;
        i++) {
      final Stopwatch stopwatch =
          Stopwatch()..start();

      try {
        final http.Response response =
            await http
                .get(_pingUrl)
                .timeout(
                  const Duration(seconds: 5),
                );

        stopwatch.stop();

        if (response.statusCode >= 200 &&
            response.statusCode < 400) {
          final double ping =
              stopwatch.elapsedMicroseconds /
                  1000;

          pingResults.add(ping);

          if (_isLiveMonitoring) {
            _lastIdlePing = ping;
          }

          _updateLivePerformanceStrength(
            pingMs: ping,
          );

          final double progress =
              _isLiveMonitoring
                  ? 1.0
                  : 0.05 +
                      ((i + 1) /
                              _pingAttempts) *
                          0.15;

          await _sendDiagnosticUpdate(
            stage: 'Idle Ping',
            value: ping,
            secondaryValue: null,
            progress: progress,
          );
        }
      } catch (_) {
        stopwatch.stop();
      }

      if (_isLiveMonitoring == false &&
          _liveMonitoringTask != null) {
        break;
      }

      await Future<void>.delayed(
        const Duration(milliseconds: 100),
      );
    }

    if (pingResults.isEmpty) {
      if (_isLiveMonitoring) {
        _lastIdlePing = 9999;
      }

      _updateLivePerformanceStrength(
        pingMs: 9999,
      );

      return 9999;
    }

    final double averagePing =
        _average(pingResults);

    if (_isLiveMonitoring) {
      _lastIdlePing = averagePing;
    }

    return averagePing;
  }

  // ============================================================
  // DOWNLOAD SPEED
  //
  // Initial diagnostic = 5 MB
  // Live monitoring = 512 KB
  // ============================================================

  Future<double> measureDownloadSpeed({
    bool liveMeasurement = false,
  }) async {
    final int bytesToDownload =
        liveMeasurement
            ? _liveDownloadBytes
            : _downloadBytes;

    final List<double> pingValues =
        <double>[];

    bool running = true;

    _downloadCurrentProgress =
        liveMeasurement
            ? 0.0
            : 0.20;

    final Future<void> pingTask =
        _measurePingWhileTransfer(
      pingValues,
      () => running,
      stage: 'Download',
      getProgress: () =>
          _downloadCurrentProgress,
    );

    final Stopwatch stopwatch =
        Stopwatch()..start();

    int totalBytes = 0;

    DateTime lastRealtimeUpdate =
        DateTime.fromMillisecondsSinceEpoch(0);

    try {
      final http.Request request =
          http.Request(
        'GET',
        _downloadUrl(bytesToDownload),
      );

      final http.StreamedResponse response =
          await request.send().timeout(
                const Duration(seconds: 30),
              );

      await for (final List<int> chunk
          in response.stream) {
        totalBytes += chunk.length;

        final double elapsedSeconds =
            stopwatch.elapsedMicroseconds /
                1000000;

        if (elapsedSeconds <= 0) {
          continue;
        }

        final double currentMbps =
            _calculateMbps(
          totalBytes,
          elapsedSeconds,
        );

        final double downloadProgress =
            (totalBytes / bytesToDownload)
                .clamp(0.0, 1.0)
                .toDouble();

        if (liveMeasurement) {
          _downloadCurrentProgress =
              downloadProgress;
        } else {
          _downloadCurrentProgress =
              0.20 +
                  (downloadProgress * 0.25);
        }

        _updateLivePerformanceStrength(
          downloadMbps: currentMbps,
          pingMs: pingValues.isEmpty
              ? null
              : pingValues.last,
        );

        final DateTime now =
            DateTime.now();

        if (now.difference(
              lastRealtimeUpdate,
            ) >=
            _realtimeUpdateInterval) {
          lastRealtimeUpdate = now;

          await _sendDiagnosticUpdate(
            stage: 'Download',
            value: currentMbps,
            secondaryValue:
                pingValues.isEmpty
                    ? null
                    : pingValues.last,
            progress: _isLiveMonitoring
                ? 1.0
                : _downloadCurrentProgress,
          );
        }

        if (_isLiveMonitoring == false &&
            _liveMonitoringTask != null) {
          break;
        }
      }
    } catch (_) {
      running = false;

      await pingTask;

      _lastDownloadPing =
          pingValues.isEmpty
              ? 9999
              : _average(pingValues);

      if (_isLiveMonitoring) {
        _lastDownloadSpeed = 0;
      }

      _updateLivePerformanceStrength(
        downloadMbps: 0,
      );

      return 0;
    }

    stopwatch.stop();

    running = false;

    await pingTask;

    _lastDownloadPing =
        pingValues.isEmpty
            ? 9999
            : _average(pingValues);

    if (totalBytes == 0) {
      if (_isLiveMonitoring) {
        _lastDownloadSpeed = 0;
      }

      _updateLivePerformanceStrength(
        downloadMbps: 0,
      );

      return 0;
    }

    final double seconds =
        stopwatch.elapsedMicroseconds /
            1000000;

    if (seconds <= 0) {
      if (_isLiveMonitoring) {
        _lastDownloadSpeed = 0;
      }

      return 0;
    }

    final double finalSpeed =
        _calculateMbps(
      totalBytes,
      seconds,
    );

    if (_isLiveMonitoring) {
      _lastDownloadSpeed =
          finalSpeed;
    }

    _updateLivePerformanceStrength(
      downloadMbps: finalSpeed,
      pingMs: _lastDownloadPing,
    );

    await _sendDiagnosticUpdate(
      stage: 'Download',
      value: finalSpeed,
      secondaryValue:
          _lastDownloadPing,
      progress: _isLiveMonitoring
          ? 1.0
          : 0.45,
    );

    return finalSpeed;
  }

  // ============================================================
  // DOWNLOAD PING
  // ============================================================

  Future<double> measureDownloadPing() async {
    return _lastDownloadPing;
  }

  // ============================================================
  // UPLOAD SPEED
  //
  // Initial diagnostic = 5 MB
  // Live monitoring = 512 KB
  // ============================================================

  Future<double> measureUploadSpeed({
    bool liveMeasurement = false,
  }) async {
    final int bytesToUpload =
        liveMeasurement
            ? _liveUploadBytes
            : _uploadBytes;

    final List<double> pingValues =
        <double>[];

    bool running = true;

    double uploadProgress =
        liveMeasurement
            ? 0.0
            : 0.45;

    final Future<void> pingTask =
        _measurePingWhileTransfer(
      pingValues,
      () => running,
      stage: 'Upload',
      getProgress: () => uploadProgress,
    );

    final Uint8List uploadData =
        Uint8List(bytesToUpload);

    final Stopwatch stopwatch =
        Stopwatch()..start();

    DateTime lastRealtimeUpdate =
        DateTime.fromMillisecondsSinceEpoch(0);

    try {
      final http.StreamedRequest request =
          http.StreamedRequest(
        'POST',
        _uploadUrl,
      );

      request.contentLength =
          bytesToUpload;

      request.headers['Content-Type'] =
          'application/octet-stream';

      final Future<http.StreamedResponse>
          responseFuture =
          request.send().timeout(
                const Duration(seconds: 30),
              );

      int uploadedBytes = 0;

      while (uploadedBytes <
          bytesToUpload) {
        final int remaining =
            bytesToUpload -
                uploadedBytes;

        final int chunkLength =
            remaining < _uploadChunkSize
                ? remaining
                : _uploadChunkSize;

        final Uint8List chunk =
            uploadData.sublist(
          uploadedBytes,
          uploadedBytes +
              chunkLength,
        );

        request.sink.add(chunk);

        uploadedBytes += chunkLength;

        final double elapsedSeconds =
            stopwatch.elapsedMicroseconds /
                1000000;

        if (elapsedSeconds > 0) {
          final double currentMbps =
              _calculateMbps(
            uploadedBytes,
            elapsedSeconds,
          );

          final double transferProgress =
              (uploadedBytes /
                      bytesToUpload)
                  .clamp(0.0, 1.0)
                  .toDouble();

          if (liveMeasurement) {
            uploadProgress =
                transferProgress;
          } else {
            uploadProgress =
                0.45 +
                    (transferProgress *
                        0.25);
          }

          _updateLivePerformanceStrength(
            uploadMbps: currentMbps,
            pingMs: pingValues.isEmpty
                ? null
                : pingValues.last,
          );

          final DateTime now =
              DateTime.now();

          if (now.difference(
                lastRealtimeUpdate,
              ) >=
              _realtimeUpdateInterval) {
            lastRealtimeUpdate = now;

            await _sendDiagnosticUpdate(
              stage: 'Upload',
              value: currentMbps,
              secondaryValue:
                  pingValues.isEmpty
                      ? null
                      : pingValues.last,
              progress:
                  _isLiveMonitoring
                      ? 1.0
                      : uploadProgress,
            );
          }
        }

        if (_isLiveMonitoring ==
                false &&
            _liveMonitoringTask != null) {
          break;
        }

        await Future<void>.delayed(
          const Duration(milliseconds: 1),
        );
      }

      await request.sink.close();

      await responseFuture;
    } catch (_) {
      running = false;

      await pingTask;

      _lastUploadPing =
          pingValues.isEmpty
              ? 9999
              : _average(pingValues);

      if (_isLiveMonitoring) {
        _lastUploadSpeed = 0;
      }

      _updateLivePerformanceStrength(
        uploadMbps: 0,
      );

      return 0;
    }

    stopwatch.stop();

    running = false;

    await pingTask;

    _lastUploadPing =
        pingValues.isEmpty
            ? 9999
            : _average(pingValues);

    final double seconds =
        stopwatch.elapsedMicroseconds /
            1000000;

    if (seconds <= 0) {
      if (_isLiveMonitoring) {
        _lastUploadSpeed = 0;
      }

      return 0;
    }

    final double finalSpeed =
        _calculateMbps(
      bytesToUpload,
      seconds,
    );

    if (_isLiveMonitoring) {
      _lastUploadSpeed =
          finalSpeed;
    }

    _updateLivePerformanceStrength(
      uploadMbps: finalSpeed,
      pingMs: _lastUploadPing,
    );

    await _sendDiagnosticUpdate(
      stage: 'Upload',
      value: finalSpeed,
      secondaryValue:
          _lastUploadPing,
      progress: _isLiveMonitoring
          ? 1.0
          : 0.70,
    );

    return finalSpeed;
  }

  // ============================================================
  // UPLOAD PING
  // ============================================================

  Future<double> measureUploadPing() async {
    return _lastUploadPing;
  }

  // ============================================================
  // PACKET LOSS
  // ============================================================

  Future<double> measurePacketLoss() async {
    int failed = 0;
    int attemptsPerformed = 0;

    await _sendDiagnosticUpdate(
      stage: 'Packet Loss',
      value: 0,
      secondaryValue: null,
      progress: _isLiveMonitoring
          ? 1.0
          : 0.70,
    );

    for (int i = 0;
        i < _packetLossAttempts;
        i++) {
      attemptsPerformed++;

      try {
        final http.Response response =
            await http
                .get(_pingUrl)
                .timeout(
                  const Duration(seconds: 5),
                );

        if (response.statusCode < 200 ||
            response.statusCode >= 400) {
          failed++;
        }
      } catch (_) {
        failed++;
      }

      final double packetLoss =
          attemptsPerformed == 0
              ? 0
              : (failed /
                      attemptsPerformed) *
                  100;

      _updateLivePerformanceStrength(
        packetLossPercent:
            packetLoss,
      );

      await _sendDiagnosticUpdate(
        stage: 'Packet Loss',
        value: packetLoss,
        secondaryValue: null,
        progress: _isLiveMonitoring
            ? 1.0
            : 0.70 +
                ((i + 1) /
                        _packetLossAttempts) *
                    0.20,
      );

      if (_isLiveMonitoring == false &&
          _liveMonitoringTask != null) {
        break;
      }

      await Future<void>.delayed(
        const Duration(milliseconds: 100),
      );
    }

    final double finalPacketLoss =
        attemptsPerformed == 0
            ? 0
            : (failed / attemptsPerformed) *
                100;

    if (_isLiveMonitoring) {
      _lastPacketLoss =
          finalPacketLoss;
    }

    _updateLivePerformanceStrength(
      packetLossPercent:
          finalPacketLoss,
    );

    return finalPacketLoss;
  }

  // ============================================================
  // COMPLETE NETWORK DIAGNOSTIC
  // ============================================================

  Future<NetworkDiagnosticResult>
      runNetworkDiagnostic() async {
    await stopLiveMonitoring();

    final double idlePing =
        await measureIdlePing();

    final double downloadSpeed =
        await measureDownloadSpeed();

    final double downloadPing =
        await measureDownloadPing();

    final double uploadSpeed =
        await measureUploadSpeed();

    final double uploadPing =
        await measureUploadPing();

    final double packetLoss =
        await measurePacketLoss();

    final NetworkHealth health =
        _classifyNetworkHealth(
      downloadSpeed:
          downloadSpeed,
      uploadSpeed:
          uploadSpeed,
      idlePing:
          idlePing,
      downloadPing:
          downloadPing,
      uploadPing:
          uploadPing,
      packetLoss:
          packetLoss,
    );

    await _sendDiagnosticUpdate(
      stage: 'Diagnostic Complete',
      value: null,
      secondaryValue: null,
      progress: 1.0,
    );

    return NetworkDiagnosticResult(
      idlePingMs: idlePing,
      downloadMbps: downloadSpeed,
      downloadPingMs:
          downloadPing,
      uploadMbps: uploadSpeed,
      uploadPingMs:
          uploadPing,
      packetLossPercent:
          packetLoss,
      health: health,
    );
  }

  // ============================================================
  // START LIVE PERFORMANCE MONITORING
  // ============================================================

  Future<void> startLiveMonitoring() async {
    if (_isLiveMonitoring) {
      return;
    }

    _isLiveMonitoring = true;

    await _sendDiagnosticUpdate(
      stage:
          'Live Performance Monitoring',
      value: null,
      secondaryValue: null,
      progress: 1.0,
    );

    _liveMonitoringTask =
        _runLiveMonitoringLoop();
  }

  // ============================================================
  // STOP LIVE PERFORMANCE MONITORING
  // ============================================================

  Future<void> stopLiveMonitoring() async {
    if (!_isLiveMonitoring) {
      return;
    }

    _isLiveMonitoring = false;

    final Future<void>? task =
        _liveMonitoringTask;

    if (task != null) {
      try {
        await task;
      } catch (_) {
        // Ignore shutdown errors.
      }
    }

    _liveMonitoringTask = null;
  }

  // ============================================================
  // CHECK LIVE MONITORING STATE
  // ============================================================

  bool get isLiveMonitoring {
    return _isLiveMonitoring;
  }

  // ============================================================
  // LIVE PERFORMANCE STRENGTH
  // ============================================================

  double getLivePerformanceStrength() {
    return _livePerformanceStrength
        .clamp(0.0, 1.0)
        .toDouble();
  }

  // ============================================================
  // LIVE MONITORING LOOP
  //
  // Automatically runs after diagnostic completion.
  //
  // Health is updated ONLY after the complete cycle.
  // ============================================================

  Future<void> _runLiveMonitoringLoop() async {
    while (_isLiveMonitoring) {
      try {
        // ------------------------------------------------------
        // 1. Live Idle Ping
        // ------------------------------------------------------

        await measureIdlePing();

        if (!_isLiveMonitoring) {
          break;
        }

        // ------------------------------------------------------
        // 2. Live Download
        // ------------------------------------------------------

        await measureDownloadSpeed(
          liveMeasurement: true,
        );

        if (!_isLiveMonitoring) {
          break;
        }

        // ------------------------------------------------------
        // 3. Live Upload
        // ------------------------------------------------------

        await measureUploadSpeed(
          liveMeasurement: true,
        );

        if (!_isLiveMonitoring) {
          break;
        }

        // ------------------------------------------------------
        // 4. Live Packet Loss
        // ------------------------------------------------------

        await measurePacketLoss();

        if (!_isLiveMonitoring) {
          break;
        }

        // ------------------------------------------------------
        // COMPLETE LIVE CYCLE
        //
        // At this point all required measurements have been
        // completed using actual network data.
        // ------------------------------------------------------

        _updateLiveNetworkHealth();

        await _sendDiagnosticUpdate(
          stage: 'Live Performance',
          value:
              _livePerformanceStrength,
          secondaryValue: null,
          progress: 1.0,
        );
      } catch (_) {
        if (_isLiveMonitoring) {
          // Do NOT recalculate health from incomplete data.
          // Keep the health from the last completed cycle.

          await _sendDiagnosticUpdate(
            stage: 'Live Performance',
            value:
                _livePerformanceStrength,
            secondaryValue: null,
            progress: 1.0,
          );
        }
      }

      if (!_isLiveMonitoring) {
        break;
      }

      await Future<void>.delayed(
        _liveMonitoringInterval,
      );
    }
  }

  // ============================================================
  // PING WHILE TRANSFER IS RUNNING
  // ============================================================

  Future<void> _measurePingWhileTransfer(
    List<double> results,
    bool Function() isRunning, {
    required String stage,
    required double Function()
        getProgress,
  }) async {
    while (isRunning()) {
      final Stopwatch stopwatch =
          Stopwatch()..start();

      try {
        final http.Response response =
            await http
                .get(_pingUrl)
                .timeout(
                  const Duration(seconds: 5),
                );

        stopwatch.stop();

        if (response.statusCode >= 200 &&
            response.statusCode < 400) {
          final double ping =
              stopwatch.elapsedMicroseconds /
                  1000;

          results.add(ping);

          _updateLivePerformanceStrength(
            pingMs: ping,
          );

          await _sendDiagnosticUpdate(
            stage: stage,
            value: null,
            secondaryValue: ping,
            progress: _isLiveMonitoring
                ? 1.0
                : getProgress()
                    .clamp(0.0, 1.0)
                    .toDouble(),
          );
        }
      } catch (_) {
        stopwatch.stop();
      }

      await Future<void>.delayed(
        const Duration(milliseconds: 100),
      );
    }
  }

  // ============================================================
  // CALCULATE MBPS
  // ============================================================

  double _calculateMbps(
    int bytes,
    double seconds,
  ) {
    if (bytes <= 0 || seconds <= 0) {
      return 0;
    }

    final int bits = bytes * 8;

    return bits /
        seconds /
        1000000;
  }

  // ============================================================
  // AVERAGE
  // ============================================================

  double _average(
    List<double> values,
  ) {
    if (values.isEmpty) {
      return 0;
    }

    final double total =
        values.reduce(
      (double a, double b) => a + b,
    );

    return total / values.length;
  }

  // ============================================================
  // NETWORK HEALTH CLASSIFICATION
  // ============================================================

  NetworkHealth _classifyNetworkHealth({
    required double downloadSpeed,
    required double uploadSpeed,
    required double idlePing,
    required double downloadPing,
    required double uploadPing,
    required double packetLoss,
  }) {
    // ----------------------------------------------------------
    // DEGRADED
    // ----------------------------------------------------------

    if (packetLoss >= 20 ||
        idlePing >= 500 ||
        downloadPing >= 500 ||
        uploadPing >= 500) {
      return NetworkHealth.degraded;
    }

    // ----------------------------------------------------------
    // EXCELLENT
    // ----------------------------------------------------------

    if (downloadSpeed > 10 &&
        uploadSpeed > 10) {
      return NetworkHealth.excellent;
    }

    // ----------------------------------------------------------
    // FAIR
    // ----------------------------------------------------------

    if (downloadSpeed >= 2 &&
        uploadSpeed >= 2) {
      return NetworkHealth.fair;
    }

    // ----------------------------------------------------------
    // POOR
    // ----------------------------------------------------------

    return NetworkHealth.poor;
  }
}