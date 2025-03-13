import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lock_example/features/epub_reader/service/download_service.dart';

class EpubReaderScreen extends StatefulWidget {
  const EpubReaderScreen({super.key});

  @override
  State<EpubReaderScreen> createState() => _EpubReaderScreenState();
}

class _EpubReaderScreenState extends State<EpubReaderScreen> {
  String filePath = '';

  Future<void> downLoad() async {
    final fragmentFilePath = await DownloadService.downloadFragment(
      fileUrl:
          'https://firebasestorage.googleapis.com/v0/b/tabrik-va-tilaklar.appspot.com/o/pg75575-images.epub?alt=media&token=2027ed97-bfac-4da0-b70f-7669b1489560',
      cancelToken: CancelToken(),
      id: '1',
      type: 'epub',
    );
    log('fragmentFilePath: $fragmentFilePath');

    if (fragmentFilePath.isNotEmpty) {
      setState(() {
        filePath = fragmentFilePath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Epub Reader'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await downLoad();

            if (filePath.isEmpty) {
              return;
            }

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
          child: Text('Open Epub'),
        ),
      ),
    );
  }
}
