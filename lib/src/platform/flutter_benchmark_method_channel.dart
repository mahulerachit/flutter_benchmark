import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
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

  @override
  Future<void> shareReport(String result, String extension) async {
    await getTemporaryDirectory().then((dir) async {
      final jsonFile = File(
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.$extension');
      await jsonFile.writeAsString(result);
      Share.shareXFiles([XFile(jsonFile.path)]);
    });
  }
}
