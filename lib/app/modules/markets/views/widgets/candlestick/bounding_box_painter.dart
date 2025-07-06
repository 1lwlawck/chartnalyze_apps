import 'package:flutter/material.dart';

class BoundingBoxPainter extends CustomPainter {
  final List<Map<String, dynamic>> results;

  BoundingBoxPainter({required this.results});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..color = Colors.red;

    final textStyle = TextStyle(color: Colors.white, fontSize: 12);

    for (var result in results) {
      final rect = Rect.fromLTWH(
        result['x'],
        result['y'],
        result['w'],
        result['h'],
      );
      canvas.drawRect(rect, paint);
      final textSpan = TextSpan(
        text:
            '${result['label']} (${(result['score'] * 100).toStringAsFixed(1)}%)',
        style: textStyle,
      );
      final tp = TextPainter(
        text: textSpan,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(rect.left, rect.top - 15));
    }
  }

  @override
  bool shouldRepaint(covariant BoundingBoxPainter oldDelegate) {
    return true;
  }
}
