import 'package:flutter/material.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';

class LivePredictCameraView extends StatefulWidget {
  const LivePredictCameraView({super.key});

  @override
  State<LivePredictCameraView> createState() => _LivePredictCameraViewState();
}

class _LivePredictCameraViewState extends State<LivePredictCameraView> {
  late final YOLOViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YOLOViewController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Camera Prediction')),
      body: YOLOView(
        controller: _controller,
        modelPath: 'assets/best_float16.tflite',
        task: YOLOTask.detect,
        showNativeUI: true,
        onResult: (results) {
          for (final r in results) {
            debugPrint('Class: ${r.className}, Confidence: ${r.confidence}');
          }
        },
      ),
    );
  }
}
