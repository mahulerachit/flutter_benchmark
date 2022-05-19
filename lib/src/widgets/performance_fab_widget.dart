import 'package:flutter/material.dart';

import '../../flutter_benchmark.dart';

class PerformanceFabWidget extends StatefulWidget {
  const PerformanceFabWidget({Key? key}) : super(key: key);

  @override
  PerformanceFabWidgetState createState() => PerformanceFabWidgetState();
}

class PerformanceFabWidgetState extends State<PerformanceFabWidget> {
  Offset position = const Offset(20.0, 30.0);
  bool _recording = false;

  @override
  Widget build(BuildContext context) {
    return getWidget();
  }

  Widget getWidget() {
    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: position.dy,
          child: Draggable(
            feedback: _getButton(outline: true),
            onDragEnd: (details) {
              setState(() => position = details.offset);
            },
            child: _getButton(),
          ),
        ),
      ],
    );
  }

  Widget _getButton({bool outline = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          if (_recording) {
            FlutterBenchmark.instance.stopBenchmark();
          } else {
            FlutterBenchmark.instance.startBenchmark();
          }
          setState(() => _recording = !_recording);
        },
        child: Ink(
          width: 48,
          height: 48,
          decoration: outline
              ? const BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(
                    BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                )
              : const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
          child: Icon(
            _recording ? Icons.stop : Icons.bar_chart_rounded,
            color: outline ? Colors.blue : Colors.white,
          ),
        ),
      ),
    );
  }
}
