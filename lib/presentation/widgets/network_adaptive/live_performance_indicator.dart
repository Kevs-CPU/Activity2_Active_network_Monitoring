import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../domain/entities/network_status.dart';
import 'live_performance_gauge.dart';
import 'network_health_helper.dart';

class LivePerformanceIndicator
    extends StatefulWidget {
  final bool isMonitoring;
  final double? strength;
  final NetworkHealth? health;

  const LivePerformanceIndicator({
    super.key,
    required this.isMonitoring,
    required this.strength,
    required this.health,
  });

  @override
  State<LivePerformanceIndicator>
      createState() =>
          _LivePerformanceIndicatorState();
}

class _LivePerformanceIndicatorState
    extends State<LivePerformanceIndicator>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  Duration? _lastElapsed;

  double _currentStrength = 0.0;
  double _targetStrength = 0.0;

  @override
  void initState() {
    super.initState();

    _currentStrength =
        safeStrength(widget.strength);

    _targetStrength =
        _currentStrength;

    _ticker = createTicker(_onTick);

    if (widget.isMonitoring) {
      _ticker.start();
    }
  }

  void _onTick(Duration elapsed) {
    if (!mounted ||
        !widget.isMonitoring) {
      return;
    }

    final double deltaSeconds;

    if (_lastElapsed == null) {
      deltaSeconds = 1.0 / 60.0;
    } else {
      deltaSeconds =
          (elapsed - _lastElapsed!)
                  .inMicroseconds /
              1000000.0;
    }

    _lastElapsed = elapsed;

    final double difference =
        _targetStrength -
            _currentStrength;

    if (difference.abs() < 0.0001) {
      _currentStrength =
          _targetStrength;
      return;
    }

    const double response = 8.0;

    final double alpha =
        1.0 -
            math.exp(
              -response *
                  deltaSeconds,
            );

    final double nextStrength =
        _currentStrength +
            (difference * alpha);

    setState(() {
      _currentStrength =
          safeStrength(nextStrength);
    });
  }

  @override
  void didUpdateWidget(
    covariant LivePerformanceIndicator
        oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    final double newTarget =
        safeStrength(widget.strength);

    _targetStrength = newTarget;

    if (!widget.isMonitoring) {
      if (_ticker.isActive) {
        _ticker.stop();
      }

      _lastElapsed = null;
      _currentStrength = 0.0;
      _targetStrength = 0.0;

      setState(() {});
      return;
    }

    if (!oldWidget.isMonitoring &&
        widget.isMonitoring) {
      _currentStrength = newTarget;
      _lastElapsed = null;

      if (!_ticker.isActive) {
        _ticker.start();
      }

      setState(() {});
      return;
    }

    if (!_ticker.isActive) {
      _lastElapsed = null;
      _ticker.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    if (!widget.isMonitoring) {
      return Text(
        'Auto-adapting',
        style: TextStyle(
          color: colorScheme.onSurface
              .withValues(alpha: 0.45),
          fontSize: 8,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    final double actualTarget =
        safeStrength(widget.strength);

    final int percentage =
        (actualTarget * 100).round();

    final Color gaugeColor =
        performanceColor(actualTarget);

    final String currentHealth =
        healthLabel(widget.health);

    final Color currentHealthColor =
        healthColor(
      widget.health,
      colorScheme,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          CrossAxisAlignment.end,
      children: [
        Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: gaugeColor.withValues(
              alpha:
                  0.08 +
                      (actualTarget * 0.08),
            ),
            borderRadius:
                BorderRadius.circular(6),
            border: Border.all(
              color: gaugeColor.withValues(
                alpha:
                    0.18 +
                        (actualTarget * 0.15),
              ),
            ),
          ),
          child: Row(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: gaugeColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                'LIVE',
                style: TextStyle(
                  color: gaugeColor,
                  fontSize: 7,
                  fontWeight:
                      FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 4),
              SizedBox(
                width: 30,
                height: 18,
                child: LivePerformanceGauge(
                  strength:
                      _currentStrength,
                  color: gaugeColor,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                '$percentage%',
                style: TextStyle(
                  color: gaugeColor,
                  fontSize: 7,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          currentHealth,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: currentHealthColor,
            fontSize: 7,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}