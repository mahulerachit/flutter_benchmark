import 'frame_time_model.dart';

class FrameTimeComputeModel {
  final List<FrameTimeModel> frameTimeList;
  final double jankThresholdFrameRate;
  final Duration benchmarkTime;
  // Future enhancement
  final int? initialBattery;
  final int? finalBattery;

  FrameTimeComputeModel({
    required this.frameTimeList,
    required this.jankThresholdFrameRate,
    required this.benchmarkTime,
    this.initialBattery,
    this.finalBattery,
  });
}
