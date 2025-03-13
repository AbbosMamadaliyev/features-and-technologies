import 'dart:ui';

class PaintLine {
  List<Offset> points;
  Color color;
  double strokeWidth;

  PaintLine({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });
}
