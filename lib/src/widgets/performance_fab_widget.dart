import 'package:flutter/material.dart';
import 'package:flutter_benchmark/flutter_benchmark.dart';

class PerformanceFabWidget extends StatefulWidget {
  final Widget child;
  final Offset? initialOffset;
  const PerformanceFabWidget({
    Key? key,
    required this.child,
    this.initialOffset,
  }) : super(key: key);

  @override
  PerformanceFabWidgetState createState() => PerformanceFabWidgetState();
}

class PerformanceFabWidgetState extends State<PerformanceFabWidget> {
  Offset position = const Offset(20.0, 30.0);
  bool _recording = false;
  @override
  void initState() {
    super.initState();
    if (widget.initialOffset != null) {
      position = widget.initialOffset!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return getWidget();
  }

  Widget getWidget() {
    return Stack(
      children: [
        widget.child,
        Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) => Positioned(
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
            ),
          ],
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
          width: 56,
          height: 56,
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
