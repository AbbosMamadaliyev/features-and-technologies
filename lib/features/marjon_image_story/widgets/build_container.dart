import 'package:flutter/material.dart';

class BuildContainer extends StatelessWidget {
  final double width;
  final Color color;

  const BuildContainer({required this.color, required this.width, super.key});

  @override
  Widget build(BuildContext context) => Container(
        height: 2,
        width: width,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
      );
}
