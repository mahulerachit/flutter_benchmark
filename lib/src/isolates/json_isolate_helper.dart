import 'dart:convert';
import 'package:flutter_benchmark/src/models/frame_time_compute_model.dart';
import 'package:flutter_benchmark/src/models/frame_time_model.dart';
import '../utils/consts.dart';

class JsonIsolateHelper {
  static String getJsonIsolate(FrameTimeComputeModel frameTimeComputeModel) {
    Map<String, dynamic> map = {};
    Map<String, dynamic> frameTimeMap = {};

    // Asynchronous FPS calculation
    for (int i = 0; i < frameTimeComputeModel.frameTimeList.length; i++) {
      frameTimeComputeModel.frameTimeList[i].fps =
          frameTimeComputeModel.frameTimeList[i].timeInMicroseconds <= 0
              ? kDefaultFps
              : (kMilliSecondsInASecond /
                  frameTimeComputeModel.frameTimeList[i].timeInMicroseconds);
    }

    // Frame Time map generation
    for (FrameTimeModel frameTime in frameTimeComputeModel.frameTimeList) {
      frameTimeMap.putIfAbsent(
          frameTime.epochTime.toString(),
          () => {
                'fps': frameTime.fps.toStringAsFixed(3),
                'frameTimeInMilliseconds':
                    frameTime.timeInMicroseconds / kMilliSecondsInAMicroSecond,
              });
    }

    // Total frame count
    map.putIfAbsent('count', () => frameTimeComputeModel.frameTimeList.length);

    // Min and Max framerate calculation
    double total = 0; //Initial values
    double maxFps = 0; //Initial values
    double minFps = 1000; //Initial values
    int maxFrameTime = 10000; //Initial values
    int minFrameTime = 0; //Initial values
    for (var element in frameTimeComputeModel.frameTimeList) {
      total += element.fps;

      if (maxFps < element.fps) {
        maxFps = element.fps;
        minFrameTime = element.timeInMicroseconds;
      }
      if (minFps > element.fps) {
        minFps = element.fps;
        maxFrameTime = element.timeInMicroseconds;
      }
    }

    // Average framerate calculation
    double averageFps = total / frameTimeComputeModel.frameTimeList.length;

    double jankThreshold = frameTimeComputeModel.jankThresholdFrameRate;
    double jankFrames = 0;
    double totalJankTimeInSecs = 0;
    // Jank calculation
    for (var element in frameTimeComputeModel.frameTimeList) {
      if (jankThreshold > element.fps) {
        jankFrames++;
        totalJankTimeInSecs += element.timeInMicroseconds;
      }
    }

    map.putIfAbsent('averageFps', () => averageFps.toStringAsFixed(3));
    map.putIfAbsent('maxFps', () => maxFps.toStringAsFixed(3));
    map.putIfAbsent('minFrameTime',
        () => (minFrameTime / kMilliSecondsInAMicroSecond).toStringAsFixed(3));
    map.putIfAbsent('minFps', () => minFps.toStringAsFixed(3));
    map.putIfAbsent('maxFrameTime',
        () => (maxFrameTime / kMilliSecondsInAMicroSecond).toStringAsFixed(3));
    map.putIfAbsent('jankFrames', () => jankFrames);
    map.putIfAbsent(
        'jankPercentage',
        () => (jankFrames / frameTimeComputeModel.frameTimeList.length * 100)
            .toStringAsFixed(2));
    map.putIfAbsent('totalJankTimeInMs',
        () => totalJankTimeInSecs / kMilliSecondsInAMicroSecond);
    map.putIfAbsent('durationInMs',
        () => frameTimeComputeModel.benchmarkTime.inMilliseconds);

    map.putIfAbsent('frameTimeMap', () => frameTimeMap);
    return json.encode(map);
  }
}
