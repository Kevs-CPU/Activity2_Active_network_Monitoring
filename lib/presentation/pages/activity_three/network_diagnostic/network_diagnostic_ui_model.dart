import 'package:flutter/material.dart';

class NetworkDiagnosticUiModel {
  final bool isRunning;
  final bool isCompleted;

  final String statusTitle;
  final String statusDescription;
  final String shortStage;

  final IconData statusIcon;

  final double progress;
  final String progressText;
  final String progressDescription;

  final DiagnosticMetricsUiModel metrics;

  final DiagnosticCurrentTestUiModel? currentTest;

  final DiagnosticHealthUiModel? health;

  final int activeStep;

  final String buttonLabel;

  final String? errorMessage;

  const NetworkDiagnosticUiModel({
    required this.isRunning,
    required this.isCompleted,
    required this.statusTitle,
    required this.statusDescription,
    required this.shortStage,
    required this.statusIcon,
    required this.progress,
    required this.progressText,
    required this.progressDescription,
    required this.metrics,
    required this.currentTest,
    required this.health,
    required this.activeStep,
    required this.buttonLabel,
    required this.errorMessage,
  });
}

class DiagnosticMetricsUiModel {
  final String idlePing;
  final String downloadSpeed;
  final String downloadPing;
  final String uploadSpeed;
  final String uploadPing;
  final String packetLoss;

  const DiagnosticMetricsUiModel({
    required this.idlePing,
    required this.downloadSpeed,
    required this.downloadPing,
    required this.uploadSpeed,
    required this.uploadPing,
    required this.packetLoss,
  });
}

class DiagnosticCurrentTestUiModel {
  final IconData icon;
  final String title;
  final String value;
  final String valueLabel;

  final String? secondary;
  final String? secondaryLabel;

  const DiagnosticCurrentTestUiModel({
    required this.icon,
    required this.title,
    required this.value,
    required this.valueLabel,
    this.secondary,
    this.secondaryLabel,
  });
}

class DiagnosticHealthUiModel {
  final String name;
  final String description;

  final double downloadMbps;
  final double uploadMbps;
  final double idlePingMs;
  final double downloadPingMs;
  final double uploadPingMs;
  final double packetLossPercent;

  final DiagnosticHealthTone tone;

  const DiagnosticHealthUiModel({
    required this.name,
    required this.description,
    required this.downloadMbps,
    required this.uploadMbps,
    required this.idlePingMs,
    required this.downloadPingMs,
    required this.uploadPingMs,
    required this.packetLossPercent,
    required this.tone,
  });
}

enum DiagnosticHealthTone {
  excellent,
  fair,
  poor,
  degraded,
  unknown,
}