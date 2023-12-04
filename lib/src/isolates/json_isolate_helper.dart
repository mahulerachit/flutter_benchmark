import 'dart:convert';
import 'package:flutter_benchmark/src/models/frame_time_compute_model.dart';
import '../utils/consts.dart';

class JsonIsolateHelper {
  static String getJsonIsolate(FrameTimeComputeModel frameTimeComputeModel) {
    Map<String, dynamic> map = {};

    Map<int, double> fpsGraph = {};

    List<int> epochTimes =
        frameTimeComputeModel.frameTimeList.map((e) => e.epochTime).toList();

    // Sort epoch times in ascending order
    epochTimes.sort();

    // Calculate the first second
    final firstSecond = epochTimes.first ~/ kMicroSecondsInASecond;

    // Calculate FPS for each second
    int currentSecond = firstSecond;
    double frameCount = 0;

    for (int time in epochTimes) {
      int second = time ~/ kMicroSecondsInASecond;

      if (second == currentSecond) {
        frameCount++;
      } else {
        fpsGraph[currentSecond] = frameCount /
            ((time - currentSecond * kMicroSecondsInASecond) /
                kMicroSecondsInASecond);
        currentSecond = second;
        frameCount = 1;
      }
    }

    // Add the last second
    fpsGraph[currentSecond] = frameCount /
        ((epochTimes.last - currentSecond * kMicroSecondsInASecond) /
            kMicroSecondsInASecond);

    final lastSecond = currentSecond;

    // Fill the zero FPS gaps in fpsGraph
    for (int currSec = firstSecond; currSec < lastSecond; currSec++) {
      if (!fpsGraph.containsKey(currSec)) {
        fpsGraph[currSec] = 0.0;
      }
    }

    // Total frame count
    map.putIfAbsent('count', () => fpsGraph.length);

    // Min and Max framerate calculation
    double total = 0; //Initial values
    double maxFps = 0; //Initial values
    double minFps = 1000; //Initial values

    for (var element in fpsGraph.values) {
      total += element;

      if (maxFps < element) {
        maxFps = element;
      }
      if (minFps > element) {
        minFps = element;
      }
    }

    // Average framerate calculation
    final averageFps = (total / fpsGraph.length);

    double jankThreshold = frameTimeComputeModel.jankThresholdFrameRate;
    int totalJankTimeInSecs = 0;

    // Jank calculation
    for (var element in fpsGraph.values) {
      if (jankThreshold > element) {
        totalJankTimeInSecs++;
      }
    }

    final durationInMs = lastSecond - firstSecond;
    final jankPercentage =
        ((100 * totalJankTimeInSecs) / durationInMs).toStringAsFixed(2);
    final totalJankTimeInMs = totalJankTimeInSecs * 1000;

    map.putIfAbsent('averageFps', () => averageFps.toStringAsFixed(3));
    map.putIfAbsent('maxFps', () => maxFps.toStringAsFixed(3));
    map.putIfAbsent('minFps', () => minFps.toStringAsFixed(3));
    map.putIfAbsent('jankPercentage', () => jankPercentage);
    map.putIfAbsent('totalJankTimeInMs', () => totalJankTimeInMs);
    map.putIfAbsent('durationInMs', () => durationInMs);
    print('test1');
    map.putIfAbsent('frameTime', () => fpsGraph);
    print('test2');
    return json.encode(map);
  }
}
