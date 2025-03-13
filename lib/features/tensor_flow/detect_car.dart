import 'package:flutter/material.dart';

class DetectCarScreen extends StatefulWidget {
  const DetectCarScreen({super.key});

  @override
  State<DetectCarScreen> createState() => _DetectCarScreenState();
}

class _DetectCarScreenState extends State<DetectCarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detect Car'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // await downLoad();

            // if (filePath.isEmpty) {
            //   return;
            // }

            // EpubViewer.setConfig(
            //   themeColor: Theme.of(context).primaryColor,
            //   identifier: 'iosBook',
            //   scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
            //   allowSharing: true,
            //   enableTts: true,
            //   nightMode: true,
            // );
            // EpubViewer.open('$filePath.epub');
          },
          child: Text('Detect Car'),
        ),
      ),
    );
  }
}
