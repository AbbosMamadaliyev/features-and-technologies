import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lock_example/features/marjon_image_story/widgets/story_content_item.dart';

class MarjonImageStoryScreen extends StatefulWidget {
  const MarjonImageStoryScreen({super.key});

  @override
  State<MarjonImageStoryScreen> createState() => _MarjonImageStoryScreenState();
}

class _MarjonImageStoryScreenState extends State<MarjonImageStoryScreen> {
  bool didRead = false;
  bool didForward = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: Platform.isIOS
          ? SystemUiOverlayStyle.light
          : const SystemUiOverlayStyle(
              statusBarColor: Colors.black,
              systemNavigationBarColor: Colors.black,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, didRead);
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: StoryContentItem(
            story: stories,
            index: 0,
          ),
        ),
      ),
    );
  }

  List<StoryEntity> stories = [
    StoryEntity(
      mediaFullFileUrl:
          'https://img.freepik.com/free-psd/black-friday-mega-deal-social-media-story-design-template_47987-25408.jpg?t=st=1744005973~exp=1744009573~hmac=b1b425cce59b289f79e2dba39815112c68fb2ab227cf6d4cdcdb9ffe9c1b6431&w=740',
      title: 'StoryEntity  title 1',
    ),
    StoryEntity(
      mediaFullFileUrl:
          'https://img.freepik.com/free-psd/new-smartphone-social-media-story-design-template_47987-25437.jpg?t=st=1744006420~exp=1744010020~hmac=10aeaadb93a2ca7ed994e9ad8da9b5b47e5c378c7be746fbace123ca9db67c8b&w=740',
      title: 'StoryEntity  title 2',
    ),
  ];
}
