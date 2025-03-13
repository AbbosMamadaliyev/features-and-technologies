import 'package:flutter/material.dart';
import 'package:lock_example/features/painting/models/paint_line.dart';
import 'package:lock_example/features/painting/widgets/sketch_painter.dart';
import 'package:photo_view/photo_view.dart';

class ColoringImageScreen extends StatefulWidget {
  final String imageUrl;

  const ColoringImageScreen({super.key, required this.imageUrl});

  @override
  _ColoringImageScreenState createState() => _ColoringImageScreenState();
}

class _ColoringImageScreenState extends State<ColoringImageScreen> {
  final List<PaintLine> _lines = [];
  PaintLine? _currentLine;

  Color selectedColor = Colors.red; // Odatiy qizil
  double selectedStrokeWidth = 4.0; // Odatiy brush qalinligi

  // Drawing overlay uchun faqat bitta barmoqga ruxsat berish
  int _activePointers = 0;

  // Drawingni faollashtirish
  bool _activeDrawing = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rasmni bo‘yash"),
        actions: [
          IconButton(icon: Icon(Icons.undo), onPressed: _undo),
          IconButton(icon: Icon(Icons.clear), onPressed: _clear),
        ],
      ),
      body: PhotoView.customChild(
        maxScale: 4.3,
        minScale: 1.0,
        backgroundDecoration: BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            // Fon – rasm
            Positioned.fill(
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            true
                ? Positioned.fill(
                    child: Listener(
                      onPointerDown: (event) {
                        setState(() {
                          _activePointers++;
                        });
                      },
                      onPointerUp: (event) {
                        setState(() {
                          _activePointers = (_activePointers > 0) ? _activePointers - 1 : 0;
                          if (_activePointers == 0) {
                            _currentLine = null;
                          }
                        });
                      },
                      child: IgnorePointer(
                        ignoring: !_activeDrawing,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanStart: (details) {
                            if (_activePointers == 1) {
                              _startDrawing(details.localPosition);
                            }
                          },
                          onPanUpdate: (details) {
                            if (_activePointers == 1) {
                              _handleDrawUpdate(details.localPosition);
                            }
                          },
                          onPanEnd: (details) {
                            _currentLine = null;
                          },
                          child: CustomPaint(
                            painter: SketchPainter(lines: _lines),
                            child: Container(),
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // Chizishni boshlash
  void _startDrawing(Offset position) {
    setState(() {
      _currentLine = PaintLine(
        points: [position],
        color: selectedColor,
        strokeWidth: selectedStrokeWidth,
      );
      _lines.add(_currentLine!);
    });
  }

  // Chizishni yangilash
  void _handleDrawUpdate(Offset position) {
    setState(() {
      if (_currentLine != null) {
        _currentLine!.points.add(position);
      } else {
        _startDrawing(position);
      }
    });
  }

  // Pastki panel: rang tanlash va brush qalinligini sozlash
  Widget _buildBottomBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.color_lens, color: selectedColor),
            onPressed: _pickColor,
          ),
          Slider(
            value: selectedStrokeWidth,
            min: 1.0,
            max: 20.0,
            onChanged: (value) {
              setState(() {
                selectedStrokeWidth = value;
              });
            },
          ),
          Container(
            decoration: BoxDecoration(
              color: selectedColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(Icons.brush, color: Colors.white),
              onPressed: () => _activateDrawing(),
            ),
          ),
        ],
      ),
    );
  }

  void _activateDrawing() {
    setState(() {
      _activeDrawing = !_activeDrawing;
    });
  }

  // Rang tanlash dialogi
  void _pickColor() async {
    Color? picked = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Rangni tanlang"),
          children: [
            Wrap(
              children: [
                _colorOption(Colors.red),
                _colorOption(Colors.green),
                _colorOption(Colors.blue),
                _colorOption(Colors.orange),
                _colorOption(Colors.black),
                _colorOption(Colors.white),
              ],
            ),
          ],
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedColor = picked;
      });
    }
  }

  Widget _colorOption(Color color) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, color),
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.all(4),
        color: color,
      ),
    );
  }

  // Undo funksiyasi
  void _undo() {
    setState(() {
      if (_lines.isNotEmpty) {
        _lines.removeLast();
      }
    });
  }

  // Clear funksiyasi
  void _clear() {
    setState(() {
      _lines.clear();
    });
  }
}
