import 'package:flutter/material.dart';
import 'package:lock_example/features/painting/models/paint_line.dart';

class SketchPainter extends CustomPainter {
  final List<PaintLine> lines;

  SketchPainter({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    for (var line in lines) {
      final paint = Paint()
        ..color = line.color
        ..strokeWidth = line.strokeWidth
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true;

      for (int i = 0; i < line.points.length - 1; i++) {
        canvas.drawLine(line.points[i], line.points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(SketchPainter oldDelegate) => true;
}
