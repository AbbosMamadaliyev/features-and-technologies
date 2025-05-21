import 'package:flutter/material.dart';
import 'package:lock_example/features/marjon_image_story/widgets/build_container.dart';

class AnimatedBar extends StatelessWidget {
  final AnimationController animationController;
  final int position;
  final int currentIndex;

  const AnimatedBar({required this.animationController, required this.currentIndex, required this.position, super.key});

  @override
  Widget build(BuildContext context) => Flexible(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.5),
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                BuildContainer(
                    color: position < currentIndex ? Colors.white : Colors.white.withOpacity(.3),
                    width: double.infinity),
                if (position == currentIndex)
                  AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) =>
                        BuildContainer(width: constraints.maxWidth * animationController.value, color: Colors.white),
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      );
}
