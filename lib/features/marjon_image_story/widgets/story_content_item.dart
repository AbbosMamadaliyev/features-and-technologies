import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lock_example/features/marjon_image_story/widgets/animated_bar.dart';
import 'package:pausable_timer/pausable_timer.dart';

class StoryContentItem extends StatefulWidget {
  const StoryContentItem({
    required this.story,
    required this.index,
    super.key,
  });

  final List<StoryEntity> story;
  final int index;

  @override
  State<StoryContentItem> createState() => _StoryContentItemState();
}

class _StoryContentItemState extends State<StoryContentItem> with SingleTickerProviderStateMixin {
  ValueNotifier<bool> initialized = ValueNotifier<bool>(false);

  // ValueNotifier<bool> isCollapsed = ValueNotifier<bool>(true);

  late AnimationController animationController;
  final ValueNotifier<int> itemIndex = ValueNotifier(0);
  bool isVideo = false;
  PausableTimer? storyTimer;

  @override
  void initState() {
    super.initState();
    itemIndex.value = widget.story.length - 1;
    itemIndex.value = widget.index;

    animationController = AnimationController(vsync: this);
    startStory();
  }

  void startStory() async {
    /// start timer for image story
    startTimerForImageStory();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onLongPress: _onLongPress,
        onLongPressEnd: (e) => _onLongPress(isStopped: false),
        onTapDown: _onTapDown,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).height,
              alignment: Alignment.center,
              child: ValueListenableBuilder<int>(
                valueListenable: itemIndex,
                builder: (_, index, __) => SizedBox(
                  height: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: widget.story[index].mediaFullFileUrl,
                    imageBuilder: (context, image) => Image(
                      image: image,
                      fit: BoxFit.cover,
                    ),
                    progressIndicatorBuilder: (context, s, progress) => Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.black,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: progress.progress,
                          color: Color(0xff59DEBE),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(),
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [Colors.black.withOpacity(1), Colors.black.withOpacity(0)],
                    stops: [0, 0.5]),
              ),
              duration: const Duration(milliseconds: 150),
            ),

            /// Top bar progress indicator
            ValueListenableBuilder<int>(
              valueListenable: itemIndex,
              builder: (ctx, value, child) => Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                left: 16,
                right: 10,
                child: Row(
                  children: widget.story
                      .asMap()
                      .map(
                        (i, e) => MapEntry(
                          i,
                          AnimatedBar(
                            animationController: animationController,
                            currentIndex: value,
                            position: i,
                          ),
                        ),
                      )
                      .values
                      .toList(),
                ),
              ),
            ),

            Positioned(
              bottom: MediaQuery.paddingOf(context).bottom + 32,
              left: 16,
              right: 16,
              child: Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 200, minHeight: 80),
                alignment: Alignment.bottomLeft,
                child: ElevatedButton(
                  // margin: EdgeInsets.fromLTRB(0, 28, 0, MediaQuery.paddingOf(context).bottom + 8),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Continue'),
                  // color: Colors.blue,
                  // textColor: Colors.white,
                  // text: 'LocaleKeys.go.tr()',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    if (storyTimer != null && storyTimer!.isActive) {
      storyTimer!.cancel();
    }
    super.dispose();
  }

  /// To start timer for image story
  void startTimerForImageStory() {
    animationController
      ..stop()
      ..reset()
      ..duration = const Duration(seconds: 5)
      ..forward();
    storyTimer = PausableTimer.periodic(const Duration(seconds: 5), () {
      if (storyTimer!.tick >= 1) {
        if (itemIndex.value + 1 == widget.story.length) {
          Navigator.pop(context);
        } else {
          itemIndex.value++;
          startStory();
        }
      }
    })
      ..start();
  }

  /// To check if the story can navigate to another page
  bool get canNavigate => true;

  /// To control the player
  void _onTapDown(TapDownDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final dx = details.globalPosition.dx;
    final dy = details.globalPosition.dy;

    if (dx < screenWidth / 10 && dy < screenHeight - (canNavigate ? 54 : 0)) {
      goToPreviousStory();
    } else if (dx > 9 * screenWidth / 10 && dy < screenHeight - (canNavigate ? 54 : 0)) {
      goToNextStory();
    }
  }

  /// To control the player to play appbar progress indicator
  void _onLongPress({bool isStopped = true}) {
    if (isStopped) {
      animationController.stop();
      if (storyTimer != null && storyTimer!.isActive) {
        storyTimer!.pause();
      }
    } else {
      animationController.forward();

      /// To start timer for image story
      if (storyTimer != null) {
        storyTimer!.start();
      }
    }
  }

  /// To go to the previous story
  void goToPreviousStory() {
    try {
      if (itemIndex.value - 1 < 0) {
        Navigator.pop(context);
      } else {
        itemIndex.value--;
        startStory();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// To go to the next story
  void goToNextStory() {
    try {
      if (itemIndex.value + 1 == widget.story.length) {
        Navigator.pop(context);
      } else {
        itemIndex.value++;
        startStory();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// To stop story controllers
  void stopStoryControllers() {
    animationController.stop();
    if (storyTimer != null && storyTimer!.isActive) {
      storyTimer!.pause();
    }
  }
}

class StoryEntity {
  final String mediaFullFileUrl;
  final String title;

  StoryEntity({required this.mediaFullFileUrl, required this.title});
}
