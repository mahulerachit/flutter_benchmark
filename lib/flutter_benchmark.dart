import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'src/models/frame_time_compute_model.dart';
import 'src/models/frame_time_model.dart';

const _defaultFps = 60.0;
const _milliSecondsInASecond = 1000000;
const _milliSecondsInAMicroSecond = 1000;

class FlutterBenchmark {
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
        fps: _defaultFps,
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
  void stopBenchmark({bool generateReport = true}) async {
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
    if (_frameTimeList.isEmpty) {
      return;
    }

    final result = await compute(_getJsonIsolate, _getFrameTimeComputeModel());

    if (benchmarkReportFormat != null) {
      _benchmarkReportFormat = benchmarkReportFormat;
    }

    _shareReport(result);
  }

  Future<void> _shareReport(final String result) async {
    switch (_benchmarkReportFormat) {
      case BenchmarkReportFormat.jsonFile:
        {
          await getTemporaryDirectory().then((dir) async {
            final jsonFile = File(
                '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.json');
            await jsonFile.writeAsString(result);
            Share.shareFiles([jsonFile.path]);
          });
        }
        break;
      case BenchmarkReportFormat.plainString:
        Share.share(result);
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

String _getJsonIsolate(FrameTimeComputeModel frameTimeComputeModel) {
  Map<String, dynamic> map = {};
  Map<String, dynamic> frameTimeMap = {};
  _printDebugOnly(frameTimeComputeModel.frameTimeList.length,
      header: 'Frames analyzed by Benchmark');

  // Asynchronous FPS calculation
  for (int i = 0; i < frameTimeComputeModel.frameTimeList.length; i++) {
    frameTimeComputeModel.frameTimeList[i].fps =
        frameTimeComputeModel.frameTimeList[i].timeInMicroseconds <= 0
            ? _defaultFps
            : (_milliSecondsInASecond /
                frameTimeComputeModel.frameTimeList[i].timeInMicroseconds);
  }

  // Frame Time map generation
  for (FrameTimeModel frameTime in frameTimeComputeModel.frameTimeList) {
    frameTimeMap.putIfAbsent(
        frameTime.epochTime.toString(),
        () => {
              'fps': frameTime.fps,
              'frameTimeInMilliseconds':
                  frameTime.timeInMicroseconds / _milliSecondsInAMicroSecond,
            });
  }

  // Total frame count
  map.putIfAbsent('count', () => frameTimeComputeModel.frameTimeList.length);

  // Min and Max framerate calculation
  double total = 0; //Initial values
  double maxFps = 0; //Initial values
  double minFps = 1000; //Initial values
  for (var element in frameTimeComputeModel.frameTimeList) {
    total += element.fps;

    if (maxFps < element.fps) maxFps = element.fps;
    if (minFps > element.fps) minFps = element.fps;
  }

  // Average framerate calculation
  double averageFps = total / frameTimeComputeModel.frameTimeList.length;

  double jankThreshold = frameTimeComputeModel.jankThresholdFrameRate;
  double jankFrames = 0;

  // Jank calculation
  for (var element in frameTimeComputeModel.frameTimeList) {
    if (jankThreshold > element.fps) jankFrames++;
  }
  map.putIfAbsent('averageFps', () => averageFps);
  map.putIfAbsent('maxFps', () => maxFps);
  map.putIfAbsent('minFps', () => minFps);
  map.putIfAbsent('jankFrames', () => jankFrames);
  map.putIfAbsent('jankPercentage',
      () => jankFrames / frameTimeComputeModel.frameTimeList.length * 100);
  map.putIfAbsent(
      'durationInSecs', () => frameTimeComputeModel.benchmarkTime.inSeconds);

  map.putIfAbsent('frameTimeMap', () => frameTimeMap);
  return json.encode(map);
}

enum BenchmarkReportFormat {
  jsonFile,
  plainString,
}

/// Logs events when the app is running in debug mode only.
_printDebugOnly(text, {String header = ''}) {
  if (kDebugMode) print('$header: $text');
}
