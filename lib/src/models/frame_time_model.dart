class FrameTimeModel {
  final int timeInMicroseconds;
  final int epochTime;
  double fps;
  FrameTimeModel({
    required this.timeInMicroseconds,
    required this.epochTime,
    required this.fps,
  });
}
