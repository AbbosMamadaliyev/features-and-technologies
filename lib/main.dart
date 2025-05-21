import 'package:flutter/material.dart';
import 'package:lock_example/features/check_app_install/check_app_isntall_page.dart';
import 'package:lock_example/features/cursor_ai/cursor_ai_screen.dart';
import 'package:lock_example/features/epub_reader/epub_reader_screen.dart';
import 'package:lock_example/features/lock_example/lock_example_page.dart';
import 'package:lock_example/features/painting/choose_painting.dart';
import 'package:lock_example/features/share_to_story/share_to_story.dart';
import 'package:lock_example/features/tensor_flow/detect_car.dart';
import 'package:lock_example/features/tensor_flow/main_detect_car.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CursorAiScreen(),
    );
  }
}
