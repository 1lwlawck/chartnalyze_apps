import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'dart:typed_data';

class TFLiteService {
  static final TFLiteService _instance = TFLiteService._internal();
  factory TFLiteService() => _instance;
  TFLiteService._internal();

  late YoloModel _model;

  Future<void> loadModel() async {
    _model = await YoloModel.create(
      modelPath: 'models/model/best_float16.tflite',
      labelsPath: 'models/label/labels.txt',
      inputShape: 640,
      useGpu: false,
    );
  }

  Future<List<YoloResult>> predict(Uint8List imageBytes) async {
    final results = await _model.inferFromBytes(bytesList: imageBytes);
    return results;
  }
}
