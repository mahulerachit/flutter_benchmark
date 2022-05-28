// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import '../../flutter_benchmark_platform_interface.dart';

/// A web implementation of the FlutterBenchmarkPlatform of the FlutterBenchmark plugin.
class FlutterBenchmarkWeb extends FlutterBenchmarkPlatform {
  /// Constructs a FlutterBenchmarkWeb
  FlutterBenchmarkWeb();

  static void registerWith(Registrar registrar) {
    FlutterBenchmarkPlatform.instance = FlutterBenchmarkWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }

  @override
  Future<void> shareJsonReport(String result) async {
    // Encode the result in base64
    final base64 = base64Encode(result.codeUnits);
    // Create the link with the file
    final anchor =
        html.AnchorElement(href: 'data:application/octet-stream;base64,$base64')
          ..target = 'blank';
    // add the name
    anchor.download = '${DateTime.now().millisecondsSinceEpoch}.json';
    // trigger download
    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
  }
}
