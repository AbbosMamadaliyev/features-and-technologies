import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class CarDetectionNoHelperScreen extends StatefulWidget {
  const CarDetectionNoHelperScreen({super.key});

  @override
  State<CarDetectionNoHelperScreen> createState() => _CarDetectionNoHelperScreenState();
}

class _CarDetectionNoHelperScreenState extends State<CarDetectionNoHelperScreen> {
  // Kamera
  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;

  // TFLite
  late Interpreter _interpreter;
  late List<String> _labels;

  // Ekran overlay
  Rect? _carBoundingBox;
  double _confidence = 0.0; // 0..1
  bool _isDetecting = false;

  // Preview layout
  GlobalKey _cameraKey = GlobalKey();
  double _previewWidth = 0;
  double _previewHeight = 0;

  int _lastInferenceTime = 0;
  final int inferenceIntervalMs = 500;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _loadModel();
  }

  @override
  void dispose() {
    if (_cameraController != null) {
      _cameraController!.stopImageStream();
    }
    _interpreter.close();
    _cameraController?.dispose();
    super.dispose();
  }

  /// 1) Kamera ishga tushirish
  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _cameraController = CameraController(
          _cameras[0], // orqa kamera
          ResolutionPreset.medium,
          enableAudio: false,
          imageFormatGroup: Platform.isIOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.yuv420,
        );
        await _cameraController!.initialize();
        setState(() {}); // CameraPreview ko‘rinishi uchun

        // Har bir freym streamida:
        await _cameraController!.startImageStream((CameraImage image) async {
          final now = DateTime.now().millisecondsSinceEpoch;
          if (_isDetecting || (now - _lastInferenceTime < inferenceIntervalMs)) {
            return;
          }
          _lastInferenceTime = now;

          _isDetecting = true;
          try {
            await _processCameraImage(image);
          } catch (e) {
            debugPrint("Error processing camera image: $e");
          } finally {
            _isDetecting = false;
          }
        });
      }
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  /// 2) Model va label fayllarini yuklash
  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model1/detect.tflite');
      final rawLabels = await rootBundle.loadString('assets/model1/labelmap.txt');
      final lines = rawLabels.split('\n');
      _labels = lines.map((e) => e.trim()).where((element) => element.isNotEmpty).toList();
      debugPrint("Model loaded. Labels: $_labels");
    } catch (e) {
      debugPrint("Error loading model: $e");
    }
  }

  /// YUV420 dan RGB ga konversiya (to'liq versiya)
  Uint8List _convertYUV420toRGB(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final int uvRowStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel ?? 1;

    final Uint8List rgbBuffer = Uint8List(width * height * 3);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int uvIndex = uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
        final int index = y * width + x;

        final int yValue = image.planes[0].bytes[y * image.planes[0].bytesPerRow + x];
        final int uValue = image.planes[1].bytes[uvIndex];
        final int vValue = image.planes[2].bytes[uvIndex];

        final int r = (yValue + 1.402 * (vValue - 128)).round().clamp(0, 255);
        final int g = (yValue - 0.344136 * (uValue - 128) - 0.714136 * (vValue - 128)).round().clamp(0, 255);
        final int b = (yValue + 1.772 * (uValue - 128)).round().clamp(0, 255);

        rgbBuffer[index * 3] = r;
        rgbBuffer[index * 3 + 1] = g;
        rgbBuffer[index * 3 + 2] = b;
      }
    }

    return rgbBuffer;
  }

  /// Kamera freymni modelga solish
  Future<void> _processCameraImage(CameraImage image) async {
    try {
      // A) YUV420 -> RGB
      final rgbBytes = _convertYUV420toRGB(image);

      // B) Rasmni resize qilish va model input tayyorlash
      const inputSize = 300;
      final int rawWidth = image.width;
      final int rawHeight = image.height;

      // Rasmni RGBA formatiga o'tkazish
      final img.Image convertedImg = img.Image.fromBytes(
        rawWidth,
        rawHeight,
        rgbBytes,
        format: img.Format.rgb,
      );

      // Rasmni model kiritish o'lchamiga resize qilish
      final img.Image resized = img.copyResize(convertedImg, width: inputSize, height: inputSize);

      // Resize qilingan rasmni raw piksel massiviga aylantiramiz
      final input = Uint8List(inputSize * inputSize * 3);
      int idx = 0;
      for (int y = 0; y < inputSize; y++) {
        for (int x = 0; x < inputSize; x++) {
          final pixel = resized.getPixel(x, y);
          final r = (pixel >> 16) & 0xFF;
          final g = (pixel >> 8) & 0xFF;
          final b = pixel & 0xFF;
          input[idx++] = r;
          input[idx++] = g;
          input[idx++] = b;
        }
      }

      // C) Run inference
      final boxesOutput = List.generate(1, (_) => List.generate(10, (_) => List.filled(4, 0.0)));
      final classesOutput = List.generate(1, (_) => List.filled(10, 0.0));
      final scoresOutput = List.generate(1, (_) => List.filled(10, 0.0));
      final countOutput = List.filled(1, 0.0);

      final outputs = {
        0: boxesOutput,
        1: classesOutput,
        2: scoresOutput,
        3: countOutput,
      };

      _interpreter.runForMultipleInputs([input.buffer.asUint8List()], outputs);

      final int detectedCount = countOutput[0].toInt();
      double bestScore = 0;
      Rect? bestRect;

      // D) Post-processing: aniqlangan obyektlar orasidan "car" ni topamiz
      for (int i = 0; i < detectedCount; i++) {
        final score = scoresOutput[0][i];
        if (score < 0.5) continue;

        final int classIdx = classesOutput[0][i].toInt();
        String label = (classIdx >= 0 && classIdx < _labels.length) ? _labels[classIdx] : 'unknown';

        if (label.toLowerCase().contains('car')) {
          final double y1 = boxesOutput[0][i][0];
          final double x1 = boxesOutput[0][i][1];
          final double y2 = boxesOutput[0][i][2];
          final double x2 = boxesOutput[0][i][3];
          if (score > bestScore) {
            bestScore = score;
            bestRect = Rect.fromLTRB(x1, y1, x2, y2);
          }
        }
      }

      if (bestRect != null) {
        if (_previewWidth == 0 || _previewHeight == 0) return;
        final double left = bestRect.left * _previewWidth;
        final double top = bestRect.top * _previewHeight;
        final double right = bestRect.right * _previewWidth;
        final double bottom = bestRect.bottom * _previewHeight;

        setState(() {
          _carBoundingBox = Rect.fromLTRB(left, top, right, bottom);
          _confidence = bestScore;
        });
      } else {
        setState(() {
          _carBoundingBox = null;
          _confidence = 0.0;
        });
      }
    } catch (e) {
      debugPrint("Error processing image: $e");
    }
  }

  /// Ekran layout o‘lchamlarini aniqlash
  void _onCameraLayoutDone(_) {
    final box = _cameraKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      setState(() {
        _previewWidth = box.size.width;
        _previewHeight = box.size.height;
      });
    }
  }

  /// Rasmga olish
  Future<String?> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return null;
    }
    final file = await _cameraController!.takePicture();
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    final cameraPreview = (_cameraController == null || !_cameraController!.value.isInitialized)
        ? const Center(child: CircularProgressIndicator())
        : CameraPreview(_cameraController!);

    return Scaffold(
      appBar: AppBar(title: const Text('Car Detection')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                WidgetsBinding.instance.addPostFrameCallback(_onCameraLayoutDone);
                return Container(
                  key: _cameraKey,
                  color: Colors.black,
                  child: Stack(
                    children: [
                      cameraPreview,
                      if (_carBoundingBox != null)
                        Positioned(
                          left: _carBoundingBox!.left,
                          top: _carBoundingBox!.top,
                          width: _carBoundingBox!.width,
                          height: _carBoundingBox!.height,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 2),
                            ),
                            child: Text(
                              "${(_confidence * 100).toStringAsFixed(0)}%",
                              style: const TextStyle(
                                backgroundColor: Colors.red,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey[200],
              child: Column(
                children: [
                  Text("Car bounding box: ${_carBoundingBox?.toString() ?? 'None'}"),
                  const SizedBox(height: 8),
                  Text("Confidence: ${(_confidence * 100).toStringAsFixed(2)}%"),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _carBoundingBox != null && _confidence > 0.5
                        ? () async {
                            final path = await _takePicture();
                            if (path != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Saved picture: $path')),
                              );
                            }
                          }
                        : null,
                    child: const Text("Take Photo (Car Found)"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
