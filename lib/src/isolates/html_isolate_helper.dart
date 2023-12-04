// ignore_for_file: constant_identifier_names

import '../models/frame_time_compute_model.dart';
import '../utils/consts.dart';

class HtmlIsolateHelper {
  static String getHtmlIsolate(FrameTimeComputeModel frameTimeComputeModel) {
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
    final count = fpsGraph.length;

    // Min and Max framerate calculation
    double total = 0; //Initial values
    double maxFps = 0; //Initial values
    double minFps = 10000; //Initial values

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
    final averageFps = (total / fpsGraph.length).toStringAsFixed(3);

    double jankThreshold = frameTimeComputeModel.jankThresholdFrameRate;
    int totalJankTimeInSecs = 0;

    // Jank calculation
    for (var element in fpsGraph.values) {
      if (jankThreshold > element) {
        totalJankTimeInSecs++;
      }
    }

    final maxFpsString = maxFps.toStringAsFixed(3);
    final minFpsString = minFps.toStringAsFixed(3);
    final durationInMs = (lastSecond - firstSecond) * 1000;
    final jankPercentage = ((100 * totalJankTimeInSecs) / (durationInMs / 1000))
        .toStringAsFixed(2);
    final totalJankTimeInMs = totalJankTimeInSecs * 1000;

    String labels = '';
    String fpsData = '';
    String frametTimeData = '';
    String avgData = '';
    String maxData = '';
    String minData = '';

    // Frame graph map generation
    for (final epochTime in fpsGraph.keys) {
      final time = DateTime.fromMicrosecondsSinceEpoch(epochTime);
      final label =
          "'${time.minute.toString().padLeft(2, '0')}m${time.second.toString().padLeft(2, '0')}s${time.millisecond.toString().padLeft(3, '0')}ms'";
      labels += '$label, ';
      fpsData += '${fpsGraph[epochTime]!.toStringAsFixed(3)}, ';
      avgData += '$averageFps, ';
      maxData += '$maxFpsString, ';
      minData += '$minFpsString, ';
    }
    // labels = labels.substring(0, labels.length - 3);
    // fpsData = fpsData.substring(0, fpsData.length - 3);
    // frametTimeData = frametTimeData.substring(0, frametTimeData.length - 3);
    // avgData = avgData.substring(0, avgData.length - 3);
    // maxData = maxData.substring(0, maxData.length - 3);
    // minData = minData.substring(0, minData.length - 3);

    String html = _baseHtml
        .replaceFirst(ReplacementKeys.MAXFPS.value, maxFpsString)
        .replaceFirst(ReplacementKeys.MINFPS.value, minFpsString)
        .replaceFirst(ReplacementKeys.AVGFPS.value, averageFps)
        .replaceFirst(
            ReplacementKeys.JANKTIME.value, totalJankTimeInMs.toString())
        .replaceFirst(ReplacementKeys.JANKPER.value, jankPercentage)
        .replaceFirst(ReplacementKeys.TIME.value, durationInMs.toString())
        .replaceFirst(ReplacementKeys.COUNT.value, count.toString())
        .replaceFirst(ReplacementKeys.MAX.value, maxData)
        .replaceFirst(ReplacementKeys.MIN.value, minData)
        .replaceFirst(ReplacementKeys.AVG.value, avgData)
        .replaceFirst(ReplacementKeys.FRAMETIME.value, frametTimeData)
        .replaceFirst(ReplacementKeys.FPS.value, fpsData)
        .replaceFirst(ReplacementKeys.LABELS.value, labels)
        .replaceAll(', ]', ']');

    return html;
  }
}

const _baseHtml =
    '''<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<canvas id="line-chart" height="100%"></canvas>
<script>
    const ctx = document.getElementById('myChart');
    const myChart = new Chart(document.getElementById("line-chart"), {
        type: 'line',
        data: {
            labels: [*LABELS*],
            datasets: [{
                data: [*FPS*],
                label: "FPS",
                borderColor: "#3e95cd",
                fill: true
            }, {
                data: [*AVG*],
                label: "Average FPS",
                borderColor: "#3cba9f",
                borderDash: [10, 5],
                borderWidth: 1,
                pointRadius: 0,
                fill: false
            }, {
                data: [*MAX*],
                label: "Max FPS",
                borderColor: "#e8c3b9",
                borderDash: [10, 5],
                borderWidth: 1,
                pointRadius: 0,
                fill: false
            }, {
                data: [*MIN*],
                label: "Min FPS",
                borderColor: "#c45850",
                borderDash: [10, 5],
                borderWidth: 1,
                pointRadius: 0,
                fill: false
            }
            ]
        },
        options: {
            plugins: {
                title: {
                    display: true,
                    text: 'Rendered *COUNT* frames in *TIME*MS | *JANKPER*% jank (*JANKCOUNT* frames in *JANKTIME*MS) | Max FPS: *MAXFPS* | Min FPS: *MINFPS* | Average FPS: *AVGFPS*',
                    position: 'bottom',
                    font: {
                        size: 14
                    },
                    padding: {
                        top: 10,
                        bottom: 10
                    }
                }
            },
            scales: {
                y: {
                    min: 0
                },
                x: {
                    ticks: {
                        // For a category axis, the val is the index so the lookup via getLabelForValue is needed
                        callback: function(val, index) {
                            // Hide every 5th tick label
                            return index % 5 === 0 ? this.getLabelForValue(val) : '';
                        }
                    }
                }
            }
        }    
    });
</script>''';

enum ReplacementKeys {
  MAXFPS,
  MINFPS,
  AVGFPS,
  LABELS,
  FPS,
  FRAMETIME,
  AVG,
  MAX,
  MIN,
  COUNT,
  TIME,
  JANKTIME,
  JANKCOUNT,
  JANKPER,
}

extension ReplacementKeysExtension on ReplacementKeys {
  String get value {
    switch (this) {
      case ReplacementKeys.MAXFPS:
        return '*MAXFPS*';
      case ReplacementKeys.MINFPS:
        return '*MINFPS*';
      case ReplacementKeys.AVGFPS:
        return '*AVGFPS*';
      case ReplacementKeys.LABELS:
        return '*LABELS*';
      case ReplacementKeys.FPS:
        return '*FPS*';
      case ReplacementKeys.FRAMETIME:
        return '*FRAMETIME*';
      case ReplacementKeys.AVG:
        return '*AVG*';
      case ReplacementKeys.MAX:
        return '*MAX*';
      case ReplacementKeys.MIN:
        return '*MIN*';
      case ReplacementKeys.COUNT:
        return '*COUNT*';
      case ReplacementKeys.TIME:
        return '*TIME*';
      case ReplacementKeys.JANKTIME:
        return '*JANKTIME*';
      case ReplacementKeys.JANKCOUNT:
        return '*JANKCOUNT*';
      case ReplacementKeys.JANKPER:
        return '*JANKPER*';
    }
  }
}
