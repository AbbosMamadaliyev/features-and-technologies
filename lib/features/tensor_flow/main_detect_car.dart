import 'package:flutter/material.dart';
import 'package:lock_example/features/tensor_flow/detect_car.dart';

class MainDetectCarScreen extends StatefulWidget {
  const MainDetectCarScreen({super.key});

  @override
  State<MainDetectCarScreen> createState() => _MainDetectCarScreenState();
}

class _MainDetectCarScreenState extends State<MainDetectCarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detect Car'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CarDetectionNoHelperScreen()));
              },
              child: const Text('Detect Car'),
            ),
          ],
        ),
      ),
    );
  }
}
