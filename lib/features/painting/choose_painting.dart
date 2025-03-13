import 'package:flutter/material.dart';
import 'package:lock_example/features/painting/pages/coloring_image_screen.dart';
import 'package:lock_example/features/painting/pages/painting_screen.dart';

class ChoosePaintingScreen extends StatefulWidget {
  const ChoosePaintingScreen({super.key});

  @override
  State<ChoosePaintingScreen> createState() => _ChoosePaintingScreenState();
}

class _ChoosePaintingScreenState extends State<ChoosePaintingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paint turini tanlang"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ColoringImageScreen(
                      imageUrl:
                          "https://img.freepik.com/free-vector/animal-doodle-macaw-parrot_1308-72449.jpg?t=st=1740245146~exp=1740248746~hmac=212b713312add7b963ea196359247912b77e5516719da6734a3c333493c166f7&w=1800",
                    ),
                  ),
                );
              },
              child: const Text("Rasmni bo‘yash"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EmptyCanvasPage(),
                  ),
                );
              },
              child: const Text("Rasm chizish"),
            ),
          ],
        ),
      ),
    );
  }
}
