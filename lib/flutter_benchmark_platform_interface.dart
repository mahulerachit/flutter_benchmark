import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'src/platform/flutter_benchmark_method_channel.dart';

abstract class FlutterBenchmarkPlatform extends PlatformInterface {
  /// Constructs a FlutterBenchmarkPlatform.
  FlutterBenchmarkPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterBenchmarkPlatform _instance = MethodChannelFlutterBenchmark();

  /// The default instance of [FlutterBenchmarkPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterBenchmark].
  static FlutterBenchmarkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterBenchmarkPlatform] when
  /// they register themselves.
  static set instance(FlutterBenchmarkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> shareJsonReport(String result) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
