import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_benchmark/flutter_benchmark.dart';
import 'package:flutter_benchmark/flutter_benchmark_platform_interface.dart';
import 'package:flutter_benchmark/src/platform/flutter_benchmark_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterBenchmarkPlatform
    with MockPlatformInterfaceMixin
    implements FlutterBenchmarkPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterBenchmarkPlatform initialPlatform =
      FlutterBenchmarkPlatform.instance;

  test('$MethodChannelFlutterBenchmark is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterBenchmark>());
  });

  test('getPlatformVersion', () async {
    FlutterBenchmark flutterBenchmarkPlugin = FlutterBenchmark();
    MockFlutterBenchmarkPlatform fakePlatform = MockFlutterBenchmarkPlatform();
    FlutterBenchmarkPlatform.instance = fakePlatform;

    expect(await flutterBenchmarkPlugin.getPlatformVersion(), '42');
  });
}
