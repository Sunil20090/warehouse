import 'package:warehouse/constants/theme_constant.dart';
import 'package:flutter/material.dart';

class ProgressCircular extends StatelessWidget {
  final double width, height;
  final EdgeInsets padding;
  final Color color;
  ProgressCircular({
    super.key,
    this.width = 25,
    this.height = 25,
    this.padding = const EdgeInsets.all(4),
    this.color = COLOR_BLACK,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      child: CircularProgressIndicator(color: color),
    );
  }
}
