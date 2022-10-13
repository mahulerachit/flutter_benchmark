import 'package:flutter/material.dart';
import 'package:flutter_benchmark/flutter_benchmark.dart';

class PerformanceFab extends StatefulWidget {
  final Widget child;
  final Offset? initialOffset;
  final bool? show;
  final Color overlayColor;
  final Color accentColor;
  const PerformanceFab({
    Key? key,
    required this.child,
    required this.initialOffset,
    required this.show,
    required this.overlayColor,
    required this.accentColor,
  }) : super(key: key);

  @override
  PerformanceFabState createState() => PerformanceFabState();
}

class PerformanceFabState extends State<PerformanceFab> {
  Offset position = const Offset(20.0, 100.0);
  bool _recording = false;
  bool _generatingReport = false;
  bool _settingsToggled = false;
  BenchmarkReportFormat _benchmarkReportFormat = BenchmarkReportFormat.html;
  @override
  void initState() {
    super.initState();
    if (widget.initialOffset != null) {
      position = widget.initialOffset!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return (widget.show == true) ? _getOverlay() : widget.child;
  }

  Widget _getOverlay() {
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
                  feedback: _getWidget(outline: true),
                  onDragEnd: (details) {
                    setState(() => position = details.offset);
                  },
                  child: _getWidget(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _getWidget({bool outline = false}) {
    return Material(
      color: Colors.transparent,
      child: AnimatedContainer(
        duration: _kAnimDuration,
        curve: Curves.fastLinearToSlowEaseIn,
        height: _settingsToggled ? _kSettingsHeight : _kBenchmarkButtonSize,
        width: _settingsToggled ? _kSettingsWidth : _kButtonsWidth,
        decoration: outline
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(_borderRadius),
                border: Border.fromBorderSide(
                  BorderSide(
                    color: widget.overlayColor,
                    width: _kBenchmarkBorderWidth,
                  ),
                ),
              )
            : BoxDecoration(
                color: widget.overlayColor,
                borderRadius: BorderRadius.circular(_borderRadius),
              ),
        child: _settingsToggled
            ? _buildSettings(outline)
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildConfigButton(outline),
                  _buildBenchmarkButton(outline),
                ],
              ),
      ),
    );
  }

  Widget _buildSettings(bool outline) {
    return outline
        ? const SizedBox()
        : ListView(
            padding: _listViewPadding,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: widget.accentColor,
                ),
                onPressed: () => setState(() => _settingsToggled = false),
              ),
              _buildRadioListTile(BenchmarkReportFormat.jsonFile),
              _buildRadioListTile(BenchmarkReportFormat.plainString),
              _buildRadioListTile(BenchmarkReportFormat.html),
            ],
          );
  }

  Widget _buildRadioListTile(BenchmarkReportFormat benchmarkReportFormat) {
    return RadioListTile<BenchmarkReportFormat>(
      dense: true,
      contentPadding: EdgeInsets.zero,
      value: benchmarkReportFormat,
      groupValue: _benchmarkReportFormat,
      activeColor: widget.accentColor,
      selectedTileColor: widget.accentColor,
      onChanged: (newFormat) {
        if (newFormat != null) {
          setState(() {
            _benchmarkReportFormat = newFormat;
          });
        }
      },
      title: Text(
        benchmarkReportFormat.getName,
        style: TextStyle(
          color: widget.accentColor,
          fontSize: _kFontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildConfigButton(bool outline) {
    return SizedBox(
      height: _kBenchmarkButtonSize,
      width: _kBenchmarkButtonSize,
      child: InkWell(
        borderRadius: BorderRadius.circular(_kBenchmarkButtonSize),
        onTap: () => setState(() => _settingsToggled = true),
        child: Ink(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.settings,
            color: outline ? widget.overlayColor : widget.accentColor,
          ),
        ),
      ),
    );
  }

  Widget _buildBenchmarkButton(bool outline) {
    return SizedBox(
      height: _kBenchmarkButtonSize,
      width: _kBenchmarkButtonSize,
      child: InkWell(
        borderRadius: BorderRadius.circular(_kBenchmarkButtonSize),
        onTap: _generatingReport ? null : _onTapToggleBenchmark,
        child: Ink(
          width: _kBenchmarkButtonSize,
          height: _kBenchmarkButtonSize,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: _generatingReport
              ? const Padding(
                  padding: EdgeInsets.all(_kBenchmarkLoadingPadding),
                  child: CircularProgressIndicator(color: Colors.cyan))
              : Icon(
                  _recording ? Icons.stop : Icons.bar_chart_rounded,
                  color: outline ? widget.overlayColor : widget.accentColor,
                ),
        ),
      ),
    );
  }

  void _onTapToggleBenchmark() async {
    switch (_recording) {
      case true:
        setState(() => _generatingReport = true);
        FlutterBenchmark.instance
            .setBenchmarkReportFormat(_benchmarkReportFormat);
        await FlutterBenchmark.instance.stopBenchmark();
        setState(() => _generatingReport = false);
        break;
      case false:
        FlutterBenchmark.instance.startBenchmark();
    }
    setState(() => _recording = !_recording);
  }
}

const _kBenchmarkButtonSize = 48.0;
const _kBenchmarkLoadingPadding = 12.0;
const _kBenchmarkBorderWidth = 2.0;
const _kButtonsWidth = 100.0;
const _kSettingsWidth = 196.0;
const _kSettingsHeight = 202.0;
const _kFontSize = 16.0;
const _borderRadius = 24.0;

const _listViewPadding = EdgeInsets.only(
  left: 16,
  top: 4,
  right: 12,
  bottom: 8,
);
const _kAnimDuration = Duration(milliseconds: 375);
