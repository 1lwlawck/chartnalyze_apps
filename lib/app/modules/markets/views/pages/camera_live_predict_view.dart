import 'dart:async';
import 'package:camera/camera.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/candlestick/bounding_box_painter.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:chartnalyze_apps/app/data/services/ai/tflite_service.dart';

class LivePredictCameraView extends StatefulWidget {
  @override
  _LivePredictCameraViewState createState() => _LivePredictCameraViewState();
}

class _LivePredictCameraViewState extends State<LivePredictCameraView> {
  CameraController? _cameraController;
  late TFLiteService _tfliteService;
  bool _isDetecting = false;
  List<Map<String, dynamic>> _detections = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _tfliteService = TFLiteService();
    await _tfliteService.loadModel();

    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.back,
    );

    _cameraController = CameraController(backCamera, ResolutionPreset.medium);
    await _cameraController!.initialize();

    _cameraController!.startImageStream((image) async {
      if (_isDetecting) return;
      _isDetecting = true;

      try {
        final convertedImage = await _convertCameraImage(image);
        final results = await _tfliteService.predict(convertedImage);
        setState(() => _detections = results);
      } catch (e) {
        debugPrint("Prediction error: $e");
      }

      _isDetecting = false;
    });

    if (mounted) setState(() {});
  }

  Future<img.Image> _convertCameraImage(CameraImage image) async {
    final int width = image.width;
    final int height = image.height;
    final imgData = image.planes[0].bytes;

    return img.Image.fromBytes(width, height, imgData, format: img.Format.bgra);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          CustomPaint(
            painter: BoundingBoxPainter(results: _detections),
            child: Container(),
          ),
        ],
      ),
    );
  }
}
