import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_benchmark/flutter_benchmark.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Benchmark Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Benchmark Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _platformVersion = 'Unknown';
  final _flutterBenchmarkPlugin = FlutterBenchmark();
  bool _renderList = false;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _flutterBenchmarkPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PerformanceFabWidget(
      initialOffset: const Offset(30, 120),
      accentColor: Colors.white,
      overlayColor: Colors.blueGrey,
      show: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Benchmark Demo Home Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: _renderList ? _getList() : const SizedBox(),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: Colors.white,
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 8),
                    Text(_platformVersion),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ElevatedButton(
                        onPressed: _cpuJank,
                        child: const Text('Trigger CPU Jank'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ElevatedButton(
                        onPressed: _gpuJank,
                        child: const Text('Trigger GPU Jank'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ElevatedButton(
                        onPressed: _combined,
                        child: const Text('Both'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ElevatedButton(
                        onPressed: _startAutomation,
                        child: const Text('Start Automation'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startAutomation() async {
    //Start automated run
    FlutterBenchmark.instance.startBenchmark();
    Future.delayed(const Duration(milliseconds: 5));

    // Pause Benchmark while retaining data
    FlutterBenchmark.instance.stopBenchmark();
    Future.delayed(const Duration(milliseconds: 5));

    // Resume Benchmark
    FlutterBenchmark.instance.resumeBenchmark();
    Future.delayed(const Duration(milliseconds: 5));

    // Set jank threshold framerate
    FlutterBenchmark.instance.setJankThresholdFrameRate(29);

    // Set the benchmark report format
    FlutterBenchmark.instance
        .setBenchmarkReportFormat(BenchmarkReportFormat.html);

    // Stop benchmark, generate report and flush data
    FlutterBenchmark.instance.stopBenchmark(generateReport: true);
  }

  void _cpuJank() {
    double temp = 0;
    for (int i = 0; i <= 1000000000; i++) {
      temp = i / 1000000000;
    }
    if (kDebugMode) {
      print(temp);
    }
  }

  void _gpuJank() {
    setState(() {
      _renderList = true;
    });
    Future.delayed(const Duration(milliseconds: 10000)).then(
      (value) => setState(
        () => _renderList = false,
      ),
    );
  }

  void _combined() {
    _cpuJank();
    _gpuJank();
  }

  Widget _getList() {
    return Wrap(
      direction: Axis.horizontal,
      children: List.generate(
        3000,
        (index) => const FlutterLogo(),
      ),
    );
  }
}
