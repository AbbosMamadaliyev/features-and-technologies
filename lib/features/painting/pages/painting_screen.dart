import 'package:flutter/material.dart';
import 'package:lock_example/features/painting/pages/coloring_image_screen.dart';
import 'package:lock_example/features/painting/models/paint_line.dart';

class EmptyCanvasPage extends StatefulWidget {
  const EmptyCanvasPage({super.key});

  @override
  _EmptyCanvasPageState createState() => _EmptyCanvasPageState();
}

class _EmptyCanvasPageState extends State<EmptyCanvasPage> {
  final List<PaintLine> _lines = [];
  PaintLine? _currentLine;

  Color selectedColor = Colors.black;
  double selectedStrokeWidth = 4.0;
  Color backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bo‘sh canvas")),
      body: GestureDetector(
        onPanStart: (details) {
          setState(() {
            _currentLine = PaintLine(
              points: [details.localPosition],
              color: selectedColor,
              strokeWidth: selectedStrokeWidth,
            );
            _lines.add(_currentLine!);
          });
        },
        onPanUpdate: (details) {
          setState(() {
            _currentLine?.points.add(details.localPosition);
          });
        },
        onPanEnd: (details) {
          setState(() {
            _currentLine = null;
          });
        },
        child: CustomPaint(
          painter: EmptyCanvasPainter(lines: _lines, bgColor: backgroundColor),
          child: Container(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickBackgroundColor,
        child: Icon(Icons.format_color_fill),
      ),
    );
  }

  void _pickBackgroundColor() {
    // Huddi oldingi rang tanlash usulidan foydalanish mumkin.
    // Masalan, biz backgroundColor ni o‘zgartiramiz.
    setState(() {
      backgroundColor = backgroundColor == Colors.white ? Colors.grey : Colors.white;
    });
  }
}

class EmptyCanvasPainter extends CustomPainter {
  final List<PaintLine> lines;
  final Color bgColor;

  EmptyCanvasPainter({required this.lines, required this.bgColor});

  @override
  void paint(Canvas canvas, Size size) {
    // Avval fonni bo‘yaymiz
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paintBg = Paint()..color = bgColor;
    canvas.drawRect(rect, paintBg);

    // Chiziqlarni chizish
    for (var line in lines) {
      final paint = Paint()
        ..color = line.color
        ..strokeWidth = line.strokeWidth
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < line.points.length - 1; i++) {
        if (line.points[i] != null && line.points[i + 1] != null) {
          canvas.drawLine(line.points[i], line.points[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(EmptyCanvasPainter oldDelegate) => true;
}
