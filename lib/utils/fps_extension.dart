extension FpsExtension on Duration {
  /// Returns 0 FPS if duration is zero
  double get fpsFromMicroseconds =>
      inMicroseconds <= 0 ? 0 : (1000000 / inMicroseconds);

  /// Returns 0 FPS if duration is zero
  double get fpsFromMilliseconds =>
      inMilliseconds <= 0 ? 0 : (1000 / inMilliseconds);
}
