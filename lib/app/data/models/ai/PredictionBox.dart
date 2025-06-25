class PredictionBox {
  final String className;
  final double confidence;
  final int x1, y1, x2, y2;

  PredictionBox({
    required this.className,
    required this.confidence,
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
  });

  factory PredictionBox.fromJson(Map<String, dynamic> json) {
    final box = json['bounding_box'];
    return PredictionBox(
      className: json['class_name'],
      confidence: json['confidence'],
      x1: box['x1'],
      y1: box['y1'],
      x2: box['x2'],
      y2: box['y2'],
    );
  }
}
