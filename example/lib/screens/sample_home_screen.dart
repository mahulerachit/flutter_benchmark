import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_benchmark/flutter_benchmark.dart';
import 'package:flutter_benchmark_example/screens/grid_view_screen.dart';

class SampleHomeScreen extends StatefulWidget {
  const SampleHomeScreen({Key? key}) : super(key: key);

  @override
  State<SampleHomeScreen> createState() => _SampleHomePageState();
}

class _SampleHomePageState extends State<SampleHomeScreen> {
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => _navigateToListViewScreen(false),
                            child: const Text(
                              'Unoptimized\nTest',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            width: 32,
                          ),
                          ElevatedButton(
                            onPressed: () => _navigateToListViewScreen(true),
                            child: const Text(
                              'Optimized\nTest',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
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

  _navigateToListViewScreen(bool shringWrap) async {
    // Set jank threshold framerate
    FlutterBenchmark.instance.setJankThresholdFrameRate(29);

    // Set the benchmark report format
    FlutterBenchmark.instance
        .setBenchmarkReportFormat(BenchmarkReportFormat.html);

    //Start automated run
    FlutterBenchmark.instance.startBenchmark();

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => GridViewScreen(
          lazyLoad: shringWrap,
        ),
      ),
    );

    // Stop benchmark, generate report and flush data
    FlutterBenchmark.instance.stopBenchmark(generateReport: true);
  }
}
