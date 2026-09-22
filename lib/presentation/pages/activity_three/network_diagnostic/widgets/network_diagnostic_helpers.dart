import '../../../../providers/network_diagnostic_provider.dart';

// ============================================================
// ACTIVITY 3
// Network Diagnostic Helpers
// ============================================================

class NetworkDiagnosticHelpers {
  const NetworkDiagnosticHelpers._();

  static String statusDescription(
    NetworkDiagnosticProvider provider,
  ) {
    final String stage =
        provider.currentStage.toLowerCase();

    if (stage.contains('download')) {
      return 'Measuring download bandwidth and ping';
    }

    if (stage.contains('upload')) {
      return 'Measuring upload bandwidth and ping';
    }

    if (stage.contains('packet')) {
      return 'Checking packet loss';
    }

    if (stage.contains('idle')) {
      return 'Measuring baseline latency';
    }

    return 'Running network performance test';
  }

  static int getActiveStep(
    NetworkDiagnosticProvider provider,
  ) {
    if (provider.result != null) {
      return 5;
    }

    final String stage =
        provider.currentStage.toLowerCase();

    if (stage.contains('packet') ||
        stage.contains('loss')) {
      return 3;
    }

    if (stage.contains('upload')) {
      return 2;
    }

    if (stage.contains('download')) {
      return 1;
    }

    if (stage.contains('idle') ||
        stage.contains('ping')) {
      return 0;
    }

    return 0;
  }

  static String progressDescription(
    NetworkDiagnosticProvider provider,
  ) {
    if (provider.isMonitoring) {
      return 'Live performance monitoring • Progress complete';
    }

    if (provider.result != null) {
      return 'Diagnostic completed successfully';
    }

    final String stage =
        provider.currentStage.toLowerCase();

    if (stage.contains('download')) {
      return 'Measuring download bandwidth + ping';
    }

    if (stage.contains('upload')) {
      return 'Measuring upload bandwidth + ping';
    }

    if (stage.contains('packet') ||
        stage.contains('loss')) {
      return 'Checking packet loss';
    }

    if (stage.contains('idle') ||
        stage.contains('ping')) {
      return 'Measuring baseline latency';
    }

    if (provider.isRunning) {
      return 'Running network performance test';
    }

    return 'Ready to test connection performance';
  }

  static String shortStage(
    String stage,
  ) {
    final String value =
        stage.toLowerCase();

    if (value.contains('download')) {
      return 'DOWNLOAD';
    }

    if (value.contains('upload')) {
      return 'UPLOAD';
    }

    if (value.contains('packet') ||
        value.contains('loss')) {
      return 'PACKET LOSS';
    }

    if (value.contains('idle') ||
        value.contains('ping')) {
      return 'IDLE PING';
    }

    return 'TESTING';
  }

  static String formatNumber(
    double? value,
    String unit, {
    required int decimals,
  }) {
    if (value == null) {
      return '--';
    }

    final String formatted =
        value.toStringAsFixed(decimals);

    return unit.isEmpty
        ? formatted
        : '$formatted $unit';
  }
}