import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_benchmark/src/isolates/html_isolate_helper.dart';
import 'package:flutter_benchmark/src/models/frame_time_compute_model.dart';
import 'package:flutter_benchmark/src/models/frame_time_model.dart';
import 'package:flutter_benchmark/src/isolates/json_isolate_helper.dart';
import 'package:share_plus/share_plus.dart';
import 'flutter_benchmark_platform_interface.dart';
import 'src/utils/consts.dart';
import 'src/widgets/performance_fab.dart';

class FlutterBenchmark {
  Future<String?> getPlatformVersion() {
    return FlutterBenchmarkPlatform.instance.getPlatformVersion();
  }

  /// List of frame time object required to generate performance metrics
  /// when the monitoring stops.
  List<FrameTimeModel> _frameTimeList = [];

  Duration? _prev;

  bool _isMonitoring = false;

  double _jankThresholdFrameRate = 29;

  BenchmarkReportFormat _benchmarkReportFormat = BenchmarkReportFormat.jsonFile;

  Duration _benchmarkTime = Duration.zero;
  DateTime? _startTime;

  /// Instance of FlutterBenchmark.
  static FlutterBenchmark? _instance;
  static FlutterBenchmark get instance {
    _instance ??= FlutterBenchmark();
    return _instance!;
  }

  /// Call [startBenchmark] to initiate recording the performance of your app.
  /// IMP: [startBenchmark] dumps existing recorded data. If you are trying to
  /// resume benchmark without dumping data, call [resumeBenchmark] instead.
  void startBenchmark() {
    if (!_isMonitoring) {
      _isMonitoring = true;
      _dumpData();
      _startTime = DateTime.now();
      _printDebugOnly('Benchmark monitoring started');
      SchedulerBinding.instance.addPostFrameCallback(_update);
    }
  }

  /// Call [resumeBenchmark] to resume recording the performance of your app.
  /// IMP: [resumeBenchmark] will not dump the existing (if any) recorded data.
  void resumeBenchmark() {
    if (!_isMonitoring) {
      _isMonitoring = true;
      _startTime = DateTime.now();
      _printDebugOnly('Benchmark monitoring resumed');
      SchedulerBinding.instance.addPostFrameCallback(_update);
    }
  }

  /// called to dump the recorded data.
  void _dumpData() {
    _frameTimeList = [];
    _startTime = null;
    _prev = null;
    _benchmarkTime = Duration.zero;
  }

  /// Recursive funtion called to record frame time each time a frame is built.
  _update(Duration duration) {
    if (_prev != null) {
      final time = duration - _prev!;
      _frameTimeList.add(FrameTimeModel(
        epochTime: DateTime.now().millisecondsSinceEpoch,
        timeInMicroseconds: time.inMicroseconds,
        fps: kDefaultFps,
      ));
    }

    _prev = duration;
    if (_isMonitoring) {
      SchedulerBinding.instance.addPostFrameCallback(_update);
    } else {
      _printDebugOnly('Benchmark monitoring stopped');
    }
  }

  /// Call [stopBenchmark] to initiate performance recording of your app.
  Future<void> stopBenchmark({bool generateReport = true}) async {
    if (_isMonitoring) {
      _isMonitoring = false;
      _benchmarkTime += DateTime.now().difference(_startTime ?? DateTime.now());
      _startTime = DateTime.now();
      if (generateReport) {
        await _generateReport();
      }
    }
  }

  Future<void> _generateReport(
      {BenchmarkReportFormat? benchmarkReportFormat}) async {
    if (_frameTimeList.length <= 1) {
      return;
    }

    if (benchmarkReportFormat != null) {
      _benchmarkReportFormat = benchmarkReportFormat;
    }

    String result = '';
    switch (_benchmarkReportFormat) {
      case BenchmarkReportFormat.jsonFile:
        result = await compute(
          JsonIsolateHelper.getJsonIsolate,
          _getFrameTimeComputeModel(),
        );
        break;
      case BenchmarkReportFormat.plainString:
        result = await compute(
          JsonIsolateHelper.getJsonIsolate,
          _getFrameTimeComputeModel(),
        );
        break;
      case BenchmarkReportFormat.html:
        result = await compute(
          HtmlIsolateHelper.getHtmlIsolate,
          _getFrameTimeComputeModel(),
        );
        break;
    }

    _shareReport(result);
  }

  Future<void> _shareReport(final String result) async {
    switch (_benchmarkReportFormat) {
      case BenchmarkReportFormat.jsonFile:
        FlutterBenchmarkPlatform.instance.shareReport(
          result,
          BenchmarkReportFormat.jsonFile.getValue,
        );
        break;
      case BenchmarkReportFormat.plainString:
        Share.share(result);
        break;
      case BenchmarkReportFormat.html:
        FlutterBenchmarkPlatform.instance.shareReport(
          result,
          BenchmarkReportFormat.html.getValue,
        );
        break;
    }
  }

  FrameTimeComputeModel _getFrameTimeComputeModel() {
    return FrameTimeComputeModel(
        frameTimeList: _frameTimeList,
        jankThresholdFrameRate: _jankThresholdFrameRate,
        benchmarkTime: _benchmarkTime);
  }

  void setJankThresholdFrameRate(double newFrameRate) =>
      _jankThresholdFrameRate = newFrameRate;

  void setBenchmarkReportFormat(BenchmarkReportFormat newFormat) =>
      _benchmarkReportFormat = newFormat;

  double get getJankThresholdFrameRate => _jankThresholdFrameRate;

  BenchmarkReportFormat get getBenchmarkReportFormat => _benchmarkReportFormat;
}

/// Logs events when the app is running in debug mode only.
_printDebugOnly(text, {String header = ''}) {
  if (kDebugMode) print('$header: $text');
}

class PerformanceFabWidget extends StatelessWidget {
  final Widget child;
  final Offset? initialOffset;
  final bool? show;
  final Color overlayColor;
  final Color accentColor;
  const PerformanceFabWidget({
    Key? key,
    required this.child,
    this.initialOffset,
    this.show = true,
    this.overlayColor = _kOverlayColor,
    this.accentColor = _kAccentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PerformanceFab(
      initialOffset: initialOffset,
      show: show,
      accentColor: accentColor,
      overlayColor: overlayColor,
      child: child,
    );
  }
}

const _kAccentColor = Colors.blueGrey;
const _kOverlayColor = Colors.blueGrey;

enum BenchmarkReportFormat {
  jsonFile,
  plainString,
  html,
}

extension BenchmarkReportFormatExtension on BenchmarkReportFormat {
  String get getValue {
    switch (this) {
      case BenchmarkReportFormat.jsonFile:
        return 'json';

      case BenchmarkReportFormat.plainString:
        return 'txt';

      case BenchmarkReportFormat.html:
        return 'html';
    }
  }
}
