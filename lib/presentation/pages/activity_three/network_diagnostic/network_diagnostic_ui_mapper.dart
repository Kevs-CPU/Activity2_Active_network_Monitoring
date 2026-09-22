import 'package:flutter/material.dart';

import '../../../../domain/entities/network_diagnostic_result.dart';
import '../../../../domain/entities/network_diagnostic_update.dart';
import '../../../../domain/entities/network_status.dart';

import 'network_diagnostic_ui_model.dart';

class NetworkDiagnosticUiMapper {
  const NetworkDiagnosticUiMapper();

  NetworkDiagnosticUiModel map({
    required bool isRunning,
    required bool isCompleted,
    required String statusTitle,
    required String statusDescription,
    required NetworkDiagnosticUpdate? update,
    required NetworkDiagnosticResult? result,
    required Object? error,
  }) {
    return NetworkDiagnosticUiModel(
      isRunning: isRunning,
      isCompleted: isCompleted,
      statusTitle: statusTitle,
      statusDescription: statusDescription,
      shortStage: _mapShortStage(update),
      statusIcon: _mapStatusIcon(
        isRunning: isRunning,
        isCompleted: isCompleted,
        error: error,
      ),
      progress: _mapProgress(update),
      progressText: _mapProgressText(update),
      progressDescription: _mapProgressDescription(update),
      metrics: _mapMetrics(result, update),
      currentTest: _mapCurrentTest(update),
      health: result == null ? null : _mapHealth(result),
      activeStep: _mapActiveStep(update),
      buttonLabel: _mapButtonLabel(
        isRunning,
        isCompleted,
      ),
      errorMessage: error?.toString(),
    );
  }

  DiagnosticMetricsUiModel _mapMetrics(
    NetworkDiagnosticResult? result,
    NetworkDiagnosticUpdate? update,
  ) {
    final idlePing = update?.idlePingMs ?? result?.idlePingMs;
    final downloadMbps = update?.downloadMbps ?? result?.downloadMbps;
    final downloadPing = update?.downloadPingMs ?? result?.downloadPingMs;
    final uploadMbps = update?.uploadMbps ?? result?.uploadMbps;
    final uploadPing = update?.uploadPingMs ?? result?.uploadPingMs;
    final packetLoss = update?.packetLossPercent ?? result?.packetLossPercent;

    return DiagnosticMetricsUiModel(
      idlePing: _formatMs(idlePing),
      downloadSpeed: _formatMbps(downloadMbps),
      downloadPing: _formatMs(downloadPing),
      uploadSpeed: _formatMbps(uploadMbps),
      uploadPing: _formatMs(uploadPing),
      packetLoss: _formatPercent(packetLoss),
    );
  }

  DiagnosticCurrentTestUiModel? _mapCurrentTest(
    NetworkDiagnosticUpdate? update,
  ) {
    if (update == null) {
      return null;
    }

    final stage = update.stage;

    if (stage == 'Measuring Idle Ping') {
      return DiagnosticCurrentTestUiModel(
        icon: Icons.speed,
        title: 'Idle Ping',
        value: _formatMs(update.idlePingMs),
        valueLabel: 'ms',
      );
    }

    if (stage == 'Downloading' || stage == 'Download Complete') {
      return DiagnosticCurrentTestUiModel(
        icon: Icons.download,
        title: 'Download',
        value: _formatMbps(update.downloadMbps),
        valueLabel: 'Mbps',
        secondary: _formatMs(update.downloadPingMs),
        secondaryLabel: 'ms',
      );
    }

    if (stage == 'Uploading' || stage == 'Upload Complete') {
      return DiagnosticCurrentTestUiModel(
        icon: Icons.upload,
        title: 'Upload',
        value: _formatMbps(update.uploadMbps),
        valueLabel: 'Mbps',
        secondary: _formatMs(update.uploadPingMs),
        secondaryLabel: 'ms',
      );
    }

    if (stage == 'Measuring Packet Loss') {
      return DiagnosticCurrentTestUiModel(
        icon: Icons.network_check,
        title: 'Packet Loss',
        value: _formatPercent(update.packetLossPercent),
        valueLabel: '%',
      );
    }

    return null;
  }

  DiagnosticHealthUiModel _mapHealth(
    NetworkDiagnosticResult result,
  ) {
    final health = result.health;

    return DiagnosticHealthUiModel(
      name: _healthName(health),
      description: _healthDescription(health),
      downloadMbps: result.downloadMbps,
      uploadMbps: result.uploadMbps,
      idlePingMs: result.idlePingMs,
      downloadPingMs: result.downloadPingMs,
      uploadPingMs: result.uploadPingMs,
      packetLossPercent: result.packetLossPercent,
      tone: _healthTone(health),
    );
  }

  String _mapShortStage(NetworkDiagnosticUpdate? update) {
    if (update == null) {
      return 'Ready';
    }

    final stage = update.stage;

    if (stage == 'Measuring Idle Ping') return 'Idle Ping';
    if (stage == 'Downloading') return 'Download';
    if (stage == 'Download Complete') return 'Download Complete';
    if (stage == 'Uploading') return 'Upload';
    if (stage == 'Upload Complete') return 'Upload Complete';
    if (stage == 'Measuring Packet Loss') return 'Packet Loss';
    if (stage == 'Diagnostic Complete') return 'Completed';

    return stage;
  }

  int _mapActiveStep(NetworkDiagnosticUpdate? update) {
    if (update == null) return 0;

    final stage = update.stage;

    if (stage == 'Measuring Idle Ping') return 0;
    if (stage == 'Downloading' || stage == 'Download Complete') return 1;
    if (stage == 'Uploading' || stage == 'Upload Complete') return 2;
    if (stage == 'Measuring Packet Loss') return 3;
    if (stage == 'Diagnostic Complete') return 4;

    return 0;
  }

  double _mapProgress(NetworkDiagnosticUpdate? update) {
    if (update == null) return 0.0;

    return update.progress.clamp(0.0, 1.0);
  }

  String _mapProgressText(NetworkDiagnosticUpdate? update) {
    final progress = _mapProgress(update);
    return '${(progress * 100).round()}%';
  }

  String _mapProgressDescription(NetworkDiagnosticUpdate? update) {
    if (update == null) {
      return 'Ready to start network diagnostic';
    }

    final stage = update.stage;

    if (stage == 'Measuring Idle Ping') {
      return 'Checking your network response time';
    }

    if (stage == 'Downloading') {
      return 'Testing download performance';
    }

    if (stage == 'Download Complete') {
      return 'Download test completed';
    }

    if (stage == 'Uploading') {
      return 'Testing upload performance';
    }

    if (stage == 'Upload Complete') {
      return 'Upload test completed';
    }

    if (stage == 'Measuring Packet Loss') {
      return 'Checking packet loss';
    }

    if (stage == 'Diagnostic Complete') {
      return 'Network diagnostic completed';
    }

    return update.stage;
  }

  IconData _mapStatusIcon({
    required bool isRunning,
    required bool isCompleted,
    required Object? error,
  }) {
    if (error != null) return Icons.error_outline;
    if (isCompleted) return Icons.check_circle_outline;
    if (isRunning) return Icons.network_check;

    return Icons.network_ping;
  }

  String _mapButtonLabel(
    bool isRunning,
    bool isCompleted,
  ) {
    if (isRunning) return 'Testing Network...';
    if (isCompleted) return 'Run Again';

    return 'Start Diagnostic';
  }

  String _healthName(NetworkHealth health) {
    switch (health) {
      case NetworkHealth.excellent:
        return 'Excellent';

      case NetworkHealth.fair:
        return 'Fair';

      case NetworkHealth.poor:
        return 'Poor';

      case NetworkHealth.degraded:
        return 'Degraded';

      case NetworkHealth.unknown:
        return 'Unknown';
    }
  }

  String _healthDescription(NetworkHealth health) {
    switch (health) {
      case NetworkHealth.excellent:
        return 'Your network connection is performing very well.';

      case NetworkHealth.fair:
        return 'Your network connection has moderate performance.';

      case NetworkHealth.poor:
        return 'Your network connection may have performance issues.';

      case NetworkHealth.degraded:
        return 'Your network connection is currently degraded.';

      case NetworkHealth.unknown:
        return 'Network health could not be determined.';
    }
  }

  DiagnosticHealthTone _healthTone(NetworkHealth health) {
    switch (health) {
      case NetworkHealth.excellent:
        return DiagnosticHealthTone.excellent;

      case NetworkHealth.fair:
        return DiagnosticHealthTone.fair;

      case NetworkHealth.poor:
        return DiagnosticHealthTone.poor;

      case NetworkHealth.degraded:
        return DiagnosticHealthTone.degraded;

      case NetworkHealth.unknown:
        return DiagnosticHealthTone.unknown;
    }
  }

  String _formatMs(double? value) {
    if (value == null) return '--';

    return value.toStringAsFixed(1);
  }

  String _formatMbps(double? value) {
    if (value == null) return '--';

    return value.toStringAsFixed(1);
  }

  String _formatPercent(double? value) {
    if (value == null) return '--';

    return value.toStringAsFixed(1);
  }
}