import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../flutter_benchmark_platform_interface.dart';

/// An implementation of [FlutterBenchmarkPlatform] that uses method channels.
class MethodChannelFlutterBenchmark extends FlutterBenchmarkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_benchmark');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
