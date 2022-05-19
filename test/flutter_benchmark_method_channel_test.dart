import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_benchmark/src/platform/flutter_benchmark_method_channel.dart';

void main() {
  MethodChannelFlutterBenchmark platform = MethodChannelFlutterBenchmark();
  const MethodChannel channel = MethodChannel('flutter_benchmark');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
